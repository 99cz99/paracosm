/// Determines which character speaks next in a group chat.
///
/// Pure logic, unit-testable.
class GroupSpeaker {
  /// Returns the characterId that should speak next, or null when the LLM
  /// should decide (auto mode, or call mode with no @mention).
  static String? determine({
    required String mode,
    required List<({String id, String name, int joinOrder})> members,
    String? lastSpeakerId,
    String? userText,
  }) {
    if (members.isEmpty) return null;
    switch (mode) {
      case 'turn':
        final sorted = [...members]
          ..sort((a, b) => a.joinOrder.compareTo(b.joinOrder));
        if (lastSpeakerId == null) return sorted.first.id;
        final idx = sorted.indexWhere((m) => m.id == lastSpeakerId);
        final next = idx < 0 ? 0 : (idx + 1) % sorted.length;
        return sorted[next].id;
      case 'call':
        return _mentioned(userText, members)?.id;
      case 'auto':
      default:
        return null;
    }
  }

  static ({String id, String name, int joinOrder})? _mentioned(
    String? text,
    List<({String id, String name, int joinOrder})> members,
  ) {
    if (text == null || text.isEmpty) return null;
    for (final m in members) {
      if (m.name.isNotEmpty && text.contains('@${m.name}')) return m;
    }
    return null;
  }
}
