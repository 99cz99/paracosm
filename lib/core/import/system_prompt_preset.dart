import 'dart:convert';

import 'package:uuid/uuid.dart';

import '../db/database.dart';

/// Exports a system-prompt preset to a shareable JSON document, round-trippable
/// via [parseSystemPromptImport].
String exportSystemPromptPresetJson(SystemPromptPreset p) => jsonEncode({
      'type': 'paracosm_sysprompt',
      'name': p.name,
      'content': p.content,
    });

/// Parses an imported system-prompt preset into zero or more companions.
///
/// Recognizes the common SillyTavern shapes:
/// 1. simple `{name, content|prompt|system_prompt}` (content is a string);
/// 2. prompt template `{prompt: [{role, content}, …]}` — one preset;
/// 3. settings export `{prompts: [{name, content, …}, …]}` — one preset per
///    block with non-empty content.
/// Falls back to plain text only when the document is NOT JSON (the whole text
/// becomes one preset). Unrecognized JSON returns empty.
List<SystemPromptPresetsCompanion> parseSystemPromptImport(
  String text, {
  String? fallbackName,
}) {
  final trimmed = text.trim();
  if (trimmed.isEmpty) return const [];
  final now = DateTime.now().millisecondsSinceEpoch;

  SystemPromptPresetsCompanion make(String name, String content) {
    final resolved =
        name.trim().isEmpty ? (fallbackName ?? '未命名预设') : name.trim();
    return SystemPromptPresetsCompanion.insert(
      id: const Uuid().v4(),
      name: resolved,
      content: content.trim(),
      createdAt: now,
      updatedAt: now,
    );
  }

  dynamic decoded;
  var isJson = false;
  try {
    decoded = jsonDecode(trimmed);
    isJson = true;
  } catch (_) {
    isJson = false;
  }

  if (isJson && decoded is Map<String, dynamic>) {
    // 1. Simple string content.
    final simple = decoded['content'] ?? decoded['prompt'] ?? decoded['system_prompt'];
    if (simple is String && simple.trim().isNotEmpty) {
      return [make((decoded['name'] ?? '').toString(), simple)];
    }

    // 2. Prompt template: `prompt` is a list of {role, content} messages.
    final prompt = decoded['prompt'];
    if (prompt is List) {
      final content = prompt
          .whereType<Map>()
          .map(_formatMessage)
          .where((s) => s.isNotEmpty)
          .join('\n\n');
      if (content.isNotEmpty) {
        return [make((decoded['name'] ?? '').toString(), content)];
      }
    }

    // 3. Settings export: `prompts` is a list of prompt blocks. Prefer the
    // blocks flagged as system prompts (`system_prompt: true`); fall back to
    // every non-empty block when no block carries the flag.
    final prompts = decoded['prompts'];
    if (prompts is List) {
      final blocks = prompts.whereType<Map>().toList();
      var candidates = blocks.where((p) => p['system_prompt'] == true).toList();
      if (candidates.isEmpty) candidates = blocks;
      final out = <SystemPromptPresetsCompanion>[];
      for (final p in candidates) {
        final content = (p['content'] ?? '').toString().trim();
        if (content.isEmpty) continue;
        out.add(make((p['name'] ?? '').toString(), content));
      }
      if (out.isNotEmpty) return out;
    }
  }

  // JSON but an unrecognized shape → no usable content.
  if (isJson) return const [];

  // Plain text: the whole document becomes one preset.
  return [make(fallbackName ?? '未命名预设', trimmed)];
}

/// Renders one prompt-template message as `role: content`, skipping empties.
String _formatMessage(Map m) {
  final role = (m['role'] ?? '').toString().trim();
  final content = (m['content'] ?? '').toString().trim();
  if (content.isEmpty) return '';
  return role.isEmpty ? content : '$role: $content';
}
