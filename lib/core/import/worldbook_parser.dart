/// Normalizes a SillyTavern `character_book` / lorebook into the canonical
/// shape stored in `Characters.worldbookJson`.
///
/// Handles both the embedded form (V2/V3, `entries` as a list) and the
/// standalone lorebook form (`entries` as an object keyed by id). Keyword
/// triggering itself lands in P2 — here we only preserve a stable structure.
class WorldbookParser {
  Map<String, dynamic> normalize(Map<String, dynamic> book) {
    final entries = <Map<String, dynamic>>[];

    final rawEntries = book['entries'];
    if (rawEntries is List) {
      for (final e in rawEntries) {
        if (e is Map) entries.add(_entry(Map<String, dynamic>.from(e)));
      }
    } else if (rawEntries is Map) {
      // Standalone lorebook: entries keyed by id.
      for (final e in rawEntries.values) {
        if (e is Map) entries.add(_entry(Map<String, dynamic>.from(e)));
      }
    }

    return <String, dynamic>{
      'name': book['name']?.toString() ?? '',
      'description': book['description']?.toString() ?? '',
      'scan_depth': book['scan_depth'],
      'token_budget': book['token_budget'],
      'recursive_scanning': book['recursive_scanning'] ?? false,
      'entries': entries,
    };
  }

  Map<String, dynamic> _entry(Map<String, dynamic> e) => <String, dynamic>{
        'keys': e['keys'] is List
            ? List<dynamic>.from(e['keys'] as List)
            : <dynamic>[],
        'secondary_keys': e['secondary_keys'] is List
            ? List<dynamic>.from(e['secondary_keys'] as List)
            : <dynamic>[],
        'content': e['content']?.toString() ?? '',
        'enabled': e['enabled'] ?? true,
        'constant': e['constant'] ?? false,
        'insertion_order': e['insertion_order'],
        'position': e['position']?.toString(),
        'use_regex': e['use_regex'] ?? false,
        'case_sensitive': e['case_sensitive'] ?? false,
        'selective': e['selective'] ?? false,
        'priority': e['priority'],
        'comment': e['comment']?.toString() ?? '',
        // Preserved metadata so non-standard / complex cards don't lose detail.
        'group': e['group']?.toString(),
        'probability': e['probability'],
        'exclude_recursion': e['exclude_recursion'] ?? false,
        'match_whole_words': e['match_whole_words'] ?? false,
      };
}
