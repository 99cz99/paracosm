import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paracosm/core/db/database.dart';
import 'package:paracosm/core/network/llm/llm_provider.dart';
import 'package:paracosm/features/chat/data/memory_service.dart';

/// A provider that always streams back a fixed string (the reflection's JSON).
class _FixedJsonProvider implements LlmProvider {
  _FixedJsonProvider(this.json);

  final String json;

  @override
  String get id => 'mock';

  @override
  ProviderType get type => ProviderType.openaiCompatible;

  @override
  Stream<ChatChunk> streamChat(ChatRequest request) async* {
    yield ChatChunk(textDelta: json);
    yield ChatChunk(finishReason: 'stop');
  }

  @override
  Future<void> cancel() async {}
}

Future<AppDatabase> _dbWithCharacter({required String core}) async {
  final db = AppDatabase.forTesting(NativeDatabase.memory());
  await db.insertCharacter(CharactersCompanion.insert(
    id: 'c1',
    name: 'nene',
    corePersonaJson: core,
    sourceType: 'skill',
    createdAt: 1,
    updatedAt: 1,
  ));
  await db.insertSession(SessionsCompanion.insert(
    id: 's1',
    characterId: 'c1',
    createdAt: 1,
    updatedAt: 1,
    lastMessageAt: 1,
  ));
  await db.insertMessage(MessagesCompanion.insert(
    id: 'm1',
    sessionId: 's1',
    role: 'user',
    content: '你好',
    orderIndex: 0,
    timestamp: 1,
  ));
  await db.insertMessage(MessagesCompanion.insert(
    id: 'm2',
    sessionId: 's1',
    role: 'assistant',
    content: '你好呀',
    orderIndex: 1,
    timestamp: 2,
  ));
  return db;
}

void main() {
  group('hasSkillGrowth', () {
    test('true when core carries a non-empty affinity', () {
      final c = Character(
        id: 'c1',
        name: 'nene',
        corePersonaJson: jsonEncode({
          'description': 'd',
          'affinity': {'trust_value': 3},
        }),
        worldbookJson: null,
        avatarPath: null,
        tags: '[]',
        sourceType: 'skill',
        sourcePath: null,
        createdAt: 1,
        updatedAt: 1,
      );
      expect(MemoryService.hasSkillGrowth(c), isTrue);
    });

    test('false without affinity or with empty affinity', () {
      final noAffinity = Character(
        id: 'c1',
        name: 'nene',
        corePersonaJson: jsonEncode({'description': 'd'}),
        worldbookJson: null,
        avatarPath: null,
        tags: '[]',
        sourceType: 'skill',
        sourcePath: null,
        createdAt: 1,
        updatedAt: 1,
      );
      final emptyAffinity = Character(
        id: 'c1',
        name: 'nene',
        corePersonaJson: jsonEncode({'description': 'd', 'affinity': <String, dynamic>{}}),
        worldbookJson: null,
        avatarPath: null,
        tags: '[]',
        sourceType: 'skill',
        sourcePath: null,
        createdAt: 1,
        updatedAt: 1,
      );
      expect(MemoryService.hasSkillGrowth(noAffinity), isFalse);
      expect(MemoryService.hasSkillGrowth(emptyAffinity), isFalse);
    });
  });

  group('sanitizeAffinity', () {
    test('clamps numbers to valid ranges and keeps unknown keys out', () {
      final existing = <String, dynamic>{
        'trust_level': 1,
        'trust_value': 3,
        'corruption_value': 0,
        'corruption_level': 0,
        'total_h_scenes_completed': 0,
        'corruption_milestones': {'lv1_reached': false},
        'notes': '初始状态',
      };
      final updated = <String, dynamic>{
        'trust_level': 9, // out of range → clamped to 5
        'trust_value': 42,
        'corruption_value': '7', // string → parsed
        'corruption_level': 2,
        'total_h_scenes_completed': 3,
        'corruption_milestones': {'lv1_reached': true},
        'extra_junk': 'should not appear',
      };
      final out = MemoryService.sanitizeAffinity(existing, updated);
      expect(out['trust_level'], 5);
      expect(out['trust_value'], 42);
      expect(out['corruption_value'], 7);
      expect(out['corruption_level'], 2);
      expect(out['total_h_scenes_completed'], 3);
      expect((out['corruption_milestones'] as Map)['lv1_reached'], isTrue);
      expect(out.containsKey('extra_junk'), isFalse);
      expect(out['notes'], '初始状态'); // preserved from existing
      expect(out['last_session'], isNotEmpty);
    });
  });

  group('updateAfterTurn routing', () {
    test('growth skill: reflects affinity, skips generic relation', () async {
      final db = await _dbWithCharacter(
        core: jsonEncode({
          'description': 'd',
          'system_prompt': '成长规则：信任值随互动上升，堕落度只升不降',
          'affinity': {
            'trust_value': 3,
            'trust_level': 1,
            'corruption_value': 0,
            'corruption_level': 0,
          },
        }),
      );
      final provider = _FixedJsonProvider(jsonEncode({
        'trust_value': 50,
        'trust_level': 2,
        'corruption_value': 5,
        'corruption_level': 1,
        'total_h_scenes_completed': 1,
      }));

      await MemoryService(db).updateAfterTurn('s1', provider);

      // Growth is now stored per-world (world_id ''), not written back into core.
      final aff = await db.getCharacterAffinity('c1', '');
      expect(aff, isNotNull);
      final affinity = jsonDecode(aff!.affinityJson) as Map<String, dynamic>;
      expect(affinity['trust_value'], 50);
      expect(affinity['corruption_value'], 5);
      // Generic relation must NOT have been created for a growth skill.
      expect(await db.getCharacterRelation('c1', ''), isNull);

      await db.close();
    });

    test('plain character: extracts generic relation as before', () async {
      final db = await _dbWithCharacter(
        core: jsonEncode({'description': 'd'}),
      );
      final provider = _FixedJsonProvider(jsonEncode({
        'affection': 50,
        'trust': 40,
        'intimacy': 30,
        'notes': 'ok',
      }));

      await MemoryService(db).updateAfterTurn('s1', provider);

      final rel = await db.getCharacterRelation('c1', '');
      expect(rel, isNotNull);
      final relationJson = jsonDecode(rel!.relationJson) as Map<String, dynamic>;
      expect(relationJson['trust'], 40);

      await db.close();
    });
  });
}
