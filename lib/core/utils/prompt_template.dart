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
