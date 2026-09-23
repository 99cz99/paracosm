import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:paracosm/core/import/character_exporter.dart';

void main() {
  test('exportToJson moves regex_scripts under data.extensions', () {
    final json = CharacterExporter().exportToJson(
      name: 'Alice',
      core: {
        'description': 'd',
        'regex_scripts': [
          {'findRegex': '/x/', 'replaceString': 'y', 'markdownOnly': true},
        ],
      },
    );
    final data = jsonDecode(json)['data'] as Map<String, dynamic>;
    expect(data.containsKey('regex_scripts'), isFalse);
    expect(data['extensions'], isA<Map<String, dynamic>>());
    expect(
      (data['extensions'] as Map<String, dynamic>)['regex_scripts'],
      isA<List<dynamic>>(),
    );
  });

  test('exportToJson omits extensions when regex_scripts is empty', () {
    final json = CharacterExporter().exportToJson(
      name: 'Alice',
      core: {'description': 'd', 'regex_scripts': <dynamic>[]},
    );
    final data = jsonDecode(json)['data'] as Map<String, dynamic>;
    expect(data.containsKey('regex_scripts'), isFalse);
    expect(data.containsKey('extensions'), isFalse);
  });

  test('exportToJson still drops app-internal affinity/state_schema', () {
    final json = CharacterExporter().exportToJson(
      name: 'Alice',
      core: {
        'description': 'd',
        'affinity': {'trust_value': 0},
        'state_schema': {'time': '时间'},
      },
    );
    final data = jsonDecode(json)['data'] as Map<String, dynamic>;
    expect(data.containsKey('affinity'), isFalse);
    expect(data.containsKey('state_schema'), isFalse);
  });
}
