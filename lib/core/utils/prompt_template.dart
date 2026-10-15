/// Replaces SillyTavern-style placeholders in prompt text with the actual
/// character and user names, so cards using `{{char}}` / `{{user}}` read
/// naturally. Handles the common case variants.
String applyPlaceholders(String text, String charName, String userName) {
  if (text.isEmpty) return text;
  return text
      .replaceAll('{{char}}', charName)
      .replaceAll('{{Char}}', charName)
      .replaceAll('{{CHAR}}', charName)
      .replaceAll('{{user}}', userName)
      .replaceAll('{{User}}', userName)
      .replaceAll('{{USER}}', userName);
}

/// Expands SillyTavern `{{setvar::name::value}}` / `{{getvar::name}}` macros so
/// imported settings-export presets (which stash jailbreak text in variables)
/// actually resolve. Two passes: collect `setvar` into a name→value table and
/// strip the directive (it emits nothing), then replace `getvar` with the
/// stored value. Unknown `getvar` is left untouched. No nesting.
String expandStVariables(String text) {
  if (!text.contains('{{setvar::') && !text.contains('{{getvar::')) {
    return text;
  }
  final vars = <String, String>{};
  final stripped = text.replaceAllMapped(
    RegExp(r'\{\{setvar::([^:]+?)::(.*?)\}\}', dotAll: true),
    (m) {
      vars[m.group(1)!.trim()] = m.group(2)!.trim();
      return '';
    },
  );
  return stripped.replaceAllMapped(
    RegExp(r'\{\{getvar::([^:}]+?)\}\}'),
    (m) => vars[m.group(1)!.trim()] ?? m.group(0)!,
  );
}
