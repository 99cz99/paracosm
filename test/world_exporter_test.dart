import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:paracosm/core/db/database.dart';
import 'package:paracosm/features/worlds/data/world_exporter.dart';

void main() {
  test('parseWorldJson wraps plain-string rules/state into {"text":...}', () {
    final c = parseWorldJson(jsonEncode({
      'type': 'paracosm_world',
      'name': '测试世界',
      'rulesJson': '这是规则内容',
      'initialStateJson': '这是初始状态',
    }));
    expect(c, isNotNull);
    expect(c!.rulesJson.value, '{"text":"这是规则内容"}');
    expect(c.initialStateJson.value, '{"text":"这是初始状态"}');
    expect(c.npcPoolJson.value, '{}');
  });

  test('parseWorldJson keeps an already-wrapped {"text":...} field', () {
    final c = parseWorldJson(jsonEncode({
      'name': 'X',
      'rulesJson': '{"text":"规则"}',
    }));
    expect(c!.rulesJson.value, '{"text":"规则"}');
  });

  test('parseWorldJson accepts object-shaped fields (assistant emits a Map)',
      () {
    final c = parseWorldJson(jsonEncode({
      'name': 'Y',
      'rulesJson': {'text': '对象规则'},
    }));
    expect(c!.rulesJson.value, '{"text":"对象规则"}');
  });

  test('export then parse round-trips', () {
    final world = World(
      id: 'w1',
      name: '回环',
      description: 'desc',
      rulesJson: '{"text":"规则"}',
      worldbookJson: '{}',
      initialStateJson: '{"text":"状态"}',
      npcPoolJson: '{}',
      createdAt: 1,
      updatedAt: 1,
    );
    final c = parseWorldJson(exportWorldJson(world));
    expect(c!.name.value, '回环');
    expect(c.rulesJson.value, '{"text":"规则"}');
    expect(c.initialStateJson.value, '{"text":"状态"}');
  });
}
