import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../core/db/database.dart';
import '../../../core/network/llm/llm_provider.dart';
import '../../../core/network/llm/provider_config.dart';
import '../../../core/network/llm/provider_factory.dart';
import '../../../core/world/world_context.dart';

/// Memory subsystem: per-turn state/relation extraction, rolling summary, and
/// worldbook keyword injection.
///
/// Extraction and summarization use a (possibly cheaper) model — resolved via
/// [LlmProviderConfig.memoryModel] when set. Worldbook matching is pure string
/// matching, no LLM.
class MemoryService {
  MemoryService(this._db);

  final AppDatabase _db;

  /// Summarize when unsummarized messages exceed this count.
  static const int summaryWindow = 8;

  /// Keep this many recent messages unsummarized after a run.
  static const int keepRecent = 4;

  /// Scan this many recent messages for worldbook keywords.
  static const int worldbookScanMessages = 6;

  /// How many recent messages the state/relation extraction sees each turn.
  static const int stateExtractWindow = 6;

  /// Builds a provider for memory tasks, overriding the model with
  /// [LlmProviderConfig.memoryModel] when set (the "cheap model").
  static LlmProvider buildProvider(LlmProviderConfig config) {
    final model = (config.memoryModel?.isNotEmpty ?? false)
        ? config.memoryModel!
        : config.model;
    return buildLlmProvider(LlmProviderConfig(
      id: config.id,
      name: config.name,
      type: config.type,
      baseUrl: config.baseUrl,
      model: model,
      apiKey: config.apiKey,
      extraParams: config.extraParams,
    ));
  }

  /// Runs after an assistant turn. Best-effort — never throws to the caller.
  Future<void> updateAfterTurn(String sessionId, LlmProvider provider) async {
    final session = await _db.getSession(sessionId);
    if (session == null) return;
    final character = await _db.getCharacter(session.characterId);
    if (character == null) return;

    // Only AI-visible conversation feeds memory; slash commands + their replies
    // (visibleToAi=false) must not pollute the summary/state/relation.
    final messages = (await _db.getMessages(sessionId))
        .where((m) => m.visibleToAi)
        .toList();
    if (messages.isEmpty) return;

    final worldId = session.worldId ?? '';
    final ageContext = _ageContext(character);
    await _maybeSummarize(
        character.id, worldId, sessionId, provider, messages, ageContext);
    await _extractMemory(character, worldId, provider, messages, ageContext);

    await provider.cancel();
  }

  /// Returns worldbook entries whose keys match the recent context (pure).
  /// Delegates to [WorldbookMatcher] so chat/group/story share one matcher.
  static List<String> triggeredWorldbook(String? worldbookJson, List<Message> recent) =>
      WorldbookMatcher.triggered(
        worldbookJson,
        recent.map((m) => m.content).join('\n'),
      );

