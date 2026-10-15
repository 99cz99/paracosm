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

/// Parses an imported system-prompt preset from either JSON
/// (`{name, content|prompt|system_prompt}`) or a plain-text document (the whole
/// text becomes the prompt). Returns null when there is no usable content.
SystemPromptPresetsCompanion? parseSystemPromptImport(
  String text, {
  String? fallbackName,
}) {
  final trimmed = text.trim();
  if (trimmed.isEmpty) return null;
  final now = DateTime.now().millisecondsSinceEpoch;

  // Try JSON first (SillyTavern system prompts sometimes ship as JSON).
  try {
    final data = jsonDecode(trimmed);
    if (data is Map<String, dynamic>) {
      final name = (data['name'] ?? '').toString().trim();
      final content = (data['content'] ??
              data['prompt'] ??
              data['system_prompt'] ??
              '')
          .toString()
          .trim();
      if (content.isEmpty) return null;
      return SystemPromptPresetsCompanion.insert(
        id: const Uuid().v4(),
        name: name.isEmpty ? (fallbackName ?? '未命名预设') : name,
        content: content,
        createdAt: now,
        updatedAt: now,
      );
    }
  } catch (_) {
    // Not JSON — fall through to plain text.
  }

  return SystemPromptPresetsCompanion.insert(
    id: const Uuid().v4(),
    name: fallbackName ?? '未命名预设',
    content: trimmed,
    createdAt: now,
    updatedAt: now,
  );
}
