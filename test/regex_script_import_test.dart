import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:paracosm/core/import/regex_script.dart';

void main() {
  test('parseRegexScriptImport parses a single script object', () {
    final list = parseRegexScriptImport(jsonEncode({
      'scriptName': '颠倒输入',
      'findRegex': r'([\s\S]*)',
      'replaceString': r'{{reverse: $1}}',
      'promptOnly': true,
    }));
    expect(list, hasLength(1));
    expect(list.first['scriptName'], '颠倒输入');
    expect(list.first['promptOnly'], true);
  });

  test('parseRegexScriptImport parses an array of scripts', () {
    final list = parseRegexScriptImport(jsonEncode([
      {'scriptName': 'a', 'findRegex': 'x', 'replaceString': 'y'},
      {'scriptName': 'b', 'findRegex': 'z', 'replaceString': 'w'},
    ]));
    expect(list, hasLength(2));
    expect(list[1]['scriptName'], 'b');
  });

  test('parseRegexScriptImport returns empty for invalid input', () {
    expect(parseRegexScriptImport(''), isEmpty);
    expect(parseRegexScriptImport('not json'), isEmpty);
    expect(parseRegexScriptImport(jsonEncode('just a string')), isEmpty);
  });
}
