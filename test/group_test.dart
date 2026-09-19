import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paracosm/core/db/database.dart';
import 'package:paracosm/core/network/llm/llm_provider.dart';
import 'package:paracosm/features/group_chat/data/group_repository.dart';
import 'package:paracosm/features/group_chat/data/group_service.dart';
import 'package:paracosm/features/group_chat/data/group_speaker.dart';

const _members = [
  (id: 'c1', name: '小明', joinOrder: 0),
  (id: 'c2', name: '小红', joinOrder: 1),
  (id: 'c3', name: '小刚', joinOrder: 2),
];

void main() {
  group('GroupSpeaker', () {
    test('turn mode round-robins by join order', () {
      expect(GroupSpeaker.determine(mode: 'turn', members: _members), 'c1');
      expect(GroupSpeaker.determine(mode: 'turn', members: _members, lastSpeakerId: 'c1'), 'c2');
      expect(GroupSpeaker.determine(mode: 'turn', members: _members, lastSpeakerId: 'c3'), 'c1');
    });

    test('call mode matches @name', () {
      expect(
        GroupSpeaker.determine(
          mode: 'call',
          members: _members,
          userText: '@小红 你怎么看',
        ),
        'c2',
      );
    });

    test('call mode without mention returns null (falls back to auto)', () {
      expect(
        GroupSpeaker.determine(mode: 'call', members: _members, userText: '大家好'),
        isNull,
      );
    });

    test('auto mode returns null', () {
      expect(GroupSpeaker.determine(mode: 'auto', members: _members), isNull);
    });
  });

  test('create group binds multiple characters', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    for (final m in _members) {
      await db.insertCharacter(CharactersCompanion.insert(
        id: m.id,
        name: m.name,
        corePersonaJson: '{}',
        sourceType: 'manual',
        createdAt: 1,
        updatedAt: 1,
      ));
    }

    final groupId = await GroupRepository(db).createGroup(
      name: '测试群',
      characterIds: ['c1', 'c2', 'c3'],
      speakMode: 'turn',
    );

    final group = await db.getGroup(groupId);
    expect(group!.name, '测试群');
    expect(group.speakMode, 'turn');

    final members = await db.watchMembersFor(groupId).first;
    expect(members.length, 3);
    expect(members.map((m) => m.character.name), containsAll(['小明', '小红', '小刚']));

    await db.close();
  });

  test('extractPairRelations updates character pair relations', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    for (final m in _members) {
      await db.insertCharacter(CharactersCompanion.insert(
        id: m.id,
        name: m.name,
        corePersonaJson: '{}',
        sourceType: 'manual',
        createdAt: 1,
        updatedAt: 1,
      ));
    }
    final groupId = await GroupRepository(db).createGroup(
      name: '测试群',
      characterIds: ['c1', 'c2', 'c3'],
    );
    await db.insertGroupMessage(GroupMessagesCompanion.insert(
      id: 'g1',
      groupId: groupId,
      role: 'user',
      content: '大家好',
      orderIndex: 0,
      timestamp: 1,
    ));

    await GroupService(db).extractPairRelations(groupId, _FakePairProvider());

    final pairs = await db.getPairRelations(groupId);
    expect(pairs.length, 3);
    expect(pairs.every((p) => p.relationJson.contains('affinity')), isTrue);

    await db.close();
  });
}

class _FakePairProvider implements LlmProvider {
  @override
  String get id => 'fake-pair';

  @override
  ProviderType get type => ProviderType.openaiCompatible;

  @override
  Stream<ChatChunk> streamChat(ChatRequest request) async* {
    yield ChatChunk(textDelta: '{"小明|小红":{"relation":"朋友","affinity":60,"notes":""},'
        '"小明|小刚":{"relation":"同学","affinity":30,"notes":""},'
        '"小红|小刚":{"relation":"朋友","affinity":50,"notes":""}}');
    yield ChatChunk(finishReason: 'stop');
  }

  @override
  Future<void> cancel() async {}
}
