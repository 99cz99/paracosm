import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/db/database.dart';
import '../../../core/network/llm/llm_provider.dart';
import '../../../core/utils/app_exception.dart';
import '../../../core/world/world_context.dart';
import '../../chat/data/memory_service.dart';

/// Builds group-chat prompts and extracts character↔character pair relations.
///
/// The provider is injected so the LLM parts are testable with a fake.
class GroupService {
  GroupService(this._db);

  final AppDatabase _db;

  /// Builds the request for the next group turn.
  Future<ChatRequest> buildRequest(
    String groupId, {
    String? forcedSpeakerId,
  }) async {
    final group = await _db.getGroup(groupId);
    if (group == null) throw AppException('群聊不存在');
    final members = await _db.watchMembersFor(groupId).first;
    final groupMemoryRow = await _db.getGroupMemory(groupId);
    final summaryIndex = groupMemoryRow?.summaryIndex ?? 0;
    final allMessages = await _db.getGroupMessages(groupId);
    final history = allMessages
        .where((m) => m.orderIndex >= summaryIndex && m.visibleToAi)
        .toList();
    final pairs = await _db.getPairRelations(groupId);

    final worldIds = await _db.getGroupWorldIds(groupId);
    if (worldIds.isEmpty && (group.worldId?.isNotEmpty ?? false)) {
      worldIds.add(group.worldId!);
    }
    final worldCtx = await WorldContextBuilder(_db).build(
      worldIds: worldIds,
      worldbookIds: (await _db.getGroupWorldbookIds(groupId)).toSet(),
    );
    final recentContext = history.length <= MemoryService.worldbookScanMessages
        ? history.map((m) => m.content).join('\n')
        : history
            .sublist(history.length - MemoryService.worldbookScanMessages)
            .map((m) => m.content)
            .join('\n');

    // Inject the group's own memory (state + summary), independent of
    // single-chat memory.
    final groupMemory = _groupMemorySection(groupMemoryRow);

    final forcedName = forcedSpeakerId == null
        ? null
        : _nameOf(members, forcedSpeakerId);

    final systemPrompt = _buildSystemPrompt(
      group,
      members,
      worldCtx.buildWorldSection(),
      worldCtx.buildWorldbookSection(recentContext),
      pairs,
      forcedName,
      groupMemory,
    );

    final messages = history.map((m) {
      if (m.role == 'user') return ChatMessage(role: 'user', content: m.content);
      final name = _nameOf(members, m.speakerCharacterId);
      return ChatMessage(role: 'assistant', content: '$name：${m.content}');
    }).toList();

    return ChatRequest(
      messages: messages,
      systemPrompt: systemPrompt,
      temperature: group.temperature ?? 1.2,
      topP: group.topP ?? 1.0,
      maxTokens: group.maxTokens ?? 4096,
      presencePenalty: group.presencePenalty,
      frequencyPenalty: group.frequencyPenalty,
    );
  }

  /// Extracts character↔character relations for every pair in the group.
  Future<void> extractPairRelations(String groupId, LlmProvider provider) async {
    final members = await _db.watchMembersFor(groupId).first;
    if (members.length < 2) return;
    final history = (await _db.getGroupMessages(groupId))
        .where((m) => m.visibleToAi)
        .toList();
    final pairs = _pairs(members);
    final existing = await _db.getPairRelations(groupId);
    final existingMap = <String, String>{
      for (final p in existing) '${p.charA}|${p.charB}': p.relationJson,
    };

    final text = await _complete(
      provider,
      _pairPrompt(members, pairs, existingMap, history),
    );
    final parsed = _parsePairObject(text);
    if (parsed == null) return;

    final now = DateTime.now().millisecondsSinceEpoch;
    for (final pair in pairs) {
      final aName = _nameOf(members, pair.$1);
      final bName = _nameOf(members, pair.$2);
      final raw = parsed['$aName|$bName'] ??
          parsed['$bName|$aName'] ??
          parsed['${pair.$1}|${pair.$2}'];
      if (raw is! Map) continue;

      final charA = pair.$1.compareTo(pair.$2) <= 0 ? pair.$1 : pair.$2;
      final charB = pair.$1.compareTo(pair.$2) <= 0 ? pair.$2 : pair.$1;
      await _db.upsertPairRelation(PairRelationsCompanion.insert(
        id: const Uuid().v4(),
        groupId: groupId,
        charA: charA,
        charB: charB,
        relationJson: Value(jsonEncode(raw)),
        updatedAt: now,
      ));
    }
  }

  // --- prompt ------------------------------------------------------------

