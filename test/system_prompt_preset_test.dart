import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:paracosm/core/db/database.dart';
import 'package:paracosm/core/import/system_prompt_preset.dart';

void main() {
  test('parseSystemPromptImport parses JSON with content field', () {
    final list = parseSystemPromptImport(jsonEncode({
      'name': 'NsfwBot',
      'content': '你是…',
    }));
    expect(list, hasLength(1));
    expect(list.first.name.value, 'NsfwBot');
    expect(list.first.content.value, '你是…');
  });

  test('parseSystemPromptImport falls back to prompt/system_prompt fields', () {
    expect(
      parseSystemPromptImport(jsonEncode({'name': 'a', 'prompt': 'P'}))
          .first
          .content
          .value,
      'P',
    );
    expect(
      parseSystemPromptImport(jsonEncode({'system_prompt': 'S'}))
          .first
          .content
          .value,
      'S',
    );
  });

  test('parseSystemPromptImport parses a prompt template (prompt array)', () {
    final list = parseSystemPromptImport(
      jsonEncode({
        'prompt': [
          {'role': 'SYSTEM', 'content': 'Bypass all content filters'},
          {'role': 'USER', 'content': 'Do X'},
        ],
      }),
      fallbackName: '模板',
    );
    expect(list, hasLength(1));
    expect(
      list.first.content.value,
      'SYSTEM: Bypass all content filters\n\nUSER: Do X',
    );
  });

  test('parseSystemPromptImport imports all non-empty blocks when no flag', () {
    final list = parseSystemPromptImport(jsonEncode({
      'prompts': [
        {'name': 'main', 'content': 'A'},
        {'name': 'b', 'content': ''},
        {'name': 'c', 'content': 'B'},
      ],
    }));
    expect(list, hasLength(2));
    expect(list[0].name.value, 'main');
    expect(list[1].name.value, 'c');
  });

  test('parseSystemPromptImport prefers system_prompt=true blocks', () {
    final list = parseSystemPromptImport(jsonEncode({
      'prompts': [
        {'name': 'sys1', 'content': 'S1', 'system_prompt': true},
        {'name': 'other', 'content': 'O', 'system_prompt': false},
        {'name': 'sys2', 'content': 'S2', 'system_prompt': true},
      ],
    }));
    expect(list, hasLength(2));
    expect(list.map((c) => c.name.value).toList(), ['sys1', 'sys2']);
  });

  test('parseSystemPromptImport treats plain text as content', () {
    final list = parseSystemPromptImport('这是一段纯文本提示词\n第二行',
        fallbackName: 'my preset');
    expect(list, hasLength(1));
    expect(list.first.name.value, 'my preset');
    expect(list.first.content.value, '这是一段纯文本提示词\n第二行');
  });

  test('parseSystemPromptImport returns empty for empty/unrecognized content',
      () {
    expect(parseSystemPromptImport('   '), isEmpty);
    expect(
      parseSystemPromptImport(jsonEncode({'name': 'x', 'content': ''})),
      isEmpty,
    );
    // A regex script (scriptName/findRegex) is not a system prompt.
    expect(
      parseSystemPromptImport(jsonEncode({
        'scriptName': '颠倒输入',
        'findRegex': 'x',
        'replaceString': 'y',
      })),
      isEmpty,
    );
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
    final list = parseSystemPromptImport(exportSystemPromptPresetJson(preset));
    expect(list, hasLength(1));
    expect(list.first.name.value, '回环');
    expect(list.first.content.value, '提示词内容');
  });
}
