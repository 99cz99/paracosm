import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paracosm/core/db/database.dart';
import 'package:paracosm/core/import/worldbook_importer.dart';
import 'package:paracosm/core/world/world_context.dart';

void main() {
  test('WorldbookImporter parses a bare entries JSON', () {
    final draft = WorldbookImporter().parseJson(jsonEncode({
      'name': '校园设定',
      'entries': [
        {'keys': ['学校'], 'content': '一所普通的学校'},
      ],
    }));
    expect(draft.sourceType, 'sillytavern');
    expect(draft.bookJson['entries'], hasLength(1));
    expect((draft.bookJson['entries'] as List).first['content'], '一所普通的学校');
  });

  test('WorldbookImporter parses a world_book wrapper', () {
    final draft = WorldbookImporter().parseJson(jsonEncode({
      'world_book': {
        'name': 'X',
        'entries': [
          {'keys': ['a'], 'content': 'A'},
        ],
      },
    }));
    expect(draft.bookJson['entries'], hasLength(1));
  });

  test('WorldbookImporter parses markdown into one entry', () {
    final draft = WorldbookImporter()
        .parseMarkdown('# 表达DNA\n\n宁宁的表达风格规则', name: '宁宁世界书');
    expect(draft.sourceType, 'skill');
    final entries = draft.bookJson['entries'] as List;
    expect(entries, hasLength(1));
    final e = entries.first as Map;
    expect(e['content'], contains('表达风格规则'));
    expect(e['keys'] as List, contains('表达DNA'));
  });

  test('WorldbookMatcher matches keys + constant, skips disabled', () {
    final bookJson = jsonEncode({
      'entries': [
        {'keys': ['学校'], 'content': '学校内容', 'enabled': true, 'constant': false},
        {'keys': [], 'content': '恒定内容', 'enabled': true, 'constant': true},
        {'keys': ['禁用'], 'content': '禁用内容', 'enabled': false},
      ],
    });
    final hits = WorldbookMatcher.triggered(bookJson, '我去了学校');
    expect(hits, contains('学校内容'));
    expect(hits, contains('恒定内容'));
    expect(hits, isNot(contains('禁用内容')));
  });

  test('character worldbook bind + set replaces bindings', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    await db.insertCharacter(CharactersCompanion.insert(
      id: 'c1',
      name: '角色',
      corePersonaJson: '{}',
      sourceType: 'manual',
      createdAt: 1,
      updatedAt: 1,
    ));
    await db.insertWorldbook(WorldbooksCompanion.insert(
      id: 'wb1',
      name: '书1',
      bookJson: const Value('{"entries":[]}'),
      createdAt: 1,
      updatedAt: 1,
    ));
    await db.insertWorldbook(WorldbooksCompanion.insert(
      id: 'wb2',
      name: '书2',
      bookJson: const Value('{"entries":[]}'),
      createdAt: 1,
      updatedAt: 1,
    ));

    await db.bindCharacterWorldbook('c1', 'wb1', 1);
    await db.bindCharacterWorldbook('c1', 'wb2', 1);
    expect((await db.getCharacterWorldbookIds('c1')).toSet(), {'wb1', 'wb2'});

    await db.setCharacterWorldbooks('c1', {'wb2'}, 2);
    expect(await db.getCharacterWorldbookIds('c1'), ['wb2']);
    await db.close();
  });

  test('WorldContext merges world-bound worldbooks and builds sections',
      () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    await db.insertWorld(WorldsCompanion.insert(
      id: 'w1',
      name: '校园',
      description: const Value('一个校园'),
      rulesJson: const Value('{"text":"不能打架"}'),
      initialStateJson: const Value('{"text":"开学第一天"}'),
      createdAt: 1,
      updatedAt: 1,
    ));
    await db.insertWorldbook(WorldbooksCompanion.insert(
      id: 'wb1',
      name: '世界书',
      bookJson: Value(jsonEncode({
        'entries': [
          {'keys': ['学校'], 'content': '学校内容', 'enabled': true, 'constant': false},
        ],
      })),
      createdAt: 1,
      updatedAt: 1,
    ));
    await db.bindWorldWorldbook('w1', 'wb1', 1);

    final ctx = await WorldContextBuilder(db).build(
      worldIds: ['w1'],
      worldbookIds: const <String>{},
    );
    expect(ctx.worlds, hasLength(1));
    expect(ctx.worldbooks, hasLength(1)); // pulled in via the world binding

    final worldSection = ctx.buildWorldSection();
    expect(worldSection, contains('校园'));
    expect(worldSection, contains('不能打架'));
    expect(worldSection, contains('开学第一天'));

    final wbSection = ctx.buildWorldbookSection('我去了学校');
    expect(wbSection, contains('【世界书】'));
    expect(wbSection, contains('学校内容'));
    await db.close();
  });
}
