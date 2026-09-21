import 'dart:math';

/// Pure rule-evaluation for group auto-speak: filters the group's rules down to
/// those that should fire for [context], honoring `enabled` + `probability` and
/// matching `pattern` as a regex. Unit-testable — no LLM / timers here.
class AutoSpeakRules {
  static List<Map<String, dynamic>> evaluate(
    List<Map<String, dynamic>> rules,
    String context,
    Random random,
  ) {
    final out = <Map<String, dynamic>>[];
    for (final r in rules) {
      if (r['enabled'] == false) continue;
      final pattern = r['pattern']?.toString() ?? '';
      if (pattern.isEmpty) continue;
      var probability = _toDouble(r['probability'], 100);
      if (probability > 100) probability = 100;
      if (probability < 0) probability = 0;
      if (probability < 100 && random.nextDouble() * 100 >= probability) {
        continue;
      }
      try {
        if (RegExp(pattern).hasMatch(context)) out.add(r);
      } catch (_) {
        // Invalid regex — skip silently.
      }
    }
    return out;
  }

  static double _toDouble(dynamic v, double fallback) {
    if (v is num) return v.toDouble();
    return double.tryParse(v?.toString() ?? '') ?? fallback;
  }
}
