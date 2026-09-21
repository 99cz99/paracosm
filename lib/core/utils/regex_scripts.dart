/// SillyTavern-style "regex scripts": JS-regex find/replace rules applied to
/// the character's displayed output (e.g. `<CG{code}>` → `<img src=…>`).
///
/// [findRegex] is either `/pattern/flags` or a bare literal; [replaceString]
/// uses `$1`..`$n` back-references. Invalid regexes are skipped silently.
String applyRegexScripts(List<Map<String, dynamic>> scripts, String text) {
  var result = text;
  for (final s in scripts) {
    // Skip disabled scripts, and prompt-only scripts: promptOnly means the
    // script should only affect the prompt sent to the model, not the
    // rendered message. Running a prompt-only deletion (e.g. `<TTL>…</TTL>`)
    // on the display would erase the panels it wraps (status/WeChat/forum).
    if (s['disabled'] == true || s['promptOnly'] == true) continue;
    final find = s['findRegex']?.toString() ?? '';
    final replace = s['replaceString']?.toString() ?? '';
    final parsed = _parseFind(find);
    if (parsed == null) continue;
    final (pattern, flags) = parsed;
    try {
      final regex = RegExp(
        pattern,
        multiLine: flags.contains('m'),
        caseSensitive: !flags.contains('i'),
        dotAll: flags.contains('s'),
      );
      result = result.replaceAllMapped(regex, (m) {
        var out = replace;
        for (var i = m.groupCount; i >= 1; i--) {
          out = out.replaceAll('\$$i', m.group(i) ?? '');
        }
        return out;
      });
    } catch (_) {
      // Skip this script on a bad regex.
    }
  }
  return result;
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
