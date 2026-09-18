import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:paracosm/core/import/st_card_parser.dart';

void main() {
  test('parses a V2 card into core + adaptation + worldbook', () {
    final card = {
      'spec': 'chara_card_v2',
      'spec_version': '2.0',
      'data': {
        'name': '测试角色',
        'description': '一个测试角色',
        'personality': '温柔',
        'scenario': '校园',
        'first_mes': '你好呀',
        'tags': ['测试', '女性'],
        'character_book': {
          'name': '世界书',
          'entries': [
            {'keys': ['学校'], 'content': '一所普通的学校'},
          ],
        },
      },
    };

    final imported = StCardParser().parse(jsonEncode(card));

    expect(imported.name, '测试角色');
    expect(imported.core['description'], '一个测试角色');
    expect(imported.core['personality'], '温柔');
    // Default adaptation must start empty (no duplicated personality, no
    // stray `worldId` key inside the JSON).
    expect(imported.adaptation['persona'], '');
    expect(imported.adaptation.containsKey('worldId'), isFalse);
    expect(imported.tags, containsAll(['测试', '女性']));
    expect(imported.worldbook, isNotNull);
    expect(imported.worldbook!['entries'], hasLength(1));
  });

  test('parses flat V1 card', () {
    final imported = StCardParser().parse(
      jsonEncode({'name': '旧卡', 'description': 'V1 格式'}),
    );
    expect(imported.name, '旧卡');
    expect(imported.core['description'], 'V1 格式');
  });

  test('rejects a card without a name', () {
    expect(
      () => StCardParser().parse('{"data":{"description":"无名字"}}'),
      throwsA(anything),
    );
  });
}
