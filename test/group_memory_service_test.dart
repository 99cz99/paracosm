import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paracosm/core/db/database.dart';
import 'package:paracosm/core/network/llm/llm_provider.dart';
import 'package:paracosm/features/chat/data/memory_service.dart';
import 'package:paracosm/features/group_chat/data/group_memory_service.dart';

/// A provider that always streams back a fixed string.
class _FixedProvider implements LlmProvider {
  _FixedProvider(this.text);

  final String text;

  @override
  String get id => 'mock';

  @override
  ProviderType get type => ProviderType.openaiCompatible;

  @override
  Stream<ChatChunk> streamChat(ChatRequest request) async* {
    yield ChatChunk(textDelta: text);
    yield ChatChunk(finishReason: 'stop');
  }

  @override
  Future<void> cancel() async {}
}

Future<AppDatabase> _dbWithGroup({required int messageCount}) async {
  final db = AppDatabase.forTesting(NativeDatabase.memory());
  await db.insertCharacter(CharactersCompanion.insert(
    id: 'c1',
    name: 'nene',
    corePersonaJson: '{}',
    sourceType: 'manual',
    createdAt: 1,
    updatedAt: 1,
  ));
  await db.insertGroup(GroupsCompanion.insert(
    id: 'g1',
    name: '群',
    createdAt: 1,
    updatedAt: 1,
    lastMessageAt: 1,
  ));
  await db.insertMember(GroupMembersCompanion.insert(
    id: 'm1',
    groupId: 'g1',
    characterId: 'c1',
    joinOrder: 0,
  ));
  for (var i = 0; i < messageCount; i++) {
    final isUser = i % 2 == 0;
    await db.insertGroupMessage(GroupMessagesCompanion.insert(
      id: 'gm$i',
      groupId: 'g1',
      role: isUser ? 'user' : 'assistant',
      content: isUser ? '用户说 $i' : 'nene 说 $i',
      orderIndex: i,
      timestamp: i,
    ));
  }
  return db;
}

void main() {
  group('GroupMemoryService.updateAfterTurn', () {
    test('extracts state into group memory (below summary window)', () async {
      final db = await _dbWithGroup(messageCount: 2);
      final provider =
          _FixedProvider(jsonEncode({'scene': '森林', 'facts': ['遇到狼']}));

      await GroupMemoryService(db).updateAfterTurn('g1', provider);

      final mem = await db.getGroupMemory('g1');
      expect(mem, isNotNull);
      final state = jsonDecode(mem!.stateJson) as Map<String, dynamic>;
      expect(state['scene'], '森林');
      // Only 2 messages — below the summary window, so no summary yet.
      expect(mem.summaryText, isEmpty);
      await db.close();
    });

    test('rolls summary once unsummarized messages exceed the window', () async {
      final db = await _dbWithGroup(messageCount: 24);
      final provider = _FixedProvider('这是一段摘要');

      await GroupMemoryService(db).updateAfterTurn('g1', provider);

      final mem = await db.getGroupMemory('g1');
      expect(mem, isNotNull);
      expect(mem!.summaryText, '这是一段摘要');
      expect(mem.summaryIndex, 24 - MemoryService.keepRecent);
      await db.close();
    });
  });
}
