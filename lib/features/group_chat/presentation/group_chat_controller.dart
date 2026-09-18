import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/commands/slash_commands.dart';
import '../../../core/db/database.dart';
import '../../../core/network/llm/llm_provider.dart';
import '../../../core/network/llm/provider_factory.dart';
import '../../../core/providers/db_providers.dart';
import '../../../core/providers/llm_providers.dart';
import '../../../core/utils/app_exception.dart';
import '../../chat/data/memory_service.dart';
import '../data/group_memory_service.dart';
import '../data/group_service.dart';
import '../data/group_speaker.dart';

class GroupChatUiState {
  const GroupChatUiState({
    this.streamingText,
    this.streamingSpeakerId,
    this.streamingGroupId,
    this.isGenerating = false,
  });

  final String? streamingText;
  final String? streamingSpeakerId;
  final String? streamingGroupId;
  final bool isGenerating;
}

final groupChatControllerProvider =
    NotifierProvider<GroupChatController, GroupChatUiState>(
        GroupChatController.new);

/// Orchestrates a group-chat turn: persist the user message, pick a speaker
/// per the mode, stream the reply, attribute it to a character, then trigger
/// pair-relation extraction.
class GroupChatController extends Notifier<GroupChatUiState> {
  static final _uuid = const Uuid();
  var _cancelling = false;
  LlmProvider? _currentProvider;

  @override
  GroupChatUiState build() {
    ref.onDispose(() => _currentProvider?.cancel());
    return const GroupChatUiState();
  }

  Future<void> sendMessage(String groupId, String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || state.isGenerating) return;

    // Slash commands run locally and never touch the LLM.
    if (trimmed.startsWith('/')) {
      await _runGroupCommand(groupId, trimmed);
      return;
    }

    _cancelling = false;
    final db = ref.read(dbProvider);

    // 1. Persist the user message.
    final now = DateTime.now().millisecondsSinceEpoch;
    final userIdx = await db.nextGroupOrderIndex(groupId);
    await db.insertGroupMessage(GroupMessagesCompanion.insert(
      id: _uuid.v4(),
      groupId: groupId,
      role: 'user',
      content: trimmed,
      orderIndex: userIdx,
      timestamp: now,
    ));
    await db.touchGroup(groupId, now);

    // 2. Load the group (to pick its per-group provider).
    final group = await db.getGroup(groupId);
    final members = await db.watchMembersFor(groupId).first;
    if (group == null) throw AppException('群聊不存在');

    // 3. Resolve provider (per-group override, else default).
    final config = await resolveProvider(db, ref.read(secureKeyStoreProvider),
        providerId: group.providerId);
    if (config == null) {
      throw AppException('请先在「我」中配置 API Provider');
    }

    // 3. Pick a speaker per the mode.
    final memberInfos = members
        .map((m) => (
              id: m.member.characterId,
              name: m.character.name,
              joinOrder: m.member.joinOrder,
            ))
        .toList();
    final history = await db.getGroupMessages(groupId);
    final assistantCount = history.where((m) => m.role == 'assistant').length;
    final forcedSpeakerId = GroupSpeaker.determine(
      mode: group.speakMode,
      members: memberInfos,
      assistantCount: assistantCount,
      userText: trimmed,
    );

    // 4. Stream.
    final request = await GroupService(db)
        .buildRequest(groupId, forcedSpeakerId: forcedSpeakerId);
    final provider = buildLlmProvider(config);
    _currentProvider = provider;
    state = GroupChatUiState(
      isGenerating: true,
      streamingText: '',
      streamingSpeakerId: forcedSpeakerId,
      streamingGroupId: groupId,
    );

    final buffer = StringBuffer();
    String? finishReason;
    try {
      await for (final chunk in provider.streamChat(request)) {
        if (chunk.finishReason != null) finishReason = chunk.finishReason;
        final delta = chunk.textDelta;
        if (delta != null && delta.isNotEmpty) {
          buffer.write(delta);
          final stripped = _stripStreamingPrefix(buffer.toString(), members);
          state = GroupChatUiState(
            isGenerating: true,
            streamingText: stripped.text,
            streamingSpeakerId: stripped.speakerId ?? forcedSpeakerId,
            streamingGroupId: groupId,
          );
        }
      }
    } catch (e) {
      state = const GroupChatUiState();
      if (_cancelling) return;
      final reply = buffer.toString().trim();
      if (reply.isNotEmpty) {
        final replies = _parseReplies(reply, forcedSpeakerId, members);
        try {
          if (await db.getGroup(groupId) != null) {
            for (final r in replies) {
              await _persistAssistant(db, groupId, r.speakerId, r.content);
            }
          }
        } catch (_) {}
        return;
      }
      rethrow;
    }

    if (_cancelling) return;

    final reply = buffer.toString().trim();
    if (reply.isEmpty) {
      state = const GroupChatUiState();
      throw AppException(
        finishReason == 'length' || finishReason == 'max_tokens'
            ? '回复未生成：已达最大 token 数限制。请调高最大 token（思考型模型建议 8192+）。'
            : '未收到模型回复，请重试。',
      );
    }

