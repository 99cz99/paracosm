import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../core/db/database.dart';
import '../../../core/network/llm/llm_provider.dart';
import '../../chat/data/memory_service.dart';

/// Group-scoped memory: per-group structured state + rolling summary, fully
/// isolated from single-chat memory (`CharacterMemories` / `CharacterRelations`
/// / `CharacterAffinities`). A group is a shared scene, so state and summary
/// are one row per group; per-character differences live in pair relations.
class GroupMemoryService {
  GroupMemoryService(this._db);

  final AppDatabase _db;

  /// Runs after a group turn. Best-effort — never throws to the caller.
  Future<void> updateAfterTurn(String groupId, LlmProvider provider) async {
    final group = await _db.getGroup(groupId);
    if (group == null) return;

    final messages = (await _db.getGroupMessages(groupId))
        .where((m) => m.visibleToAi)
        .toList();
    if (messages.isEmpty) return;

    final members = await _db.watchMembersFor(groupId).first;
    final nameOf = <String, String>{
      for (final m in members) m.member.characterId: m.character.name,
    };

    await _maybeSummarize(groupId, provider, messages, nameOf);
    await _extractState(groupId, provider, messages, nameOf);

    await provider.cancel();
  }

  // --- internal ----------------------------------------------------------

  Future<void> _maybeSummarize(
    String groupId,
    LlmProvider provider,
    List<GroupMessage> messages,
    Map<String, String> nameOf,
  ) async {
    final memory = await _db.getGroupMemory(groupId);
    final summaryIndex = memory?.summaryIndex ?? 0;
    final unsummarized = messages.where((m) => m.orderIndex >= summaryIndex).length;
    if (unsummarized <= MemoryService.summaryWindow) return;

    final cutoff = messages.length - MemoryService.keepRecent;
    if (cutoff <= summaryIndex) return;
    final toSummarize = messages
        .where((m) => m.orderIndex >= summaryIndex && m.orderIndex < cutoff)
        .toList();
    if (toSummarize.isEmpty) return;

    final existing = memory?.summaryText ?? '';
    final transcript =
        toSummarize.map((m) => '${_label(m, nameOf)}：${m.content}').join('\n');
    final summary = await _summarize(provider, existing, transcript);

    await _db.upsertGroupMemory(GroupMemoriesCompanion.insert(
      groupId: groupId,
      summaryText: Value(summary),
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
    String groupId,
    LlmProvider provider,
    List<GroupMessage> messages,
    Map<String, String> nameOf,
  ) async {
    final exchange = _lastExchange(messages, nameOf);
    if (exchange == null) return;
    final memory = await _db.getGroupMemory(groupId);
    final currentState = memory?.stateJson ?? '{}';
    final newState = await _extractJson(
      provider,
      _statePrompt(currentState, exchange.before, exchange.last),
      fallback: currentState,
    );
    await _db.upsertGroupMemory(GroupMemoriesCompanion.insert(
      groupId: groupId,
      stateJson: Value(newState),
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    ));
  }

  String _statePrompt(String state, String before, String last) {
    final seed =
        state == '{}' ? '{"scene":"","facts":[],"items":[],"npcs":{}}' : state;
    return '当前状态 JSON：\n$seed\n\n最新对话：\n$before\n$last\n\n根据对话更新状态 JSON（保持结构，只改变化的部分），只输出 JSON。';
  }

  /// Last assistant turn + the message right before it, both speaker-labeled.
  ({String before, String last})? _lastExchange(
    List<GroupMessage> messages,
    Map<String, String> nameOf,
  ) {
    GroupMessage? last;
    GroupMessage? before;
    for (final m in messages.reversed) {
      if (m.role == 'assistant' && last == null) {
        last = m;
        continue;
      }
      if (last != null) {
        before = m;
        break;
      }
    }
    if (last == null || before == null) return null;
    return (
      before: '${_label(before, nameOf)}：${before.content}',
      last: '${_label(last, nameOf)}：${last.content}',
    );
  }

  String _label(GroupMessage m, Map<String, String> nameOf) =>
      m.role == 'user' ? '用户' : (nameOf[m.speakerCharacterId] ?? '角色');

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
