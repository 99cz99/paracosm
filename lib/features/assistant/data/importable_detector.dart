import 'dart:convert';

/// What kind of importable payload an assistant reply contains.
enum ImportableKind { character, world, worldbook }

class ImportableResult {
  const ImportableResult(this.kind, this.json);

  final ImportableKind kind;

  /// The raw JSON object string (validated, braces balanced).
  final String json;
}

/// Detects whether an assistant reply contains an importable card / world /
/// worldbook JSON and returns its raw JSON (from a ```json fence or a bare
/// object). Returns null when nothing importable is found.
ImportableResult? detectImportable(String content) {
  final json = _extractJson(content);
  if (json == null) return null;
  final kind = _classify(json);
  if (kind == null) return null;
  return ImportableResult(kind, json);
}

String? _extractJson(String content) {
  // Preferred: a ```json (or ```) code fence.
  final fence =
      RegExp(r'```(?:json)?\s*\n?([\s\S]*?)```').firstMatch(content);
  if (fence != null) {
    final fromFence = _firstJsonObject(fence.group(1)!);
    if (fromFence != null) return fromFence;
  }
  // Fallback: the first balanced JSON object in the raw text.
  return _firstJsonObject(content);
}

/// Extracts the first balanced JSON object starting at the first `{`.
String? _firstJsonObject(String text) {
  final start = text.indexOf('{');
  if (start < 0) return null;
  var depth = 0;
  var inString = false;
  var escaped = false;
  for (var i = start; i < text.length; i++) {
    final c = text[i];
    if (inString) {
      if (escaped) {
        escaped = false;
      } else if (c == '\\') {
        escaped = true;
      } else if (c == '"') {
        inString = false;
      }
      continue;
    }
    if (c == '"') {
      inString = true;
    } else if (c == '{') {
      depth++;
    } else if (c == '}') {
      depth--;
      if (depth == 0) {
        final candidate = text.substring(start, i + 1);
        try {
          jsonDecode(candidate);
          return candidate;
        } catch (_) {
          return null;
        }
      }
    }
  }
  return null;
}

ImportableKind? _classify(String json) {
  try {
    final map = jsonDecode(json);
    if (map is! Map<String, dynamic>) return null;
    // World export: explicit type or the rules/initialState/npc fields.
    if (map['type'] == 'paracosm_world' ||
        (map.containsKey('rulesJson') && map.containsKey('initialStateJson'))) {
      return ImportableKind.world;
    }
    // Worldbook: an entries array.
    if (map['entries'] is List) return ImportableKind.worldbook;
    // Character card: a name plus card-specific fields.
    const cardFields = [
      'description',
      'personality',
      'scenario',
      'first_mes',
      'system_prompt',
      'mes_example',
    ];
    if (map['name'] is String && map.keys.any(cardFields.contains)) {
      return ImportableKind.character;
    }
    return null;
  } catch (_) {
    return null;
  }
}
