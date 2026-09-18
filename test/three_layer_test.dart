import 'package:drift/drift.dart' hide Column;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paracosm/core/db/database.dart';

void main() {
  test('one character binds multiple worlds with independent adaptations',
      () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());

    await db.insertCharacter(CharactersCompanion.insert(
      id: 'c1',
      name: '宁宁',
      corePersonaJson: '{"personality":"温柔"}',
      sourceType: 'manual',
      createdAt: 1,
      updatedAt: 1,
    ));
    await db.insertWorld(WorldsCompanion.insert(
      id: 'w1',
      name: '校园',
      createdAt: 1,
      updatedAt: 1,
    ));
    await db.insertWorld(WorldsCompanion.insert(
      id: 'w2',
      name: '奇幻',
      createdAt: 1,
      updatedAt: 1,
    ));

    // Default adaptation + two world-specific adaptations.
    await db.upsertAdaptation(CharacterAdaptationsCompanion.insert(
      id: 'a0',
      characterId: 'c1',
      worldId: const Value(''),
      adaptationJson: '{"persona":"默认"}',
      createdAt: 1,
      updatedAt: 1,
    ));
    await db.upsertAdaptation(CharacterAdaptationsCompanion.insert(
      id: 'a1',
      characterId: 'c1',
      worldId: const Value('w1'),
      adaptationJson: '{"persona":"校园版"}',
      createdAt: 1,
      updatedAt: 1,
    ));
    await db.upsertAdaptation(CharacterAdaptationsCompanion.insert(
      id: 'a2',
      characterId: 'c1',
      worldId: const Value('w2'),
      adaptationJson: '{"persona":"奇幻版"}',
      createdAt: 1,
      updatedAt: 1,
    ));

    // Three adaptations listed (default + 2 worlds).
    final adaptations = await db.watchAdaptationsFor('c1').first;
    expect(adaptations.length, 3);

    // Each world's adaptation is independent.
    final w1 = await db.getAdaptation('c1', 'w1');
    final w2 = await db.getAdaptation('c1', 'w2');
    expect(w1!.adaptationJson, contains('校园版'));
    expect(w2!.adaptationJson, contains('奇幻版'));
    expect(w1.adaptationJson, isNot(w2.adaptationJson));

    await db.close();
  });
}
