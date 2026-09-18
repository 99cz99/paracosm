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
  static const int summaryWindow = 20;

  /// Keep this many recent messages unsummarized after a run.
  static const int keepRecent = 8;

  /// Scan this many recent messages for worldbook keywords.
  static const int worldbookScanMessages = 6;

  /// How many recent messages the skill-growth reflection sees.
  static const int growthReflectWindow = 12;

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

    final messages = await _db.getMessages(sessionId);
    if (messages.isEmpty) return;

    final worldId = session.worldId ?? '';
    await _maybeSummarize(character.id, worldId, sessionId, provider, messages);
    await _extractState(character.id, worldId, provider, messages);
    if (hasSkillGrowth(character)) {
      // The skill manages its own growth axes — reflect them back instead of
      // the generic user↔character relation, which would conflict.
      await _reflectSkillGrowth(character, worldId, provider, messages);
    } else {
      await _extractRelation(character.id, worldId, provider, messages);
    }

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
    final existing = memory?.summaryText ?? '';
    final transcript =
        toSummarize.map((m) => '${m.role}: ${m.content}').join('\n');
    final summary = await _summarize(provider, existing, transcript);

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
  ) async {
    final prompt = existing.isEmpty
        ? '把以下对话压缩成简短摘要（保留关键事实、人物状态、未完成的事）：\n\n$transcript\n\n摘要：'
        : '已有摘要：\n$existing\n\n新增对话：\n$transcript\n\n把两者合并成一份更完整但仍简短的摘要：';
    final text = await _complete(
      provider,
      prompt,
      systemPrompt: '你是对话摘要器，输出简洁中文，不要任何标记。',
      maxTokens: 512,
      temperature: 0.3,
    );
    return text.trim();
  }

  Future<void> _extractState(
    String characterId,
    String worldId,
    LlmProvider provider,
    List<Message> messages,
  ) async {
    final exchange = _lastExchange(messages);
    if (exchange == null) return;
    final memory = await _db.getCharacterMemory(characterId, worldId);
    final currentState = memory?.stateJson ?? '{}';
    final newState = await _extractJson(
      provider,
      _statePrompt(currentState, exchange),
      fallback: currentState,
    );
    await _db.upsertCharacterMemory(CharacterMemoriesCompanion.insert(
      characterId: characterId,
      worldId: Value(worldId),
      stateJson: Value(newState),
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    ));
  }

  Future<void> _extractRelation(
    String characterId,
    String worldId,
    LlmProvider provider,
    List<Message> messages,
  ) async {
    final exchange = _lastExchange(messages);
    if (exchange == null) return;
    final relation = await _db.getCharacterRelation(characterId, worldId);
    final currentRelation = relation?.relationJson ?? '{}';
    final newRelation = await _extractJson(
      provider,
      _relationPrompt(currentRelation, exchange),
      fallback: currentRelation,
    );
    await _db.upsertCharacterRelation(CharacterRelationsCompanion.insert(
      characterId: characterId,
      worldId: Value(worldId),
      relationJson: Value(newRelation),
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    ));
  }

  /// Reflects a skill character's own growth axes back into `core['affinity']`
  /// so trust/corruption accumulate across sessions. The skill's rules live in
  /// `core['system_prompt']`, so they are passed to the reflection model as
  /// context (this is the heavier of the memory calls; it replaces the generic
  /// relation extraction for growth-bearing skills).
  Future<void> _reflectSkillGrowth(
    Character character,
    String worldId,
    LlmProvider provider,
    List<Message> messages,
  ) async {
    Map<String, dynamic> core;
    try {
      core = jsonDecode(character.corePersonaJson) as Map<String, dynamic>;
    } catch (_) {
      return;
    }
    final seedRaw = core['affinity'];
    if (seedRaw is! Map || seedRaw.isEmpty) return;
    final seed = Map<String, dynamic>.from(seedRaw);

    // Per-world current state, seeded from the character's original affinity.
    final current = await _currentAffinity(character.id, worldId, seed);

    final recent = messages.length <= growthReflectWindow
        ? messages
        : messages.sublist(messages.length - growthReflectWindow);
    final transcript = recent.map((m) => '${m.role}: ${m.content}').join('\n');

    // NOTE: do not feed the whole `core['system_prompt']` here — skill system
    // prompts can be tens of KB, which blows the memory model's context and
    // makes it return non-JSON. The fixed rule below + the conversation is
    // enough for a best-effort three-axis update.
    final prompt = '当前成长状态 JSON：\n${jsonEncode(current)}\n\n'
        '最近对话：\n$transcript\n\n'
        '根据角色的成长机制更新成长状态 JSON（trust_value / trust_level / '
        'corruption_value / corruption_level / total_h_scenes_completed / '
        'corruption_milestones）。信任值随互动升降，堕落度只升不降。'
        '只输出更新后的 JSON，不要解释、不要代码块。';
    final text = await _complete(
      provider,
      prompt,
      systemPrompt:
          '你是状态记录器。根据当前成长状态和最近对话，输出更新后的成长状态 JSON。只输出 JSON。',
      maxTokens: 256,
      temperature: 0.2,
    );
    final raw = _parseJsonObject(text);
    if (raw == null) return;
    final Map<String, dynamic> updated;
    try {
      updated = jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return;
    }
    await _writeBackAffinity(
      character.id,
      worldId,
      sanitizeAffinity(current, updated),
    );
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

  ({String user, String assistant})? _lastExchange(List<Message> messages) {
    Message? assistant;
    Message? user;
    for (final m in messages.reversed) {
      if (m.role == 'assistant' && assistant == null) assistant = m;
      if (m.role == 'user' && assistant != null) {
        user = m;
        break;
      }
    }
    if (assistant == null || user == null) return null;
    return (user: user.content, assistant: assistant.content);
  }

  String _statePrompt(String state, ({String user, String assistant}) ex) {
    final seed = state == '{}' ? '{"scene":"","facts":[],"items":[],"npcs":{}}' : state;
    return '当前状态 JSON：\n$seed\n\n最新对话：\n用户：${ex.user}\n角色：${ex.assistant}\n\n根据对话更新状态 JSON（保持结构，只改变化的部分），只输出 JSON。';
  }

  String _relationPrompt(String relation, ({String user, String assistant}) ex) {
    final seed = relation == '{}'
        ? '{"affection":0,"trust":0,"intimacy":0,"notes":""}'
        : relation;
    return '当前关系 JSON：\n$seed\n\n最新对话：\n用户：${ex.user}\n角色：${ex.assistant}\n\n根据对话更新关系 JSON（好感/信任/亲密度 0-100，notes 简述），只输出 JSON。';
  }

  Future<String> _extractJson(
    LlmProvider provider,
    String prompt, {
    required String fallback,
  }) async {
    try {
      final text = await _complete(
        provider,
        prompt,
        systemPrompt: '你是结构化信息提取器。只输出 JSON，不要解释、不要代码块。',
      );
      return _parseJsonObject(text) ?? fallback;
    } catch (_) {
      return fallback;
    }
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
