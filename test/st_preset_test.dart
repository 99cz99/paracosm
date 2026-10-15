import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:paracosm/core/db/database.dart';
import 'package:paracosm/core/import/st_preset.dart';

void main() {
  test('parseStPresetJson maps SillyTavern sampling fields', () {
    final c = parseStPresetJson(jsonEncode({
      'name': 'ST 预设',
      'temperature': 0.7,
      'top_p': 0.9,
      'max_length': 300,
      'repetition_penalty_presence': 0.1,
      'repetition_penalty_frequency': 0.2,
    }));
    expect(c, isNotNull);
    expect(c!.name.value, 'ST 预设');
    expect(c.temperature.value, 0.7);
    expect(c.topP.value, 0.9);
    expect(c.maxTokens.value, 300);
    expect(c.presencePenalty.value, 0.1);
    expect(c.frequencyPenalty.value, 0.2);
  });

  test('parseStPresetJson accepts max_tokens / response_length fallbacks', () {
    expect(
      parseStPresetJson(jsonEncode({'name': 'a', 'max_tokens': 512}))!
          .maxTokens
          .value,
      512,
    );
    expect(
      parseStPresetJson(jsonEncode({'name': 'a', 'response_length': 256}))!
          .maxTokens
          .value,
      256,
    );
  });

  test('parseStPresetJson rejects empty name or non-JSON', () {
    expect(parseStPresetJson(jsonEncode({'name': ''})), isNull);
    expect(parseStPresetJson('not json'), isNull);
  });

  test('exportPresetJson emits SillyTavern-compatible fields', () {
    final json = jsonDecode(exportPresetJson(Preset(
      id: 'p1',
      name: '我的预设',
      temperature: 0.8,
      topP: 0.95,
      maxTokens: 400,
      createdAt: 1,
      updatedAt: 1,
    )));
    expect(json['type'], 'paracosm_preset');
    expect(json['name'], '我的预设');
    expect(json['temperature'], 0.8);
    expect(json['top_p'], 0.95);
    expect(json['max_length'], 400);
  });

  test('export then parse round-trips', () {
    final preset = Preset(
      id: 'p1',
      name: '回环',
      temperature: 0.6,
      topP: 0.8,
      maxTokens: 200,
      presencePenalty: 0.1,
      frequencyPenalty: 0.2,
      createdAt: 1,
      updatedAt: 1,
    );
    final c = parseStPresetJson(exportPresetJson(preset));
    expect(c!.name.value, '回环');
    expect(c.temperature.value, 0.6);
    expect(c.topP.value, 0.8);
    expect(c.maxTokens.value, 200);
    expect(c.presencePenalty.value, 0.1);
    expect(c.frequencyPenalty.value, 0.2);
  });
}
