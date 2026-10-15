import 'dart:convert';

/// Parses an imported SillyTavern regex script — either a single script object
/// or an array of script objects — into a list of script maps (the camelCase
/// `scriptName`/`findRegex`/`replaceString`/… shape that `applyRegexScripts`
/// already consumes). Returns empty on invalid/empty input.
List<Map<String, dynamic>> parseRegexScriptImport(String text) {
  final trimmed = text.trim();
  if (trimmed.isEmpty) return const [];
  try {
    final data = jsonDecode(trimmed);
    if (data is List) {
      return [
        for (final e in data)
          if (e is Map) Map<String, dynamic>.from(e),
      ];
    }
    if (data is Map<String, dynamic>) {
      return [data];
    }
  } catch (_) {}
  return const [];
}