    // 5. Attribute and persist. Persist before clearing the streaming state so
    // the replies land in the list before the streaming bubble is dropped —
    // avoids a one-frame flicker.
    final replies = _parseReplies(reply, forcedSpeakerId, members);
    try {
      if (await db.getGroup(groupId) != null) {
        for (final r in replies) {
          await _persistAssistant(db, groupId, r.speakerId, r.content);
        }
        unawaited(_runPairExtraction(db, groupId));
        unawaited(_runGroupMemoryUpdate(db, groupId));
      }
    } catch (_) {
      // Group deleted mid-stream — nothing to persist.
    } finally {
      state = const GroupChatUiState();
    }
  }

  List<({String? speakerId, String content})> _parseReplies(
    String reply,
    String? forcedSpeakerId,
    List<GroupMemberWithCharacter> members,
  ) {
    if (forcedSpeakerId != null) {
      return [(speakerId: forcedSpeakerId, content: reply)];
    }

    final sorted = members
        .where((m) => m.character.name.isNotEmpty)
        .toList()
      ..sort((a, b) =>
          b.character.name.length.compareTo(a.character.name.length));

    final results = <({String? speakerId, String content})>[];
    String? currentSpeakerId;
    final buffer = StringBuffer();

    void flush() {
      final content = buffer.toString().trim();
      if (currentSpeakerId != null && content.isNotEmpty) {
        results.add((speakerId: currentSpeakerId, content: content));
      }
      buffer.clear();
    }

    var i = 0;
    while (i < reply.length) {
      String? matchedId;
      var advance = 0;
      for (final m in sorted) {
        final name = m.character.name;
        if (reply.startsWith(name, i) &&
            i + name.length < reply.length &&
            (reply[i + name.length] == '：' || reply[i + name.length] == ':')) {
          matchedId = m.member.characterId;
          advance = name.length + 1; // name + colon
          break;
        }
      }
      if (matchedId != null) {
        flush();
        currentSpeakerId = matchedId;
        i += advance;
        continue;
      }
      buffer.write(reply[i]);
      i++;
    }
    flush();

    // Fallback: nothing matched — attribute the whole reply to the first member.
    if (results.isEmpty) {
      return [
        (
          speakerId: members.isNotEmpty ? members.first.member.characterId : null,
          content: reply.trim(),
        )
      ];
    }
    return results;
  }

  /// Strips a leading `名字：` / `名字:` prefix from the streaming text so the
  /// speaker's name doesn't leak into the in-progress bubble, and returns the
  /// matched speaker. Longest name first so `张三` doesn't wrongly match
  /// `张三丰：`.
  ({String text, String? speakerId}) _stripStreamingPrefix(
    String text,
    List<GroupMemberWithCharacter> members,
  ) {
    final sorted = members
        .where((m) => m.character.name.isNotEmpty)
        .toList()
      ..sort(
          (a, b) => b.character.name.length.compareTo(a.character.name.length));
    for (final m in sorted) {
      final name = m.character.name;
      if (text.startsWith('$name：')) {
        return (
          text: text.substring(name.length + 1),
          speakerId: m.member.characterId,
        );
      }
      if (text.startsWith('$name:')) {
        return (
          text: text.substring(name.length + 1),
          speakerId: m.member.characterId,
        );
      }
    }
    return (text: text, speakerId: null);
  }

  Future<void> _persistAssistant(
    AppDatabase db,
    String groupId,
    String? speakerId,
    String content,
  ) async {
    if (content.isEmpty) return;
    final ts = DateTime.now().millisecondsSinceEpoch;
    final idx = await db.nextGroupOrderIndex(groupId);
    await db.insertGroupMessage(GroupMessagesCompanion.insert(
      id: _uuid.v4(),
      groupId: groupId,
      speakerCharacterId: Value(speakerId),
      role: 'assistant',
      content: content,
      orderIndex: idx,
      timestamp: ts,
    ));
    await db.touchGroup(groupId, ts);
  }

  Future<void> _runPairExtraction(AppDatabase db, String groupId) async {
    final config =
        await resolveActiveProvider(db, ref.read(secureKeyStoreProvider));
    if (config == null) return;
    try {
      await GroupService(db)
          .extractPairRelations(groupId, buildLlmProvider(config));
    } catch (_) {
      // Pair extraction is best-effort.
    }
  }

  Future<void> _runGroupMemoryUpdate(AppDatabase db, String groupId) async {
    final config =
        await resolveActiveProvider(db, ref.read(secureKeyStoreProvider));
    if (config == null) return;
    try {
      await GroupMemoryService(db)
          .updateAfterTurn(groupId, MemoryService.buildProvider(config));
    } catch (_) {
      // Group memory update is best-effort.
    }
  }

  void cancel() {
    _cancelling = true;
    _currentProvider?.cancel();
    state = const GroupChatUiState();
  }

  /// Executes a slash command locally in the group: persists the user command +
  /// the app's reply as non-AI-visible messages, without calling the LLM.
  Future<void> _runGroupCommand(String groupId, String text) async {
    final db = ref.read(dbProvider);
    final now = DateTime.now().millisecondsSinceEpoch;

    final userIdx = await db.nextGroupOrderIndex(groupId);
    await db.insertGroupMessage(GroupMessagesCompanion.insert(
      id: _uuid.v4(),
      groupId: groupId,
      role: 'user',
      content: text,
      orderIndex: userIdx,
      timestamp: now,
      type: const Value('command'),
      visibleToAi: const Value(false),
    ));
    await db.touchGroup(groupId, now);

    String reply;
    try {
      final group = await db.getGroup(groupId);
      reply = group == null
          ? '群聊不存在'
          : await executeGroupCommand(db, group, text);
    } catch (e) {
      reply = '指令执行失败：$e';
    }

    final replyIdx = await db.nextGroupOrderIndex(groupId);
    await db.insertGroupMessage(GroupMessagesCompanion.insert(
      id: _uuid.v4(),
      groupId: groupId,
      role: 'system',
      content: reply,
      orderIndex: replyIdx,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      type: const Value('command_reply'),
      visibleToAi: const Value(false),
    ));
    await db.touchGroup(groupId, DateTime.now().millisecondsSinceEpoch);
  }
}
