import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:paracosm/features/group_chat/data/auto_speak_rules.dart';

void main() {
  test('regex match triggers', () {
    final hits = AutoSpeakRules.evaluate([
      {'id': '1', 'pattern': '苹果', 'characterId': 'c', 'probability': 100},
    ], '我想吃苹果', Random(1));
    expect(hits, hasLength(1));
  });

  test('enabled=false is skipped', () {
    final hits = AutoSpeakRules.evaluate([
      {
        'id': '1',
        'pattern': '苹果',
        'characterId': 'c',
        'enabled': false,
        'probability': 100,
      },
    ], '苹果', Random(1));
    expect(hits, isEmpty);
  });

  test('missing probability defaults to 100 (always)', () {
    final hits = AutoSpeakRules.evaluate([
      {'id': '1', 'pattern': '苹果', 'characterId': 'c'},
    ], '苹果', Random(1));
    expect(hits, hasLength(1));
  });

  test('probability=0 never triggers', () {
    final hits = AutoSpeakRules.evaluate([
      {'id': '1', 'pattern': '苹果', 'characterId': 'c', 'probability': 0},
    ], '苹果', Random(1));
    expect(hits, isEmpty);
  });

  test('invalid regex is skipped silently', () {
    final hits = AutoSpeakRules.evaluate([
      {'id': '1', 'pattern': '[', 'characterId': 'c', 'probability': 100},
    ], 'x', Random(1));
    expect(hits, isEmpty);
  });

  test('probability is deterministic for a fixed seed', () {
    final rules = [
      {'id': '1', 'pattern': '苹果', 'characterId': 'c', 'probability': 50},
    ];
    final a = AutoSpeakRules.evaluate(rules, '苹果', Random(7));
    final b = AutoSpeakRules.evaluate(rules, '苹果', Random(7));
    expect(a.length, b.length);
  });
}