  String _buildSystemPrompt(
    Group group,
    List<GroupMemberWithCharacter> members,
    String worldSection,
    String worldbookSection,
    List<PairRelation> pairs,
    String? forcedName,
    String? groupMemory,
  ) {
    final parts = <String>[];
    if (worldSection.isNotEmpty) parts.add(worldSection);
    for (final m in members) {
      parts.add('【${m.character.name}】\n${_persona(m.character)}');
    }
    if (worldbookSection.isNotEmpty) parts.add(worldbookSection);
    if (groupMemory != null && groupMemory.isNotEmpty) {
      parts.add(groupMemory);
    }
    if (pairs.isNotEmpty) {
      final rel = pairs
          .map((p) => '${_nameOf(members, p.charA)}-${_nameOf(members, p.charB)}：${p.relationJson}')
          .join('\n');
      parts.add('【角色间关系】\n$rel');
    }
    if (forcedName != null) {
      parts.add('现在轮到 $forcedName 发言。只输出 $forcedName 说的话（不要名字前缀）。');
    } else {
      parts.add('根据对话，让一个或多个合适的角色依次发言。每个角色单独一行，格式「角色名：内容」，内容里不要换行。不要重复同一个角色。');
    }
    return parts.join('\n\n');
  }

  String _pairPrompt(
    List<GroupMemberWithCharacter> members,
    List<(String, String)> pairs,
    Map<String, String> existing,
    List<GroupMessage> history,
  ) {
    final pairNames =
        pairs.map((p) => '${_nameOf(members, p.$1)}|${_nameOf(members, p.$2)}').join('、');
    final existingJson = existing.isEmpty ? '{}' : jsonEncode(existing);
    final transcript = history
        .map((m) => m.role == 'user'
            ? '用户：${m.content}'
            : '${_nameOf(members, m.speakerCharacterId)}：${m.content}')
        .join('\n');
    return '群成员：$pairNames\n\n当前角色间关系：\n$existingJson\n\n最近对话：\n$transcript\n\n'
        '请更新每对角色间的关系（relation 描述、affinity 0-100、notes 简述），只输出 JSON：\n'
        '{"名字A|名字B":{"relation":"...","affinity":0,"notes":""}, ...}';
  }

  // --- helpers -----------------------------------------------------------

  String _persona(Character c) {
    try {
      final core = jsonDecode(c.corePersonaJson) as Map<String, dynamic>;
      final parts = <String>[
        (core['description'] ?? '').toString(),
        (core['personality'] ?? '').toString(),
      ].where((s) => s.isNotEmpty).toList();
      return parts.join('\n');
    } catch (_) {
      return '';
    }
  }

  /// The group's own memory block (state + summary), or null when empty.
  String? _groupMemorySection(GroupMemory? memory) {
    if (memory == null) return null;
    final parts = <String>[];
    if (memory.summaryText.isNotEmpty) parts.add('历史摘要：${memory.summaryText}');
    if (memory.stateJson.isNotEmpty && memory.stateJson != '{}') {
      parts.add('当前状态：${memory.stateJson}');
    }
    if (parts.isEmpty) return null;
    return '【群聊记忆】\n${parts.join('\n')}';
  }

  String _nameOf(List<GroupMemberWithCharacter> members, String? characterId) {
    if (characterId == null) return '角色';
    for (final m in members) {
      if (m.member.characterId == characterId) return m.character.name;
    }
    return '角色';
  }

  List<(String, String)> _pairs(List<GroupMemberWithCharacter> members) {
    final ids = members.map((m) => m.member.characterId).toList();
    final pairs = <(String, String)>[];
    for (var i = 0; i < ids.length; i++) {
      for (var j = i + 1; j < ids.length; j++) {
        pairs.add((ids[i], ids[j]));
      }
    }
    return pairs;
  }

  Future<String> _complete(LlmProvider provider, String prompt) async {
    final buffer = StringBuffer();
    await for (final chunk in provider.streamChat(ChatRequest(
      messages: [ChatMessage(role: 'user', content: prompt)],
      systemPrompt: '你是结构化信息提取器。只输出 JSON，不要解释、不要代码块。',
      maxTokens: 1024,
      temperature: 0.2,
    ))) {
      if (chunk.textDelta != null) buffer.write(chunk.textDelta);
    }
    return buffer.toString();
  }

  Map<String, dynamic>? _parsePairObject(String text) {
    final start = text.indexOf('{');
    final end = text.lastIndexOf('}');
    if (start < 0 || end <= start) return null;
    try {
      final decoded = jsonDecode(text.substring(start, end + 1));
      return decoded is Map<String, dynamic> ? decoded : null;
    } catch (_) {
      return null;
    }
  }
}
