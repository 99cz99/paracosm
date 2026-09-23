// SillyTavern-style "regex scripts": JS-regex find/replace rules.
//
// [findRegex] is either `/pattern/flags` or a bare literal; [replaceString]
// uses `$1`..`$n` back-references. Invalid regexes are skipped silently.
//
// SillyTavern semantics mirrored here:
// - `placement` selects which message source a script applies to:
//   1 = user input, 2 = AI output.
// - `markdownOnly` scripts run at display time; `promptOnly` scripts run at
//   prompt-build time. A script that is neither would apply + persist at save
//   time, but Paracosm stores raw text, so only the first two are used.
// - `minDepth`/`maxDepth` gate by message depth (0 = the most recent message).

/// SillyTavern `regex_placement` values (see SillyTavern engine.js).
const int _placementUser = 1;
const int _placementAi = 2;

/// Applies display-side (`promptOnly == false`) scripts to a rendered message.
/// [role] is 'user' or 'assistant'; scripts targeting the other side are
/// skipped. Prompt-only deletions (e.g. `<TTL>…</TTL>`) never run here — doing
/// so would erase the panels they wrap (status bar / WeChat / forum).
/// [depth] (0 = the newest message) gates scripts with `minDepth`/`maxDepth`,
/// so a deletion like "微信删除" only clears old messages, not the recent ones.
String applyRegexScripts(List<Map<String, dynamic>> scripts, String text,
    {String role = 'assistant', int? depth}) {
  return _apply(scripts, text, promptMode: false, role: role, depth: depth);
}

/// Applies prompt-side (`promptOnly == true`) scripts to a message's content
/// before it is sent to the model. [role] selects which placement to match,
/// and [depth] (0 = the last message) gates scripts with `minDepth`/`maxDepth`.
String applyPromptRegexScripts(List<Map<String, dynamic>> scripts, String text,
    {String role = 'assistant', int? depth}) {
  return _apply(scripts, text, promptMode: true, role: role, depth: depth);
}

String _apply(
  List<Map<String, dynamic>> scripts,
  String text, {
  required bool promptMode,
  required String role,
  required int? depth,
}) {
  final placement = role == 'user' ? _placementUser : _placementAi;
  var result = text;
  for (final s in scripts) {
    if (s['disabled'] == true) continue;
    if ((s['promptOnly'] == true) != promptMode) continue;
    if (!_placementHas(s, placement)) continue;
    // minDepth/maxDepth gate by distance from the latest message (0 = last).
    if (depth != null) {
      final minD = _toIntOrNull(s['minDepth']);
      final maxD = _toIntOrNull(s['maxDepth']);
      if (minD != null && minD >= -1 && depth < minD) continue;
      if (maxD != null && maxD >= 0 && depth > maxD) continue;
    }
    result = _applyOne(s, result);
  }
  return result;
}

String _applyOne(Map<String, dynamic> s, String text) {
  final find = s['findRegex']?.toString() ?? '';
  final replace = s['replaceString']?.toString() ?? '';
  final parsed = _parseFind(find);
  if (parsed == null) return text;
  final (pattern, flags) = parsed;
  try {
    final regex = RegExp(
      pattern,
      multiLine: flags.contains('m'),
      caseSensitive: !flags.contains('i'),
      dotAll: flags.contains('s'),
    );
    return text.replaceAllMapped(regex, (m) {
      var out = replace;
      for (var i = m.groupCount; i >= 1; i--) {
        out = out.replaceAll('\$$i', m.group(i) ?? '');
      }
      return out;
    });
  } catch (_) {
    // Skip this script on a bad regex.
    return text;
  }
}

/// Whether [s] targets the given placement. Missing/empty `placement` means
/// "no constraint" (older cards predate the field), so it applies everywhere.
bool _placementHas(Map<String, dynamic> s, int value) {
  final p = s['placement'];
  if (p is! List || p.isEmpty) return true;
  return p.any((v) => v == value);
}

int? _toIntOrNull(dynamic v) {
  if (v is num) return v.toInt();
  if (v == null) return null;
  return int.tryParse(v.toString());
}

(String, String)? _parseFind(String raw) {
  if (raw.isEmpty) return null;
  final trimmed = raw.trim();
  if (trimmed.startsWith('/')) {
    final lastSlash = trimmed.lastIndexOf('/');
    if (lastSlash <= 0) return null;
    return (trimmed.substring(1, lastSlash), trimmed.substring(lastSlash + 1));
  }
  // Bare (non-`/`) value — treat as a regex pattern; cards may omit the
  // surrounding slashes (e.g. `\[QQ\]` means "match the literal `[QQ]`").
  return (raw, '');
}
