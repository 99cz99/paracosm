import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paracosm/core/db/database.dart';
import 'package:paracosm/features/group_chat/data/group_repository.dart';

Future<AppDatabase> _db() async {
  final db = AppDatabase.forTesting(NativeDatabase.memory());
  for (final id in ['c1', 'c2', 'c3']) {
    await db.insertCharacter(CharactersCompanion.insert(
      id: id,
      name: id,
      corePersonaJson: '{}',
      sourceType: 'manual',
      createdAt: 1,
      updatedAt: 1,
    ));
  }
  for (final id in ['w1', 'w2']) {
    await db.insertWorld(WorldsCompanion.insert(
      id: id,
      name: id,
      createdAt: 1,
      updatedAt: 1,
    ));
  }
  for (final id in ['b1', 'b2']) {
    await db.insertWorldbook(WorldbooksCompanion.insert(
      id: id,
      name: id,
      createdAt: 1,
      updatedAt: 1,
    ));
  }
  return db;
}

void main() {
  test('reuses an existing group with identical members/worlds/worldbooks',
      () async {
    final db = await _db();
    final repo = GroupRepository(db);

    final id1 = await repo.createGroup(
      name: '群A',
      characterIds: ['c1', 'c2'],
      worldIds: ['w1'],
      worldbookIds: ['b1'],
    );
    final id2 = await repo.createGroup(
      name: '群B',
      characterIds: ['c1', 'c2'],
      worldIds: ['w1'],
      worldbookIds: ['b1'],
    );

    expect(id2, id1);
    final groups = await db.watchGroups().first;
    expect(groups.length, 1);
    await db.close();
  });

  test('member order does not matter for dedup', () async {
    final db = await _db();
    final repo = GroupRepository(db);

    final id1 = await repo.createGroup(
      name: 'g',
      characterIds: ['c1', 'c2'],
      worldIds: ['w1'],
      worldbookIds: ['b1'],
    );
    final id2 = await repo.createGroup(
      name: 'g',
      characterIds: ['c2', 'c1'],
      worldIds: ['w1'],
      worldbookIds: ['b1'],
    );

    expect(id2, id1);
    await db.close();
  });

  test('creates a new group when members differ', () async {
    final db = await _db();
    final repo = GroupRepository(db);

    final id1 = await repo.createGroup(
      name: 'g',
      characterIds: ['c1', 'c2'],
      worldIds: ['w1'],
      worldbookIds: ['b1'],
    );
    final id2 = await repo.createGroup(
      name: 'g',
      characterIds: ['c1', 'c3'],
      worldIds: ['w1'],
      worldbookIds: ['b1'],
    );

    expect(id2, isNot(id1));
    await db.close();
  });

  test('creates a new group when worlds or worldbooks differ', () async {
    final db = await _db();
    final repo = GroupRepository(db);

    final id1 = await repo.createGroup(
      name: 'g',
      characterIds: ['c1', 'c2'],
      worldIds: ['w1'],
      worldbookIds: ['b1'],
    );
    final id2 = await repo.createGroup(
      name: 'g',
      characterIds: ['c1', 'c2'],
      worldIds: ['w2'],
      worldbookIds: ['b1'],
    );
    final id3 = await repo.createGroup(
      name: 'g',
      characterIds: ['c1', 'c2'],
      worldIds: ['w1'],
      worldbookIds: ['b2'],
    );

    expect(id2, isNot(id1));
    expect(id3, isNot(id1));
    expect(id3, isNot(id2));
    await db.close();
  });
}
