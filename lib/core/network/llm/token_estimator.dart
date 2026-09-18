/// Approximate token counting — the app has no real tokenizer, so this is a
/// rough heuristic (always labelled「估算」in the UI):
/// CJK / full-width / wide glyphs ≈ 1 token, ASCII ≈ 4 chars per token.
int estimateTokens(String text) {
  var tokens = 0.0;
  for (final rune in text.runes) {
    tokens += rune >= 0x2E80 ? 1.0 : 0.25;
  }
  return tokens.ceil();
}