  /// True when a character carries its own growth state (a non-empty
  /// `core['affinity']`, i.e. the skill shipped a `references/affinity.json`).
  /// For such characters the app defers to the skill's growth rules instead of
  /// the generic user↔character relation.
  static bool hasSkillGrowth(Character character) {
    try {
      final core = jsonDecode(character.corePersonaJson) as Map<String, dynamic>;
      return core['affinity'] is Map && (core['affinity'] as Map).isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// Coerces a reflected affinity into the canonical schema, clamping numeric
  /// axes to their valid ranges and keeping unknown keys from drifting.
  static Map<String, dynamic> sanitizeAffinity(
    Map<String, dynamic> existing,
    Map<String, dynamic> updated,
  ) {
    final out = Map<String, dynamic>.from(existing);
    int? toInt(dynamic v, int lo, int hi) {
      final n = v is num ? v.toInt() : int.tryParse(v?.toString() ?? '');
      if (n == null) return null;
      return n.clamp(lo, hi);
    }

    void setInt(String key, int lo, int hi) {
      final n = toInt(updated[key], lo, hi);
      if (n != null) out[key] = n;
    }

    setInt('trust_level', 0, 5);
    setInt('trust_value', 0, 100);
    setInt('corruption_value', 0, 100);
    setInt('corruption_level', 0, 5);
    setInt('total_h_scenes_completed', 0, 1000000);
    if (updated['corruption_milestones'] is Map) {
      out['corruption_milestones'] = updated['corruption_milestones'];
    }
    out['last_session'] = DateTime.now().toIso8601String().substring(0, 10);
    return out;
  }

  // --- internal ----------------------------------------------------------

  Future<void> _maybeSummarize(
    String characterId,
    String worldId,
    String sessionId,
    LlmProvider provider,
    List<Message> messages,
    String ageContext,
  ) async {
    final state = await _db.getSessionState(sessionId);
    final summaryIndex = state?.summaryIndex ?? 0;
    final unsummarized = messages.where((m) => m.orderIndex >= summaryIndex).length;
    if (unsummarized <= summaryWindow) return;

    final cutoff = messages.length - keepRecent;
    if (cutoff <= summaryIndex) return;
    final toSummarize = messages
        .where((m) => m.orderIndex >= summaryIndex && m.orderIndex < cutoff)
        .toList();
    if (toSummarize.isEmpty) return;

    final memory = await _db.getCharacterMemory(characterId, worldId);
    var existing = memory?.summaryText ?? '';
    // A previously-stored safety-filter refusal isn't a real summary — start
    // fresh instead of merging new content into the refusal text.
    if (_looksLikeRefusal(existing)) existing = '';
    final transcript =
        toSummarize.map((m) => '${m.role}: ${m.content}').join('\n');
    var summary = await _summarize(provider, existing, transcript, ageContext);
    if (summary.isEmpty) {
      // Reasoning models can burn their token budget and return nothing —
      // retry once. If still empty, leave the cursor alone so those messages
      // are not silently dropped into a void (they'll be retried next turn).
      summary = await _summarize(provider, existing, transcript, ageContext);
    }
    if (summary.isEmpty) return;

    // Summary is world-scoped (survives session deletion); summaryIndex stays
    // session-scoped (marks how far this session has been summarized).
    await _db.upsertCharacterMemory(CharacterMemoriesCompanion.insert(
      characterId: characterId,
      worldId: Value(worldId),
      summaryText: Value(summary),
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    ));
    await _db.upsertSessionState(SessionStatesCompanion.insert(
      sessionId: sessionId,
      summaryIndex: Value(cutoff),
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    ));
  }

  Future<String> _summarize(
    LlmProvider provider,
    String existing,
    String transcript,
    String ageContext,
  ) async {
    final prompt = existing.isEmpty
        ? '把以下对话压缩成简短摘要（保留关键事件、未完成的事、地点与时间线索、人物状态与关系变化、重要物件）：\n\n$transcript\n\n摘要：'
        : '已有摘要：\n$existing\n\n新增对话：\n$transcript\n\n'
            '把两者合并成一份更完整但仍简短的摘要（控制在 300 字内，保留关键事件、未完成的事、地点/时间、人物关系变化）：';
    final systemPrompt = '你是对话摘要器，输出简洁中文，不要任何标记。'
        '${ageContext.isEmpty ? '' : '\n$ageContext'}';
    final text = await _complete(
      provider,
      prompt,
      systemPrompt: systemPrompt,
      maxTokens: 2048,
      temperature: 0.3,
    );
    final summary = text.trim();
    // A safety-filter refusal isn't a summary — treat it as empty so the
    // caller keeps the previous summary instead of storing the refusal text.
    if (_looksLikeRefusal(summary)) return '';
    return summary;
  }

  /// Heuristic for a model safety-filter refusal (e.g. "抱歉，我无法处理…").
  bool _looksLikeRefusal(String text) {
    if (text.isEmpty) return false;
    const markers = [
      '无法处理',
      '涉及未成年',
      '不能提供',
      '不能生成',
      '抱歉，我无法',
      '我不能',
    ];
    return markers.any(text.contains);
  }

  /// Extracts structured state + relation (or skill growth) in ONE LLM call,
  /// so per-turn memory work is a single call instead of two. Best-effort:
  /// on any failure we keep the current values.
  Future<void> _extractMemory(
    Character character,
    String worldId,
    LlmProvider provider,
    List<Message> messages,
    String ageContext,
  ) async {
    final transcript = _recentTranscript(messages);
    if (transcript.isEmpty) return;

    final skill = hasSkillGrowth(character);
    final memory = await _db.getCharacterMemory(character.id, worldId);
    final currentState = memory?.stateJson ?? '{}';

    final String prompt;
    Map<String, dynamic>? currentAffinity;
    String? currentRelation;
    if (skill) {
      final seed = _affinitySeed(character);
      if (seed == null) return;
      currentAffinity = await _currentAffinity(character.id, worldId, seed);
      prompt = _combinedPrompt(
        currentState,
        relation: null,
        affinity: jsonEncode(currentAffinity),
        transcript: transcript,
      );
    } else {
      final relation = await _db.getCharacterRelation(character.id, worldId);
      currentRelation = relation?.relationJson ?? '{}';
      prompt = _combinedPrompt(
        currentState,
        relation: currentRelation,
        affinity: null,
        transcript: transcript,
      );
    }

    // Reasoning models can burn their token budget on thinking and return an
    // empty `content`, so budget plenty of headroom.
    final text = await _complete(
      provider,
      prompt,
      systemPrompt: '你是结构化信息提取器。只输出 JSON，不要解释、不要代码块。'
          '${ageContext.isEmpty ? '' : '\n$ageContext'}',
      maxTokens: 16384,
    );
    final raw = _parseJsonObject(text);
    if (raw == null) return;
    final Map<String, dynamic> parsed;
    try {
      parsed = jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return;
    }

    final state = parsed['state'];
    if (state is Map && state.isNotEmpty) {
      await _db.upsertCharacterMemory(CharacterMemoriesCompanion.insert(
        characterId: character.id,
        worldId: Value(worldId),
        stateJson: Value(jsonEncode(state)),
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      ));
    }

    if (skill) {
      final affinity = parsed['affinity'];
      if (affinity is Map && affinity.isNotEmpty && currentAffinity != null) {
        await _writeBackAffinity(
          character.id,
          worldId,
          sanitizeAffinity(currentAffinity, Map<String, dynamic>.from(affinity)),
        );
      }
    } else {
      final relation = parsed['relation'];
      if (relation is Map && relation.isNotEmpty) {
        await _db.upsertCharacterRelation(CharacterRelationsCompanion.insert(
          characterId: character.id,
          worldId: Value(worldId),
          relationJson: Value(jsonEncode(relation)),
          updatedAt: DateTime.now().millisecondsSinceEpoch,
        ));
      }
    }
  }

  Map<String, dynamic>? _affinitySeed(Character character) {
    try {
      final core = jsonDecode(character.corePersonaJson) as Map<String, dynamic>;
      final seed = core['affinity'];
      return seed is Map && seed.isNotEmpty
          ? Map<String, dynamic>.from(seed)
          : null;
    } catch (_) {
      return null;
    }
  }

  /// Short age context injected into memory prompts so the memory model sees
  /// the same age information the chat prompt carries (avoids false-flagging
  /// adult roleplay as involving minors). Empty when no age is declared.
  String _ageContext(Character character) {
    final realAge = character.realAge?.trim() ?? '';
    final virtualAge = character.virtualAge?.trim() ?? '';
    if (realAge.isEmpty && virtualAge.isEmpty) return '';
    final parts = <String>[
      if (realAge.isNotEmpty) '角色设定实际年龄为 $realAge',
      if (virtualAge.isNotEmpty) '角色对外年龄为 $virtualAge',
      if (realAge.isNotEmpty) '对话中出现的其他角色（NPC）同样为成年设定',
    ];
    return '背景：${parts.join('，')}。';
  }

  Future<Map<String, dynamic>> _currentAffinity(
    String characterId,
    String worldId,
    Map<String, dynamic> seed,
  ) async {
    final row = await _db.getCharacterAffinity(characterId, worldId);
    if (row != null) {
      try {
        final a = jsonDecode(row.affinityJson) as Map<String, dynamic>;
        if (a.isNotEmpty) return a;
      } catch (_) {}
    }
    return seed;
  }

  Future<void> _writeBackAffinity(
    String characterId,
    String worldId,
    Map<String, dynamic> affinity,
  ) async {
    await _db.upsertCharacterAffinity(CharacterAffinitiesCompanion.insert(
      characterId: characterId,
      worldId: Value(worldId),
      affinityJson: Value(jsonEncode(affinity)),
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    ));
  }

  /// Builds a transcript of the most recent visible (user/assistant) messages
  /// for state/relation extraction. A window (rather than only the last turn)
  /// keeps key facts from slipping away between summary runs.
  String _recentTranscript(List<Message> messages) {
    final visible = messages
        .where((m) =>
            (m.role == 'user' || m.role == 'assistant') && m.visibleToAi)
        .toList();
    final recent = visible.length <= stateExtractWindow
        ? visible
        : visible.sublist(visible.length - stateExtractWindow);
    return recent.map((m) => '${m.role}: ${m.content}').join('\n');
  }

  /// One prompt that asks the model to update both state and relation (or
  /// skill growth) at once, returning a single `{state, relation|affinity}`
  /// object.
  String _combinedPrompt(
    String state, {
    required String? relation,
    required String? affinity,
    required String transcript,
  }) {
    final stateSeed = state == '{}'
        ? '{"time":"","place":"","scene":"","environment":"","char_outfit":"","char_body":"","nearby_items":[],"npcs":{},"style":{"person":"","perspective":"","onomatopoeia":""},"facts":[]}'
        : state;
    final buffer = StringBuffer('当前状态 JSON：\n$stateSeed\n\n');
    if (affinity != null) {
      buffer.writeln('当前成长状态 JSON：\n$affinity\n\n');
      buffer.writeln('最近对话：\n$transcript\n\n');
      buffer.writeln(
        '根据对话同时更新状态和成长值，输出一个 JSON 对象：'
        '{"state": {...}, "affinity": {...}}。'
        '状态维度：time 时间、place 地点、scene 场景、environment 环境、'
        'char_outfit 角色服装、char_body 角色身体、nearby_items 周围物品、'
        'npcs 在场人物、style 文风、facts 已确认事实。'
        '成长值：trust_value/trust_level 随互动升降、corruption_value/corruption_level 只升不降、'
        'total_h_scenes_completed、corruption_milestones。只输出 JSON。',
      );
    } else {
      buffer.writeln('当前关系 JSON：\n$relation\n\n');
      buffer.writeln('最近对话：\n$transcript\n\n');
      buffer.writeln(
        '根据对话同时更新状态和关系，输出一个 JSON 对象：'
        '{"state": {...}, "relation": {...}}。'
        '状态维度：time 时间、place 地点、scene 场景、environment 环境、'
        'char_outfit 角色服装、char_body 角色身体、nearby_items 周围物品、'
        'npcs 在场人物、style 文风、facts 已确认事实。'
        '关系：affection 好感、trust 信任、intimacy 亲密度（0-100）、notes 简述。只输出 JSON。',
      );
    }
    return buffer.toString();
  }

  Future<String> _complete(
    LlmProvider provider,
    String prompt, {
    String? systemPrompt,
    int maxTokens = 1024,
    double temperature = 0.2,
  }) async {
    final buffer = StringBuffer();
    await for (final chunk in provider.streamChat(ChatRequest(
      messages: [ChatMessage(role: 'user', content: prompt)],
      systemPrompt: systemPrompt,
      maxTokens: maxTokens,
      temperature: temperature,
    ))) {
      if (chunk.textDelta != null) buffer.write(chunk.textDelta);
    }
    return buffer.toString();
  }

  String? _parseJsonObject(String text) {
    final start = text.indexOf('{');
    final end = text.lastIndexOf('}');
    if (start < 0 || end <= start) return null;
    final candidate = text.substring(start, end + 1);
    try {
      jsonDecode(candidate);
      return candidate;
    } catch (_) {
      return null;
    }
  }
}
