import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paracosm/core/db/database.dart';

Future<AppDatabase> _dbWithMemory() async {
  final db = AppDatabase.forTesting(NativeDatabase.memory());
  await db.insertCharacter(CharactersCompanion.insert(
    id: 'c1',
    name: 'nene',
    corePersonaJson: '{}',
    sourceType: 'manual',
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
  await db.upsertCharacterMemory(CharacterMemoriesCompanion.insert(
    characterId: 'c1',
    worldId: const Value(''),
    stateJson: const Value('{"scene":"森林"}'),
    summaryText: const Value('一段摘要'),
    updatedAt: 1,
  ));
  await db.upsertCharacterRelation(CharacterRelationsCompanion.insert(
    characterId: 'c1',
    worldId: const Value(''),
    relationJson: const Value('{"trust":40}'),
    updatedAt: 1,
  ));
  await db.upsertCharacterAffinity(CharacterAffinitiesCompanion.insert(
    characterId: 'c1',
    worldId: const Value(''),
    affinityJson: const Value('{"trust_value":5}'),
    updatedAt: 1,
  ));
  return db;
}

void main() {
  test('deleteSession clears the session and its world-scoped memory', () async {
    final db = await _dbWithMemory();
    expect(await db.getSession('s1'), isNotNull);
    expect(await db.getCharacterMemory('c1', ''), isNotNull);
    expect(await db.getCharacterRelation('c1', ''), isNotNull);
    expect(await db.getCharacterAffinity('c1', ''), isNotNull);

    await db.deleteSession('s1');

    expect(await db.getSession('s1'), isNull);
    expect(await db.getCharacterMemory('c1', ''), isNull);
    expect(await db.getCharacterRelation('c1', ''), isNull);
    expect(await db.getCharacterAffinity('c1', ''), isNull);
    await db.close();
  });
}
