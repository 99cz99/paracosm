import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paracosm/core/db/database.dart';
import 'package:paracosm/core/import/imported_character.dart';
import 'package:paracosm/features/contacts/data/character_repository.dart';

void main() {
  test('createCharacter inserts a manual character + default adaptation',
      () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final id = await CharacterRepository(db).createCharacter(
      name: '自定义角色',
      core: {
        'description': '测试',
        'personality': '温柔',
        'system_prompt': '规则',
      },
      tags: ['自定义'],
    );

    final c = await db.getCharacter(id);
    expect(c!.sourceType, 'manual');
    expect(c.name, '自定义角色');

    final adaptation = await db.getAdaptation(id, '');
    expect(adaptation, isNotNull);
    expect(adaptation!.adaptationJson, '{}');
    await db.close();
  });

  test('importCharacter overwrites a same-named character in place', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final repo = CharacterRepository(db);

    final id1 = await repo.importCharacter(ImportedCharacter(
      name: '宁宁',
      core: {'description': 'v1'},
      adaptation: {'persona': 'a1'},
      stateSchema: {'scene': '场景'},
    ));
    await db.updateCharacter(
      id1,
      CharactersCompanion(
        avatarPath: Value('/avatar.png'),
        pinnedAt: Value(12345),
      ),
    );

    final id2 = await repo.importCharacter(ImportedCharacter(
      name: '宁宁',
      core: {'description': 'v2'},
      adaptation: {'persona': 'a2'},
      stateSchema: {'scene': '位置', 'mood': '心情'},
    ));

    expect(id2, id1); // same id → no duplicate

    final c = await db.getCharacter(id1);
    expect(c!.corePersonaJson, contains('v2'));
    expect(c.corePersonaJson, contains('位置'));
    expect(c.avatarPath, '/avatar.png'); // preserved
    expect(c.pinnedAt, 12345); // preserved

    final adaptation = await db.getAdaptation(id1, '');
    expect(adaptation!.adaptationJson, '{"persona":"a2"}'); // updated

    final byName = await db.getCharacterByName('宁宁');
    expect(byName!.id, id1); // still a single row by name

    await db.close();
  });
}
