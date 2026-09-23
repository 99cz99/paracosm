import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/background/reply_background.dart';
import '../../../core/commands/slash_commands.dart';
import '../../../core/db/database.dart';
import '../../../core/network/llm/llm_provider.dart';
import '../../../core/network/llm/provider_factory.dart';
import '../../../core/network/llm/token_estimator.dart';
import '../../../core/providers/db_providers.dart';
import '../../../core/providers/llm_providers.dart';
import '../../../core/utils/app_exception.dart';
import '../../../core/utils/prompt_template.dart';
import '../../../core/utils/regex_scripts.dart';
import '../../../core/world/world_context.dart';
import '../data/memory_service.dart';

/// A built system-prompt section; [text] already includes its `【label】` header.
typedef PromptSection = ({String label, String text});

/// Fallback instruction for how the character should read user messages, used
/// when the character card carries no `post_history_instructions`.
const String _defaultMessageHandling =
    '【用户消息处理】\n'
    '- 用户用 (()) 或 【】 包裹的内容是场外（OOC）说明，供你参考，不要当作剧情内言行复述。\n'
    '- 其余内容按剧情内的言行与叙述理解，始终以角色身份在剧情内回应，不要跳出角色解释设定。\n'
    '- {{user}} 指代用户本人，{{char}} 指代你自己。\n'
    '- 用户一句话若含多个意图，请按顺序逐一回应。\n'
    '- 延续上文的人称、视角与文风。';

/// Estimated token usage for one would-be request (approximation).
class TokenUsage {
  const TokenUsage({
    required this.sections,
    required this.historyTokens,
    required this.contextLimit,
    required this.outputReserve,
  });

  final List<({String label, int tokens})> sections;
  final int historyTokens;
  final int contextLimit;
  final int outputReserve;

  int get baseTokens =>
      sections.fold(0, (sum, e) => sum + e.tokens) + historyTokens;
  int get available =>
      contextLimit - outputReserve < 0 ? 0 : contextLimit - outputReserve;
  int totalWith(int userInputTokens) => baseTokens + userInputTokens;
}

/// Per-session streaming state, so multiple single chats can generate in
/// parallel. Immutable — `select` on one session only rebuilds that chat.
class StreamSessionState {
  const StreamSessionState({required this.text, required this.isGenerating});

  final String text;
  final bool isGenerating;
}

class ChatUiState {
  const ChatUiState({this.streams = const {}});

  final Map<String, StreamSessionState> streams;

  bool isGenerating(String sessionId) =>
      streams[sessionId]?.isGenerating ?? false;

  bool get anyGenerating => streams.values.any((s) => s.isGenerating);
}

final chatControllerProvider =
    NotifierProvider<ChatController, ChatUiState>(ChatController.new);

/// Orchestrates a single turn: persist the user message, stream the assistant
/// reply, render it as a typing effect, then persist the completed reply.
class ChatController extends Notifier<ChatUiState> with WidgetsBindingObserver {
  static final _uuid = const Uuid();

  /// Per-session in-flight streams. Keyed by sessionId so any number of single
  /// chats can generate concurrently without stepping on each other.
  final Map<String, _SessionStream> _streams = {};

  @override
  ChatUiState build() {
    WidgetsBinding.instance.addObserver(this);
    ref.onDispose(() {
      WidgetsBinding.instance.removeObserver(this);
      for (final s in _streams.values) {
        s.provider?.cancel();
      }
      _streams.clear();
    });
    return const ChatUiState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Only spin up the foreground service when the app actually goes to the
    // background mid-reply; starting it in the foreground causes a UI hitch
    // (spawning the background engine) right when the user sends.
    if (state == AppLifecycleState.paused) {
      if (this.state.anyGenerating) unawaited(startReplyForeground());
    } else if (state == AppLifecycleState.resumed) {
      unawaited(stopReplyForeground());
    }
  }

