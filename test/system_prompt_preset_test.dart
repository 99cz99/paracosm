import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:paracosm/core/db/database.dart';
import 'package:paracosm/core/import/system_prompt_preset.dart';

void main() {
  test('parseSystemPromptImport parses JSON with content field', () {
    final c = parseSystemPromptImport(jsonEncode({
      'name': 'NsfwBot',
      'content': '你是…',
    }));
    expect(c, isNotNull);
    expect(c!.name.value, 'NsfwBot');
    expect(c.content.value, '你是…');
  });

  test('parseSystemPromptImport falls back to prompt/system_prompt fields', () {
    expect(
      parseSystemPromptImport(jsonEncode({'name': 'a', 'prompt': 'P'}))!
          .content
          .value,
      'P',
    );
    expect(
      parseSystemPromptImport(jsonEncode({'system_prompt': 'S'}))!
          .content
          .value,
      'S',
    );
  });

  test('parseSystemPromptImport treats plain text as content', () {
    final c = parseSystemPromptImport('这是一段纯文本提示词\n第二行',
        fallbackName: 'my preset');
    expect(c!.name.value, 'my preset');
    expect(c.content.value, '这是一段纯文本提示词\n第二行');
  });

  test('parseSystemPromptImport returns null for empty content', () {
    expect(parseSystemPromptImport('   '), isNull);
    expect(parseSystemPromptImport(jsonEncode({'name': 'x', 'content': ''})),
        isNull);
  });

  test('export then parse round-trips', () {
    final preset = SystemPromptPreset(
      id: 'p1',
      name: '回环',
      content: '提示词内容',
      description: '',
      createdAt: 1,
      updatedAt: 1,
    );
    final c = parseSystemPromptImport(exportSystemPromptPresetJson(preset));
    expect(c!.name.value, '回环');
    expect(c.content.value, '提示词内容');
  });
}
