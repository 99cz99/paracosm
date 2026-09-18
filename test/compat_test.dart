import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paracosm/core/backup/backup_service.dart';
import 'package:paracosm/core/db/database.dart';
import 'package:paracosm/core/import/character_exporter.dart';
import 'package:paracosm/core/import/skill_importer.dart';
import 'package:paracosm/core/import/st_card_parser.dart';

void main() {
  test('skill import from a ZIP with a JSON card', () {
    final card = {
      'spec': 'chara_card_v2',
      'data': {'name': '宁宁', 'description': '图书管理员'},
    };
    final bytes = utf8.encode(jsonEncode(card));
    final archive = Archive()..addFile(ArchiveFile('card.json', bytes.length, bytes));
    final zip = ZipEncoder().encode(archive);

    final imported = SkillImporter().importZip(zip);
    expect(imported.name, '宁宁');
    expect(imported.core['description'], '图书管理员');
  });

  test('skill import from Markdown frontmatter', () {
    const md = '---\n'
        'name: 小明\n'
        'description: 一个开朗的角色\n'
        'personality: 开朗\n'
        'tags: [测试, 男]\n'
        '---\n\n'
        '正文（可选）';
    final imported = SkillImporter().importMarkdown(md);
    expect(imported, isNotNull);
    expect(imported!.name, '小明');
    expect(imported.tags, contains('测试'));
  });

  test('skill import from a Claude Code SKILL.md (block scalar + body)', () {
    const md = '---\n'
        'name: nene\n'
        'description: |\n'
        '  图书管理员\n'
        '  温柔\n'
        '\n'
        '  用途：角色扮演\n'
        '---\n\n'
        '# 人格系统\n'
        '用「我」回答。';
    final imported = SkillImporter().importMarkdown(md);
    expect(imported, isNotNull);
    expect(imported!.name, 'nene');
    // Block-scalar description is collected (dedented) instead of dropping the
    // multiline content.
    expect(imported.core['description'], contains('图书管理员'));
    expect(imported.core['description'], contains('用途：角色扮演'));
    // The Markdown body becomes the core system prompt.
    expect(imported.core['system_prompt'], contains('人格系统'));
  });

  test('export then import round-trips a character', () {
    final json = CharacterExporter().exportToJson(
      name: '宁宁',
      core: {'description': '图书管理员', 'personality': '温柔'},
      worldbook: {'entries': []},
      tags: ['女'],
    );
    final imported = StCardParser().parse(json);
    expect(imported.name, '宁宁');
    expect(imported.core['description'], '图书管理员');
    expect(imported.worldbook, isNotNull);
  });

  test('backup then restore preserves data', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    await db.insertCharacter(CharactersCompanion.insert(
      id: 'c1',
      name: '宁宁',
      corePersonaJson: '{}',
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
    await db.insertProviderConfig(ProviderConfigsCompanion.insert(
      id: 'p1',
      name: 'ds',
      type: 'openaiCompatible',
      baseUrl: 'https://api.deepseek.com',
      model: 'deepseek-v4-flash',
      memoryModel: Value('deepseek-v4-flash'),
      isDefault: Value(true),
      createdAt: 1,
      updatedAt: 1,
    ));

    final service = BackupService(db);
    final json = await service.exportAll();
    await service.importAll(json);

    final characters = await db.select(db.characters).get();
    final worlds = await db.select(db.worlds).get();
    expect(characters.length, 1);
    expect(characters.first.name, '宁宁');
    expect(worlds.length, 1);
    expect(worlds.first.name, '校园');

    final providers = await db.select(db.providerConfigs).get();
    expect(providers.length, 1);
    expect(providers.first.model, 'deepseek-v4-flash');
    expect(providers.first.memoryModel, 'deepseek-v4-flash');
    expect(providers.first.isDefault, true);

    await db.close();
  });
}