  Future<void> sendMessage(String sessionId, String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || _streams[sessionId]?.isGenerating == true) return;

    // Slash commands run locally and never touch the LLM.
    if (trimmed.startsWith('/')) {
      await _runCommand(sessionId, trimmed);
      return;
    }

    final db = ref.read(dbProvider);

    // 1. Persist the user message immediately.
    final now = DateTime.now().millisecondsSinceEpoch;
    final userIdx = await db.nextOrderIndex(sessionId);
    await db.insertMessage(MessagesCompanion.insert(
      id: _uuid.v4(),
      sessionId: sessionId,
      role: 'user',
      content: trimmed,
      orderIndex: userIdx,
      timestamp: now,
    ));
    await db.touchSession(sessionId, now);

    await _runReply(sessionId);
  }

  /// Persists uploaded attachments (images → shown + sent to the model
  /// multimodally; files → shown only) plus an optional text caption, then
  /// triggers one reply turn if there's anything for the model to respond to.
  Future<void> sendAttachments(
    String sessionId, {
    List<String> images = const [],
    List<({String path, String name})> files = const [],
    String? caption,
  }) async {
    if (_streams[sessionId]?.isGenerating == true) return;
    final cap = caption?.trim();
    if (images.isEmpty && files.isEmpty && (cap == null || cap.isEmpty)) {
      return;
    }
    final db = ref.read(dbProvider);
    final now = DateTime.now().millisecondsSinceEpoch;
    for (final img in images) {
      final idx = await db.nextOrderIndex(sessionId);
      await db.insertMessage(MessagesCompanion.insert(
        id: _uuid.v4(),
        sessionId: sessionId,
        role: 'user',
        content: img,
        orderIndex: idx,
        timestamp: now,
        type: const Value('image'),
        visibleToAi: const Value(true),
      ));
    }
    final fileTexts = <String>[];
    final fileNotes = <String>[];
    for (final f in files) {
      final idx = await db.nextOrderIndex(sessionId);
      await db.insertMessage(MessagesCompanion.insert(
        id: _uuid.v4(),
        sessionId: sessionId,
        role: 'user',
        content: f.path,
        orderIndex: idx,
        timestamp: now,
        type: const Value('file'),
        visibleToAi: const Value(false),
        metadata: Value(jsonEncode({'filename': f.name})),
      ));
      final text = await _readTextFile(f.path);
      if (text != null) {
        fileTexts.add('（用户上传了文件：${f.name}）\n\n$text');
      } else {
        fileNotes.add(f.name);
      }
    }
    if (fileTexts.isNotEmpty) {
      final idx = await db.nextOrderIndex(sessionId);
      await db.insertMessage(MessagesCompanion.insert(
        id: _uuid.v4(),
        sessionId: sessionId,
        role: 'user',
        content: fileTexts.join('\n\n'),
        orderIndex: idx,
        timestamp: now,
      ));
    }
    if (fileNotes.isNotEmpty) {
      final idx = await db.nextOrderIndex(sessionId);
      await db.insertMessage(MessagesCompanion.insert(
        id: _uuid.v4(),
        sessionId: sessionId,
        role: 'user',
        content: '（用户上传了文件：${fileNotes.join('、')}）',
        orderIndex: idx,
        timestamp: now,
      ));
    }
    if (cap != null && cap.isNotEmpty) {
      final idx = await db.nextOrderIndex(sessionId);
      await db.insertMessage(MessagesCompanion.insert(
        id: _uuid.v4(),
        sessionId: sessionId,
        role: 'user',
        content: cap,
        orderIndex: idx,
        timestamp: now,
      ));
    }
    await db.touchSession(sessionId, now);
    if (images.isNotEmpty ||
        (cap != null && cap.isNotEmpty) ||
        fileTexts.isNotEmpty ||
        fileNotes.isNotEmpty) {
      await _runReply(sessionId);
    }
  }

  /// Resolves the provider and streams the reply for a freshly-persisted user
  /// turn (text or image).
  Future<void> _runReply(String sessionId) async {
    final db = ref.read(dbProvider);

    // 1. Load the session to pick its API + sampling params.
    final session = await db.getSession(sessionId);
    if (session == null) {
      throw AppException('会话不存在');
    }

    // 2. Resolve the provider (per-session override, else default).
    final config = await resolveProvider(db, ref.read(secureKeyStoreProvider),
        providerId: session.providerId);
    if (config == null) {
      throw AppException('请先在「我」中配置 API Provider');
    }

    // 3. Build the request from the session's character + history.
    final request = await _buildRequest(db, session);

    // 4. Stream and accumulate in a per-session slot so other single chats can
    // keep generating concurrently.
    final stream = _streams.putIfAbsent(sessionId, _SessionStream.new);
    stream.isGenerating = true;
    stream.cancelling = false;
    stream.buffer.clear();
    stream.provider = buildLlmProvider(config);
    _setStream(sessionId, text: '', isGenerating: true);

    final provider = stream.provider!;
    String? finishReason;
    int? promptTokens;
    int? completionTokens;
    // Auto-continue: when the model stops because it hit maxTokens
    // (finishReason == 'length'), feed the partial reply back + a "continue"
    // nudge and keep generating, so long replies aren't truncated.
    var messages = request.messages;
    const maxContinues = 5;
    var continues = 0;
    try {
      while (true) {
        final req = ChatRequest(
          messages: messages,
          systemPrompt: request.systemPrompt,
          temperature: request.temperature,
          topP: request.topP,
          maxTokens: request.maxTokens,
          presencePenalty: request.presencePenalty,
          frequencyPenalty: request.frequencyPenalty,
        );
        final segmentStart = stream.buffer.length;
        finishReason = null;
        try {
          await for (final chunk in provider.streamChat(req)) {
            if (chunk.finishReason != null) finishReason = chunk.finishReason;
            if (chunk.promptTokens != null) {
              promptTokens = (promptTokens ?? 0) + chunk.promptTokens!;
            }
            if (chunk.completionTokens != null) {
              completionTokens = (completionTokens ?? 0) + chunk.completionTokens!;
            }
            final delta = chunk.textDelta;
            if (delta != null && delta.isNotEmpty) {
              stream.buffer.write(delta);
              _setStream(sessionId,
                  text: stream.buffer.toString(), isGenerating: true);
            }
          }
        } catch (e) {
          _clearStream(sessionId);
          if (stream.cancelling) return;
          if (stream.buffer.isNotEmpty) {
            // Stream interrupted mid-reply (e.g. network dropped) — persist the
            // partial text so it isn't lost, then stop quietly.
            try {
              if (await db.getSession(sessionId) != null) {
                await _persistAssistant(
                  db,
                  sessionId,
                  stream.buffer.toString(),
                  promptTokens: promptTokens,
                  completionTokens: completionTokens,
                  model: config.model,
                );
              }
            } catch (_) {}
            return;
          }
          rethrow;
        }

        if (stream.cancelling) return;

        final truncated =
            finishReason == 'length' || finishReason == 'max_tokens';
        final segment = stream.buffer.toString().substring(segmentStart);
        if (truncated && segment.isNotEmpty && continues < maxContinues) {
          messages = [
            ...messages,
            ChatMessage(role: 'assistant', content: segment),
            ChatMessage(role: 'user', content: '（继续输出，直接接上文，不要重复）'),
          ];
          continues++;
          continue;
        }
        break;
      }

      // Normal completion. Persist before clearing the streaming state so the
      // reply lands in the list before the streaming bubble is dropped — avoids
      // a one-frame flicker.
      if (stream.buffer.isEmpty) {
        _clearStream(sessionId);
        throw AppException(
          finishReason == 'length' || finishReason == 'max_tokens'
              ? '回复未生成：已达最大 token 数限制。请调高「会话设置」里的最大 token（思考型模型建议 8192+）。'
              : '未收到模型回复，请重试。',
        );
      }
      try {
        if (await db.getSession(sessionId) != null) {
          await _persistAssistant(
            db,
            sessionId,
            stream.buffer.toString(),
            promptTokens: promptTokens,
            completionTokens: completionTokens,
            model: config.model,
          );
          await db.addSessionTokens(
            sessionId,
            promptTokens ?? 0,
            completionTokens ?? 0,
          );
          unawaited(_runMemoryUpdate(db, sessionId));
        }
      } catch (_) {
        // Session deleted mid-stream — nothing to persist.
      } finally {
        // Keep the reply text in the streaming slot (mark it done) until the
        // DB watch delivers the persisted message — otherwise the bubble
        // flashes empty for a frame after streaming ends.
        _setStream(sessionId,
            text: stream.buffer.toString(), isGenerating: false);
      }
    } finally {
      _streams.remove(sessionId);
      if (_streams.isEmpty) await stopReplyForeground();
    }
  }

  void cancel(String sessionId) {
    final stream = _streams[sessionId];
    if (stream == null) return;
    stream.cancelling = true;
    stream.provider?.cancel();
    _clearStream(sessionId);
  }

  void _setStream(
    String sessionId, {
    required String text,
    required bool isGenerating,
  }) {
    final next = Map<String, StreamSessionState>.from(state.streams);
    next[sessionId] =
        StreamSessionState(text: text, isGenerating: isGenerating);
    state = ChatUiState(streams: next);
  }

  void _clearStream(String sessionId) {
    final next = Map<String, StreamSessionState>.from(state.streams);
    next.remove(sessionId);
    state = ChatUiState(streams: next);
  }

  /// Executes a slash command locally: persists the user command + the app's
  /// reply as non-AI-visible messages, without calling the LLM or memory.
  Future<void> _runCommand(String sessionId, String text) async {
    final db = ref.read(dbProvider);
    final now = DateTime.now().millisecondsSinceEpoch;

    final userIdx = await db.nextOrderIndex(sessionId);
    await db.insertMessage(MessagesCompanion.insert(
      id: _uuid.v4(),
      sessionId: sessionId,
      role: 'user',
      content: text,
      orderIndex: userIdx,
      timestamp: now,
      type: const Value('command'),
      visibleToAi: const Value(false),
    ));
    await db.touchSession(sessionId, now);

    String reply;
    try {
      final session = await db.getSession(sessionId);
      reply = session == null
          ? '会话不存在'
          : await executeCommand(db, session, text);
    } catch (e) {
      reply = '指令执行失败：$e';
    }

    final replyIdx = await db.nextOrderIndex(sessionId);
    await db.insertMessage(MessagesCompanion.insert(
      id: _uuid.v4(),
      sessionId: sessionId,
      role: 'system',
      content: reply,
      orderIndex: replyIdx,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      type: const Value('command_reply'),
      visibleToAi: const Value(false),
    ));
    await db.touchSession(sessionId, DateTime.now().millisecondsSinceEpoch);
  }

  Future<void> _persistAssistant(
    AppDatabase db,
    String sessionId,
    String content, {
    int? promptTokens,
    int? completionTokens,
    String? model,
  }) async {
    if (content.isEmpty) return;
    final ts = DateTime.now().millisecondsSinceEpoch;
    final idx = await db.nextOrderIndex(sessionId);
    final metadata = <String, dynamic>{
      'promptTokens': ?promptTokens,
      'completionTokens': ?completionTokens,
      'model': ?model,
    };
    await db.insertMessage(MessagesCompanion.insert(
      id: _uuid.v4(),
      sessionId: sessionId,
      role: 'assistant',
      content: content,
      orderIndex: idx,
      timestamp: ts,
      metadata: Value(jsonEncode(metadata)),
    ));
    await db.touchSession(sessionId, ts);
  }

  Future<ChatRequest> _buildRequest(AppDatabase db, Session session) async {
    final built = await _buildSections(db, session);
    final systemPrompt = _joinSections(built.sections);

    // Hard-cap the context: if the assembled request exceeds the model's
    // window (minus the output reserve), drop the oldest history messages
    // first — they're already folded into the rolling summary, so trimming
    // them is safe. Always keep the most recent two turns.
    final limit = await _resolveContextLimit(db, session);
    final outputReserve = session.maxTokens ?? 4096;
    final rawBudget = limit - outputReserve;
    final budget = rawBudget < 1 ? 1 : rawBudget;
    final history = built.history;
    var tokens = estimateTokens(systemPrompt ?? '');
    for (final m in history) {
      tokens += estimateTokens(m.content);
    }
    var start = 0;
    while (tokens > budget && history.length - start > 2) {
      tokens -= estimateTokens(history[start].content);
      start++;
    }

    // Prompt-side regex cleanup (e.g. strip `<TTL>` status/WeChat panels from
    // old AI replies) before the history reaches the model. Depth is counted
    // from the newest message (0 = last) so `minDepth` gates older messages.
    final character = await db.getCharacter(session.characterId);
    final scripts = _parseRegexScripts(character);
    final messages = <ChatMessage>[];
    for (var i = start; i < history.length; i++) {
      final m = history[i];
      final depth = history.length - 1 - i;
      if (m.type == 'image') {
        final dataUrl = await _imageDataUrl(m.content);
        if (dataUrl != null) {
          messages.add(ChatMessage(
            role: 'user',
            content: '（用户发送了一张图片）',
            images: [dataUrl],
          ));
        }
        continue;
      }
      final content = (m.role == 'user' || m.role == 'assistant')
          ? applyPromptRegexScripts(scripts, m.content,
              role: m.role, depth: depth)
          : m.content;
      messages.add(ChatMessage(role: m.role, content: content));
    }

    return ChatRequest(
      messages: messages,
      systemPrompt: systemPrompt,
      temperature: session.temperature ?? 1.2,
      topP: session.topP ?? 1.0,
      maxTokens: session.maxTokens ?? 4096,
      presencePenalty: session.presencePenalty,
      frequencyPenalty: session.frequencyPenalty,
    );
  }

  /// Reads the session's data and builds the prompt sections + filtered history.
  Future<({List<PromptSection> sections, List<Message> history})> _buildSections(
    AppDatabase db,
    Session session,
  ) async {
    final character = await db.getCharacter(session.characterId);
    final worldId = session.worldId ?? '';
    final adaptation = await db.getAdaptation(session.characterId, worldId);
    final allMessages = await db.getMessages(session.id);
    // The opening example is only useful before the user's first real reply.
    final hasUserReply =
        allMessages.any((m) => m.role == 'user' && m.type != 'command');

    // summaryIndex is session-scoped; state + summary are world-scoped memory.
    final state = await db.getSessionState(session.id);
    final memory = character == null
        ? null
        : await db.getCharacterMemory(character.id, worldId);
    final relation = character == null
        ? null
        : await db.getCharacterRelation(character.id, worldId);

    // Only unsummarized messages are sent; summarized ones live in the prompt.
    final summaryIndex = state?.summaryIndex ?? 0;
    final history = allMessages
        .where((m) => m.orderIndex >= summaryIndex && m.visibleToAi)
        .toList();

    final affinity = character == null
        ? null
        : await _loadAffinity(db, character, worldId);

    final sections = <PromptSection>[
      if (character != null)
        ..._systemPromptSections(
          character,
          adaptation,
          affinity,
          includeExample: !hasUserReply,
        ),
      ..._memorySections(
        memory,
        relation,
        skipRelation:
            character != null && MemoryService.hasSkillGrowth(character),
      ),
      ...await _worldSections(
        db,
        session,
        character,
        history,
        depth: allMessages.length,
      ),
    ];

    // Replace {{char}}/{{user}} placeholders across all injected text.
    final userName = await db.getSetting('user_name') ?? '我';
    final charName = character?.name ?? '';
    final templated = <PromptSection>[
      for (final s in sections)
        (label: s.label, text: applyPlaceholders(s.text, charName, userName)),
    ];

    return (sections: templated, history: history);
  }

  String? _joinSections(List<PromptSection> sections) {
    if (sections.isEmpty) return null;
    return sections.map((s) => s.text).join('\n\n');
  }

  /// Estimates the token usage of the next would-be request (approximation).
  Future<TokenUsage> estimateTokenUsage(
    AppDatabase db,
    Session session,
    String userInput,
  ) async {
    final built = await _buildSections(db, session);
    final sections = <({String label, int tokens})>[
      for (final s in built.sections)
        (label: s.label, tokens: estimateTokens(s.text)),
    ];
    final historyTokens =
        built.history.fold(0, (sum, m) => sum + estimateTokens(m.content));
    return TokenUsage(
      sections: sections,
      historyTokens: historyTokens,
      contextLimit: await _resolveContextLimit(db, session),
      outputReserve: session.maxTokens ?? 4096,
    );
  }

  Future<int> _resolveContextLimit(AppDatabase db, Session session) async {
    ProviderConfig? row;
    if (session.providerId != null && session.providerId!.isNotEmpty) {
      row = await db.getProviderConfig(session.providerId!);
    }
    row ??= await db.getDefaultProviderConfig();
    return row?.contextWindowLimit ?? 32000;
  }

  Set<String> _parseWorldbookIds(String raw) {
    if (raw.isEmpty) return const {};
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded
            .map((e) => e.toString())
            .where((e) => e.isNotEmpty)
            .toSet();
      }
    } catch (_) {}
    return const {};
  }

  /// Parses a character's `core['regex_scripts']` into the script list used by
  /// [applyPromptRegexScripts] (prompt cleanup) / [applyRegexScripts] (display).
  List<Map<String, dynamic>> _parseRegexScripts(Character? c) {
    try {
      final decoded = c == null ? null : jsonDecode(c.corePersonaJson);
      final scripts = decoded is Map ? decoded['regex_scripts'] : null;
      return scripts is List
          ? [
              for (final s in scripts)
                if (s is Map) Map<String, dynamic>.from(s),
            ]
          : const [];
    } catch (_) {
      return const [];
    }
  }

  /// Reads an image file as a base64 data URL for multimodal input; null when
  /// the file can't be read.
  Future<String?> _imageDataUrl(String path) async {
    try {
      final bytes = await File(path).readAsBytes();
      return 'data:${_mimeOf(path)};base64,${base64Encode(bytes)}';
    } catch (_) {
      return null;
    }
  }

  String _mimeOf(String path) {
    final lower = path.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.gif')) return 'image/gif';
    if (lower.endsWith('.webp')) return 'image/webp';
    if (lower.endsWith('.bmp')) return 'image/bmp';
    return 'image/jpeg';
  }

  static const Set<String> _textExtensions = {
    '.txt', '.md', '.markdown', '.json', '.csv', '.log', '.yaml', '.yml',
    '.xml', '.html', '.htm', '.js', '.ts', '.py', '.dart', '.java', '.c',
    '.cpp', '.h', '.sh', '.bat', '.ini', '.cfg', '.conf',
  };

  /// Reads a text file's content for the model (null when it's not a text
  /// file, is binary, or can't be read). Long files are truncated.
  Future<String?> _readTextFile(String path) async {
    final lower = path.toLowerCase();
    final ext =
        lower.contains('.') ? lower.substring(lower.lastIndexOf('.')) : '';
    if (!_textExtensions.contains(ext)) return null;
    try {
      final bytes = await File(path).readAsBytes();
      if (bytes.contains(0)) return null; // binary
      final text = utf8.decode(bytes, allowMalformed: true).trim();
      if (text.isEmpty) return null;
      return text.length > 8000 ? text.substring(0, 8000) : text;
    } catch (_) {
      return null;
    }
  }

  List<PromptSection> _memorySections(
    CharacterMemory? memory,
    CharacterRelation? relation, {
    bool skipRelation = false,
  }) {
    final sections = <PromptSection>[];
    if (memory != null && memory.summaryText.isNotEmpty) {
      sections.add((label: '历史摘要', text: '【历史摘要】\n${memory.summaryText}'));
    }
    if (memory != null && memory.stateJson.isNotEmpty && memory.stateJson != '{}') {
      final formatted = formatStateForPrompt(memory.stateJson);
      if (formatted.isNotEmpty) {
        sections.add((label: '当前状态', text: '【当前状态】\n$formatted'));
      }
    }
    if (!skipRelation &&
        relation != null &&
        relation.relationJson.isNotEmpty &&
        relation.relationJson != '{}') {
      final formatted = formatRelationForPrompt(relation.relationJson);
      if (formatted.isNotEmpty) {
        sections.add(
            (label: '你与用户的关系', text: '【你与用户的关系】\n$formatted'));
      }
    }
    return sections;
  }

  Future<List<PromptSection>> _worldSections(
    AppDatabase db,
    Session session,
    Character? character,
    List<Message> history, {
    required int depth,
  }) async {
    final worldbookIds = session.worldbookIdsJson != null
        ? _parseWorldbookIds(session.worldbookIdsJson!)
        : character == null
            ? const <String>{}
            : (await db.getCharacterWorldbookIds(character.id)).toSet();
    final worldCtx = await WorldContextBuilder(db).build(
      worldIds: [session.worldId ?? ''],
      worldbookIds: worldbookIds,
    );
    final recent = history.length <= MemoryService.worldbookScanMessages
        ? history
        : history.sublist(history.length - MemoryService.worldbookScanMessages);
    final recentContext = recent.map((m) => m.content).join('\n');
    final worldSection = worldCtx.buildWorldSection();
    // The character's own built-in worldbook + bound library/world worldbooks.
    // A set literal dedupes across the character's built-in book and the bound
    // library/world books (same entry can trigger from both).
    final entries = <String>{
      if (character != null)
        ...WorldbookMatcher.triggered(character.worldbookJson, recentContext,
            depth: depth),
      ...worldCtx.matchedEntries(recentContext, depth: depth),
    }.toList();
    final worldbookSection =
        entries.isEmpty ? '' : '【世界书】\n${entries.join('\n\n')}';

    final sections = <PromptSection>[];
    if (worldSection.isNotEmpty) sections.add((label: '世界', text: worldSection));
    if (worldbookSection.isNotEmpty) {
      sections.add((label: '世界书', text: worldbookSection));
    }
    return sections;
  }

  Future<void> _runMemoryUpdate(AppDatabase db, String sessionId) async {
    try {
      final session = await db.getSession(sessionId);
      if (session == null) return;
      final config = await resolveProvider(
        db,
        ref.read(secureKeyStoreProvider),
        providerId: session.providerId,
      );
      if (config == null) return;
      await MemoryService(db).updateAfterTurn(
        sessionId,
        MemoryService.buildProvider(config),
      );
    } catch (_) {
      // Memory update is best-effort — never surface errors to the user.
    }
  }

  List<PromptSection> _systemPromptSections(
    Character character,
    CharacterAdaptation? adaptation,
    Map<String, dynamic>? affinity, {
    bool includeExample = true,
  }) {
    Map<String, dynamic> core;
    try {
      core = jsonDecode(character.corePersonaJson) as Map<String, dynamic>;
    } catch (_) {
      core = const {};
    }

    final sections = <PromptSection>[];
    final description = core['description']?.toString() ?? '';
    final personality = core['personality']?.toString() ?? '';
    final scenario = core['scenario']?.toString() ?? '';
    final systemPrompt = core['system_prompt']?.toString() ?? '';
    final firstMes = core['first_mes']?.toString() ?? '';
    final postHistory = core['post_history_instructions']?.toString() ?? '';

    if (description.isNotEmpty) {
      sections.add((label: '角色设定', text: '【角色设定】\n$description'));
    }
    if (personality.isNotEmpty) {
      sections.add((label: '性格', text: '【性格】\n$personality'));
    }
    if (scenario.isNotEmpty) {
      sections.add((label: '场景', text: '【场景】\n$scenario'));
    }
    final virtualAge = character.virtualAge?.trim() ?? '';
    final realAge = character.realAge?.trim() ?? '';
    if (virtualAge.isNotEmpty || realAge.isNotEmpty) {
      final lines = <String>[
        if (virtualAge.isNotEmpty) '角色对外呈现/自称的年龄：$virtualAge',
        if (realAge.isNotEmpty)
          '设定内实际年龄：$realAge（幕后设定，仅用于判断角色已成年；被问及年龄时不按这个回答）',
      ];
      if (virtualAge.isNotEmpty && realAge.isNotEmpty) {
        lines.add('被问及年龄时，按「角色对外呈现/自称的年龄」回答。');
      }
      sections.add((label: '年龄', text: '【年龄】\n${lines.join('\n')}'));
    }
    // Raw skill/system prompt — added without a 【】 header.
    if (systemPrompt.isNotEmpty) {
      sections.add((label: '系统提示', text: systemPrompt));
    }
    if (affinity != null && affinity.isNotEmpty) {
      sections.add(
          (label: '好感度状态', text: '【好感度状态】\n${jsonEncode(affinity)}'));
    }
    // The opening example is dropped once the user has replied (redundant).
    if (firstMes.isNotEmpty && includeExample) {
      sections.add((label: '开场白示例', text: '【开场白示例】\n$firstMes'));
    }

    // World-bound adaptation persona (world rules/state are injected via
    // [_worldSections] so chat/group/story share one path).
    final persona = _adaptationPersona(adaptation);
    if (persona.isNotEmpty) {
      sections.add((label: '世界适配', text: '【世界适配】\n$persona'));
    }

    // How to read user messages: the character's own instruction when present,
    // otherwise the app's concise default.
    if (postHistory.isNotEmpty) {
      sections.add((label: '后置指令', text: '【后置指令】\n$postHistory'));
    } else {
      sections.add((label: '用户消息处理', text: _defaultMessageHandling));
    }

    return sections;
  }

  /// Resolves the skill growth state for a character in a world: the per-world
  /// stored state if present, otherwise the seed from `core['affinity']`.
  Future<Map<String, dynamic>?> _loadAffinity(
    AppDatabase db,
    Character character,
    String worldId,
  ) async {
    Map<String, dynamic> core;
    try {
      core = jsonDecode(character.corePersonaJson) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
    final seedRaw = core['affinity'];
    if (seedRaw is! Map || seedRaw.isEmpty) return null;
    final seed = Map<String, dynamic>.from(seedRaw);

    final row = await db.getCharacterAffinity(character.id, worldId);
    if (row != null) {
      try {
        final a = jsonDecode(row.affinityJson) as Map<String, dynamic>;
        if (a.isNotEmpty) return a;
      } catch (_) {}
    }
    return seed;
  }

  String _adaptationPersona(CharacterAdaptation? adaptation) {
    if (adaptation == null) return '';
    try {
      final map = jsonDecode(adaptation.adaptationJson) as Map<String, dynamic>;
      return (map['persona'] ?? '').toString().trim();
    } catch (_) {
      return '';
    }
  }
}

/// Mutable per-session streaming state held by [ChatController]. Kept out of
/// [ChatUiState] (which is immutable) so the map is cheap to copy per delta.
class _SessionStream {
  LlmProvider? provider;
  final StringBuffer buffer = StringBuffer();
  bool cancelling = false;
  bool isGenerating = false;
}
