import 'dart:convert';

import '../db/database.dart';

/// Pure keyword-matching over a single worldbook JSON, extracted from
/// `MemoryService.triggeredWorldbook` so single chat, group chat and story all
/// share the one matching logic.
class WorldbookMatcher {
  /// Returns the `content` of every enabled entry whose `keys` match [context]
  /// (or that is `constant`). Pure string matching, no LLM.
  static List<String> triggered(String? bookJson, String context) {
    if (bookJson == null || bookJson.isEmpty) return const [];
    final Map<String, dynamic> book;
    try {
      book = jsonDecode(bookJson) as Map<String, dynamic>;
    } catch (_) {
      return const [];
    }
    final entries = book['entries'];
    if (entries is! List) return const [];

    final out = <String>[];
    for (final e in entries) {
      if (e is! Map) continue;
      final content = e['content']?.toString() ?? '';
      final enabled = e['enabled'] != false;
      if (!enabled || content.isEmpty) continue;
      final constant = e['constant'] == true;
      final keys = e['keys'] is List
          ? List<String>.from((e['keys'] as List).map((k) => k.toString()))
          : <String>[];
      if (constant || _containsAny(context, keys)) {
        out.add(content);
      }
    }
    return out;
  }

  static bool _containsAny(String text, List<String> keys) {
    for (final k in keys) {
      if (k.isNotEmpty && text.contains(k)) return true;
    }
    return false;
  }
}

/// Resolved world + worldbook context for a single turn.
class WorldContext {
  WorldContext({required this.worlds, required this.worldbooks});

  final List<World> worlds;
  final List<Worldbook> worldbooks;

  /// One【世界】/【世界规则】/【初始状态】block per world, matching the
  /// single-chat prompt's existing wording.
  String buildWorldSection() {
    final parts = <String>[];
    for (final world in worlds) {
      final desc = (world.description ?? '').trim();
      if (desc.isNotEmpty) parts.add('【世界】${world.name}\n$desc');
      final rules = _jsonText(world.rulesJson);
      if (rules.isNotEmpty) parts.add('【世界规则】\n$rules');
      final initialState = _jsonText(world.initialStateJson);
      if (initialState.isNotEmpty) parts.add('【初始状态】\n$initialState');
    }
    return parts.join('\n\n');
  }

  /// Raw union of keyword hits across all bound worldbooks (no section header).
  List<String> matchedEntries(String recentContext) {
    final out = <String>[];
    for (final book in worldbooks) {
      out.addAll(WorldbookMatcher.triggered(book.bookJson, recentContext));
    }
    return out;
  }

  /// Union of keyword hits across all bound worldbooks, as one【世界书】block.
  String buildWorldbookSection(String recentContext) {
    final out = matchedEntries(recentContext);
    if (out.isEmpty) return '';
    return '【世界书】\n${out.join('\n\n')}';
  }

  static String _jsonText(String json) {
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return (map['text'] ?? '').toString().trim();
    } catch (_) {
      return '';
    }
  }
}

/// Assembles the world + worldbook context for one request. Worldbooks bound
/// directly to the entity are merged with those bound to each of its worlds
/// (so a world's lorebook auto-applies on entering it).
class WorldContextBuilder {
  WorldContextBuilder(this._db);

  final AppDatabase _db;

  Future<WorldContext> build({
    required List<String> worldIds,
    required Set<String> worldbookIds,
  }) async {
    final wids = worldIds.where((id) => id.isNotEmpty).toSet();
    final allBooks = <String>{...worldbookIds};
    for (final wid in wids) {
      allBooks.addAll(await _db.getWorldWorldbookIds(wid));
    }
    return WorldContext(
      worlds: await _db.getWorldsByIds(wids),
      worldbooks: await _db.getWorldbooksByIds(allBooks),
    );
  }
}
