import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paracosm/core/db/database.dart';
import 'package:paracosm/core/import/character_exporter.dart';
import 'package:paracosm/core/import/skill_importer.dart';
import 'package:paracosm/core/utils/app_exception.dart';
import 'package:paracosm/features/contacts/data/character_repository.dart';

/// Builds a ZIP archive from name → content pairs.
List<int> _zip(Map<String, String> files) {
  final archive = Archive();
  files.forEach((name, content) {
    final bytes = utf8.encode(content);
    archive.addFile(ArchiveFile(name, bytes.length, bytes));
  });
  return ZipEncoder().encode(archive);
}

void main() {
  group('importMarkdown', () {
    test('parses name + description and captures the body as system_prompt',
        () {
      const md = '---\n'
          'name: 小明\n'
          'description: 一个开朗的角色\n'
          '---\n\n'
          '# 人格系统\n用「我」回答。';
      final imported = SkillImporter().importMarkdown(md);
      expect(imported, isNotNull);
      expect(imported!.name, '小明');
      expect(imported.core['description'], '一个开朗的角色');
      expect(imported.core['system_prompt'], contains('人格系统'));
    });

    test('block scalar | is collected and dedented', () {
      const md = '---\n'
          'name: nene\n'
          'description: |\n'
          '  第一行\n'
          '  第二行\n'
          '---\n';
      final imported = SkillImporter().importMarkdown(md)!;
      expect(imported.core['description'], '第一行\n第二行');
    });

    test('folded scalar > joins lines with spaces', () {
      const md = '---\n'
          'name: nene\n'
          'description: >\n'
          '  第一行\n'
          '  第二行\n'
          '---\n';
      final imported = SkillImporter().importMarkdown(md)!;
      expect(imported.core['description'], '第一行 第二行');
    });

    test('normalizes CRLF line endings', () {
      final md = '---\r\nname: nene\r\ndescription: d\r\n---\r\n\r\n正文';
      final imported = SkillImporter().importMarkdown(md);
      expect(imported, isNotNull);
      expect(imported!.name, 'nene');
      expect(imported.core['system_prompt'], '正文');
    });

    test('parses tags as array and as single string', () {
      final array = SkillImporter()
          .importMarkdown('---\nname: a\ntags: [x, y]\n---\n')!;
      expect(array.tags, containsAll(['x', 'y']));

      final single = SkillImporter()
          .importMarkdown('---\nname: a\ntags: 单人\n---\n')!;
      expect(single.tags, ['单人']);
    });

    test('unquotes quoted scalar values', () {
      final imported = SkillImporter()
          .importMarkdown('---\nname: a\ndescription: "带引号"\n---\n')!;
      expect(imported.core['description'], '带引号');
    });

    test('returns null when there is no frontmatter', () {
      expect(SkillImporter().importMarkdown('没有前置元数据'), isNull);
    });

    test('returns null when frontmatter has no name', () {
      expect(
        SkillImporter().importMarkdown('---\ndescription: 没名字\n---\n'),
        isNull,
      );
    });
  });

  group('importZip', () {
    test('parses a JSON character card inside the ZIP', () {
      final card = {'spec': 'chara_card_v2', 'data': {'name': '宁宁'}};
      final zip = _zip({'card.json': jsonEncode(card)});
      final imported = SkillImporter().importZip(zip);
      expect(imported.name, '宁宁');
    });

    test('prefers a root SKILL.md over references/*.md', () {
      final zip = _zip({
        'SKILL.md': '---\nname: nene\ndescription: d\n---\n\n# 人格系统',
        'references/research/01-writings.md':
            '---\nname: research\ndescription: 调研\n---\n\n调研正文',
      });
      final imported = SkillImporter().importZip(zip);
      expect(imported.name, 'nene');
      expect(imported.core['system_prompt'], contains('人格系统'));
    });

    test('reads references/affinity.json into the affinity field', () {
      final zip = _zip({
        'SKILL.md': '---\nname: nene\ndescription: d\n---\n\n正文',
        'references/affinity.json':
            jsonEncode({'trust_level': 1, 'trust_value': 3, 'corruption_value': 0}),
      });
      final imported = SkillImporter().importZip(zip);
      expect(imported.affinity, isNotNull);
      expect(imported.affinity!['trust_value'], 3);
    });

    test('reads references/state_schema.json into the stateSchema field', () {
      final zip = _zip({
        'SKILL.md': '---\nname: nene\ndescription: d\n---\n\n正文',
        'references/state_schema.json': jsonEncode({'scene': '位置', 'facts': '已知'}),
      });
      final imported = SkillImporter().importZip(zip);
      expect(imported.stateSchema, isNotNull);
      expect(imported.stateSchema!['scene'], '位置');
    });

    test('imports references/research/*.md into entries and game_text into sources',
        () {
      final zip = _zip({
        'SKILL.md': '---\nname: nene\ndescription: d\n---\n\n正文',
        'references/research/03-expression-dna.md': '# 表达DNA\n\n宁宁的表达风格规则',
        'references/quality-validation.md': '# 质量校验\n\n校验说明',
        'references/sources/game_text/Nene_only.txt': '游戏原文内容',
      });
      final imported = SkillImporter().importZip(zip);
      expect(imported.worldbook, isNotNull);
      final wb = imported.worldbook!;

      final entries = (wb['entries'] as List).cast<Map<String, dynamic>>();
      expect(entries.length, 2); // 2 份调研进 entries
      final dna = entries.firstWhere(
        (e) => (e['content'] as String).contains('表达DNA'),
      );
      expect(dna['keys'], contains('表达DNA'));
      expect(dna['keys'], contains('expression-dna'));

      final sources = (wb['sources'] as List).cast<Map<String, dynamic>>();
      expect(sources.length, 1); // 原文进 sources，不进 entries
      expect(sources.first['name'], 'game_text/Nene_only.txt');
      expect(sources.first['content'], '游戏原文内容');
    });

    test('throws when no character card or markdown is found', () {
      final zip = _zip({
        'references/affinity.json': jsonEncode({'trust_value': 3}),
      });
      expect(() => SkillImporter().importZip(zip), throwsA(isA<AppException>()));
    });
  });

  group('affinity → core → system prompt', () {
    test('importFromBytes persists affinity under core["affinity"]', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      final repo = CharacterRepository(db);
      final zip = _zip({
        'SKILL.md': '---\nname: nene\ndescription: d\n---\n\n正文',
        'references/affinity.json':
            jsonEncode({'trust_value': 3, 'corruption_value': 0}),
      });

      final id = await repo.importFromBytes(zip, filename: 'nene.zip');
      final character = await db.getCharacter(id);

      expect(character!.sourceType, 'skill');
      final core = jsonDecode(character.corePersonaJson) as Map<String, dynamic>;
      expect(core['affinity'], isA<Map>());
      expect((core['affinity'] as Map)['trust_value'], 3);

      await db.close();
    });

    test('exporter drops the affinity key from SillyTavern cards', () {
      final json = CharacterExporter().exportToJson(
        name: 'nene',
        core: {'description': 'd', 'affinity': {'trust_value': 3}},
      );
      final data = (jsonDecode(json) as Map<String, dynamic>)['data'];
      expect((data as Map<String, dynamic>).containsKey('affinity'), isFalse);
      expect(data['description'], 'd');
    });
  });

  group('state_schema → core → export', () {
    test('importFromBytes persists state_schema under core["state_schema"]',
        () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      final repo = CharacterRepository(db);
      final zip = _zip({
        'SKILL.md': '---\nname: nene\ndescription: d\n---\n\n正文',
        'references/state_schema.json': jsonEncode({'scene': '位置'}),
      });

      final id = await repo.importFromBytes(zip, filename: 'nene.zip');
      final character = await db.getCharacter(id);
      final core = jsonDecode(character!.corePersonaJson) as Map<String, dynamic>;
      expect(core['state_schema'], isA<Map>());
      expect((core['state_schema'] as Map)['scene'], '位置');

      await db.close();
    });

    test('exporter drops the state_schema key from SillyTavern cards', () {
      final json = CharacterExporter().exportToJson(
        name: 'nene',
        core: {'description': 'd', 'state_schema': {'scene': '位置'}},
      );
      final data = (jsonDecode(json) as Map<String, dynamic>)['data'];
      expect((data as Map<String, dynamic>).containsKey('state_schema'), isFalse);
    });
  });
}
