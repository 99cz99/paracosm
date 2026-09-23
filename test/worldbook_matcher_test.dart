import 'dart:convert';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:paracosm/core/world/world_context.dart';

String _book(List<Map<String, dynamic>> entries,
    {bool recursive = false, int scanDepth = 2}) {
  return jsonEncode({
    'entries': entries,
    'recursive_scanning': recursive,
    'scan_depth': scanDepth,
  });
}

List<String> _contents(List<Map<String, dynamic>> matched) =>
    [for (final e in matched) e['content']?.toString() ?? ''];

void main() {
  test('regex keys trigger', () {
    final matched = WorldbookMatcher.matchedEntries(
        _book([
          {'keys': ['^学校'], 'use_regex': true, 'content': 'A'},
        ]),
        '学校门口');
    expect(_contents(matched), contains('A'));
  });

  test('case-insensitive by default', () {
    final matched = WorldbookMatcher.matchedEntries(
        _book([
          {'keys': ['Apple'], 'content': 'A'},
        ]),
        'I like apple');
    expect(_contents(matched), contains('A'));
  });

  test('case_sensitive respects case', () {
    final matched = WorldbookMatcher.matchedEntries(
        _book([
          {'keys': ['Apple'], 'case_sensitive': true, 'content': 'A'},
        ]),
        'apple');
    expect(matched, isEmpty);
  });

  test('selective requires all keys and secondary keys', () {
    final book = _book([
      {
        'keys': ['a', 'b'],
        'secondary_keys': ['c'],
        'selective': true,
        'content': 'A',
      },
    ]);
    expect(WorldbookMatcher.matchedEntries(book, 'a b c'), hasLength(1));
    expect(WorldbookMatcher.matchedEntries(book, 'a c'), isEmpty);
    expect(WorldbookMatcher.matchedEntries(book, 'a b'), isEmpty);
  });

  test('secondary_keys OR by default', () {
    final matched = WorldbookMatcher.matchedEntries(
        _book([
          {'keys': ['x'], 'secondary_keys': ['y'], 'content': 'A'},
        ]),
        'y');
    expect(_contents(matched), contains('A'));
  });

  test('match_whole_words avoids partial hits', () {
    final book = _book([
      {'keys': ['cat'], 'match_whole_words': true, 'content': 'A'},
    ]);
    expect(WorldbookMatcher.matchedEntries(book, 'a cat sat'), hasLength(1));
    expect(WorldbookMatcher.matchedEntries(book, 'catalog'), isEmpty);
  });

  test('recursive_scanning pulls in entries triggered by content', () {
    final book = _book([
      {'keys': ['学校'], 'content': '学校里有图书馆'},
      {'keys': ['图书馆'], 'content': 'B'},
    ], recursive: true);
    final matched = WorldbookMatcher.matchedEntries(book, '我去了学校');
    expect(_contents(matched), containsAll(['学校里有图书馆', 'B']));
  });

  test('exclude_recursion stops the chain', () {
    final book = _book([
      {'keys': ['学校'], 'content': '学校里有图书馆', 'exclude_recursion': true},
      {'keys': ['图书馆'], 'content': 'B'},
    ], recursive: true);
    final matched = WorldbookMatcher.matchedEntries(book, '我去了学校');
    expect(_contents(matched), contains('学校里有图书馆'));
    expect(_contents(matched), isNot(contains('B')));
  });

  test('entries are ordered by priority desc', () {
    final book = _book([
      {'keys': ['x'], 'content': 'low', 'priority': 1},
      {'keys': ['x'], 'content': 'high', 'priority': 10},
    ]);
    final matched = WorldbookMatcher.matchedEntries(book, 'x');
    expect(_contents(matched), ['high', 'low']);
  });

  test('{{random}} expands to one of the options', () {
    final book = _book([
      {'keys': ['x'], 'content': '{{random:甲|乙}}'},
    ]);
    final out = WorldbookMatcher.triggered(book, 'x', random: Random(42));
    expect(out.single, anyOf('甲', '乙'));
  });

  test('constant entries honor depth gating', () {
    final book = _book([
      {'constant': true, 'keys': [], 'depth': 4, 'content': '微信玩法'},
    ]);
    // Below the entry's depth → not injected; at/above it → always injected.
    expect(WorldbookMatcher.matchedEntries(book, 'anything', depth: 3),
        isEmpty);
    expect(
      _contents(WorldbookMatcher.matchedEntries(book, 'anything', depth: 4)),
      contains('微信玩法'),
    );
  });
}
