import 'dart:async';
import 'dart:convert';

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
import '../../../core/world/world_context.dart';
import '../data/memory_service.dart';

/// A built system-prompt section; [text] already includes its `【label】` header.
typedef PromptSection = ({String label, String text});

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

class ChatUiState {
  const ChatUiState({
    this.streamingText,
    this.streamingSessionId,
    this.isGenerating = false,
  });

  final String? streamingText;
  final String? streamingSessionId;
  final bool isGenerating;
}

final chatControllerProvider =
    NotifierProvider<ChatController, ChatUiState>(ChatController.new);

/// Orchestrates a single turn: persist the user message, stream the assistant
/// reply, render it as a typing effect, then persist the completed reply.
class ChatController extends Notifier<ChatUiState> with WidgetsBindingObserver {
  static final _uuid = const Uuid();
  var _cancelling = false;

  @override
  ChatUiState build() {
    WidgetsBinding.instance.addObserver(this);
    ref.onDispose(() {
      WidgetsBinding.instance.removeObserver(this);
      _currentProvider?.cancel();
    });
    return const ChatUiState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Only spin up the foreground service when the app actually goes to the
    // background mid-reply; starting it in the foreground causes a UI hitch
    // (spawning the background engine) right when the user sends.
    if (state == AppLifecycleState.paused) {
      if (this.state.isGenerating) unawaited(startReplyForeground());
    } else if (state == AppLifecycleState.resumed) {
      unawaited(stopReplyForeground());
    }
  }

  LlmProvider? _currentProvider;

  Future<void> sendMessage(String sessionId, String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || state.isGenerating) return;

    // Slash commands run locally and never touch the LLM.
    if (trimmed.startsWith('/')) {
      await _runCommand(sessionId, trimmed);
      return;
    }

    _cancelling = false;
    state = ChatUiState(
      isGenerating: true,
      streamingText: '',
      streamingSessionId: sessionId,
    );
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

    // 2. Load the session to pick its API + sampling params.
    final session = await db.getSession(sessionId);
    if (session == null) {
      state = const ChatUiState();
      throw AppException('会话不存在');
    }

    // 3. Resolve the provider (per-session override, else default).
    final config = await resolveProvider(db, ref.read(secureKeyStoreProvider),
        providerId: session.providerId);
    if (config == null) {
      state = const ChatUiState();
      throw AppException('请先在「我」中配置 API Provider');
    }

    // 4. Build the request from the session's character + history.
    final request = await _buildRequest(db, session);

    // 4. Stream and accumulate.
    final provider = buildLlmProvider(config);
    _currentProvider = provider;

    final buffer = StringBuffer();
    String? finishReason;
    try {
      try {
        await for (final chunk in provider.streamChat(request)) {
          if (chunk.finishReason != null) finishReason = chunk.finishReason;
          final delta = chunk.textDelta;
          if (delta != null && delta.isNotEmpty) {
            buffer.write(delta);
            state = ChatUiState(
              isGenerating: true,
              streamingText: buffer.toString(),
              streamingSessionId: sessionId,
            );
          }
        }
      } catch (e) {
        state = const ChatUiState();
        if (_cancelling) return;
        if (buffer.isNotEmpty) {
          // Stream interrupted mid-reply (e.g. network dropped) — persist the
          // partial text so it isn't lost, then stop quietly.
          try {
            if (await db.getSession(sessionId) != null) {
              await _persistAssistant(db, sessionId, buffer.toString());
            }
          } catch (_) {}
          return;
        }
        rethrow;
      }

      // Normal completion. Persist before clearing the streaming state so the
      // reply lands in the list before the streaming bubble is dropped — avoids
      // a one-frame flicker.
      if (_cancelling) return; // don't persist a cancelled partial reply
      if (buffer.isEmpty) {
        state = const ChatUiState();
        throw AppException(
          finishReason == 'length' || finishReason == 'max_tokens'
              ? '回复未生成：已达最大 token 数限制。请调高「会话设置」里的最大 token（思考型模型建议 8192+）。'
              : '未收到模型回复，请重试。',
        );
      }
      try {
        if (await db.getSession(sessionId) != null) {
          await _persistAssistant(db, sessionId, buffer.toString());
          unawaited(_runMemoryUpdate(db, sessionId));
        }
      } catch (_) {
        // Session deleted mid-stream — nothing to persist.
      } finally {
        state = const ChatUiState();
      }
    } finally {
      await stopReplyForeground();
    }
  }

  void cancel() {
    _cancelling = true;
    _currentProvider?.cancel();
    state = const ChatUiState();
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
    String content,
  ) async {
    if (content.isEmpty) return;
    final ts = DateTime.now().millisecondsSinceEpoch;
    final idx = await db.nextOrderIndex(sessionId);
    await db.insertMessage(MessagesCompanion.insert(
      id: _uuid.v4(),
      sessionId: sessionId,
      role: 'assistant',
      content: content,
      orderIndex: idx,
      timestamp: ts,
    ));
    await db.touchSession(sessionId, ts);
  }

  Future<ChatRequest> _buildRequest(AppDatabase db, Session session) async {
    final built = await _buildSections(db, session);
    return ChatRequest(
      messages: built.history
          .map((m) => ChatMessage(role: m.role, content: m.content))
          .toList(),
      systemPrompt: _joinSections(built.sections),
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
        ..._systemPromptSections(character, adaptation, affinity),
      ..._memorySections(
        memory,
        relation,
        skipRelation:
            character != null && MemoryService.hasSkillGrowth(character),
      ),
      ...await _worldSections(db, session, character, history),
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
      sections.add((label: '当前状态', text: '【当前状态】\n${memory.stateJson}'));
    }
    if (!skipRelation &&
        relation != null &&
        relation.relationJson.isNotEmpty &&
        relation.relationJson != '{}') {
      sections.add(
          (label: '你与用户的关系', text: '【你与用户的关系】\n${relation.relationJson}'));
    }
    return sections;
  }

  Future<List<PromptSection>> _worldSections(
    AppDatabase db,
    Session session,
    Character? character,
    List<Message> history,
  ) async {
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
    final entries = <String>[
      if (character != null)
        ...WorldbookMatcher.triggered(character.worldbookJson, recentContext),
      ...worldCtx.matchedEntries(recentContext),
    ];
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
    final config = await resolveActiveProvider(db, ref.read(secureKeyStoreProvider));
    if (config == null) return;
    try {
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
    Map<String, dynamic>? affinity,
  ) {
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

    if (description.isNotEmpty) {
      sections.add((label: '角色设定', text: '【角色设定】\n$description'));
    }
    if (personality.isNotEmpty) {
      sections.add((label: '性格', text: '【性格】\n$personality'));
    }
    if (scenario.isNotEmpty) {
      sections.add((label: '场景', text: '【场景】\n$scenario'));
    }
    // Raw skill/system prompt — added without a 【】 header.
    if (systemPrompt.isNotEmpty) {
      sections.add((label: '系统提示', text: systemPrompt));
    }
    if (affinity != null && affinity.isNotEmpty) {
      sections.add(
          (label: '好感度状态', text: '【好感度状态】\n${jsonEncode(affinity)}'));
    }
    if (firstMes.isNotEmpty) {
      sections.add((label: '开场白示例', text: '【开场白示例】\n$firstMes'));
    }

    // World-bound adaptation persona (world rules/state are injected via
    // [_worldSections] so chat/group/story share one path).
    final persona = _adaptationPersona(adaptation);
    if (persona.isNotEmpty) {
      sections.add((label: '世界适配', text: '【世界适配】\n$persona'));
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
