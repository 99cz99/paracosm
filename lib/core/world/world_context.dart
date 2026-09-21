import 'dart:convert';
import 'dart:math';

import '../db/database.dart';

/// Pure keyword-matching over a single worldbook JSON, extracted from
/// `MemoryService.triggeredWorldbook` so single chat, group chat and story all
/// share the one matching logic.
///
/// Honors the rich SillyTavern entry fields (regex / case-sensitivity /
/// secondary keys / selective AND / whole-word / recursion / priority) that
/// [WorldbookParser] already preserves, so imported books trigger correctly.
class WorldbookMatcher {
  /// Returns the `content` of every matching entry, with `{{random:a|b}}`
  /// expanded. Pure matching, no LLM.
  static List<String> triggered(String? bookJson, String context,
      {Random? random}) {
    final rng = random ?? Random();
    return [
      for (final e in matchedEntries(bookJson, context))
        _expandRandom(e['content']?.toString() ?? '', rng),
    ];
  }

  /// Returns the matching entry maps (`comment`/`keys`/`content`/…), honoring
  /// `enabled`/`constant` and the rich fields exactly like runtime injection,
  /// so the detail/edit pages can preview which entries a snippet triggers.
  static List<Map<String, dynamic>> matchedEntries(
      String? bookJson, String context) {
    if (bookJson == null || bookJson.isEmpty) return const [];
    final Map<String, dynamic> book;
    try {
      book = jsonDecode(bookJson) as Map<String, dynamic>;
    } catch (_) {
      return const [];
    }
    final rawEntries = book['entries'];
    if (rawEntries is! List) return const [];
    final entries = <Map<String, dynamic>>[
      for (final e in rawEntries)
        if (e is Map) Map<String, dynamic>.from(e),
    ];

    final matched = <Map<String, dynamic>>[];
    final seen = <String>{};

    void addIfNew(Map<String, dynamic> e, List<Map<String, dynamic>> queue) {
      final key = '${e['comment'] ?? ''}\u0000${e['content'] ?? ''}';
      if (!seen.add(key)) return;
      matched.add(e);
      queue.add(e);
    }

    // 1. Direct matches against the recent context.
    final frontier = <Map<String, dynamic>>[];
    for (final e in entries) {
      if (_entryMatches(e, context)) addIfNew(e, frontier);
    }

    // 2. Recursive scanning: a matched entry's content re-triggers other
    //    entries, bounded by the book's `scan_depth`.
    if (book['recursive_scanning'] == true) {
      final maxDepth = _toInt(book['scan_depth'], 2);
      var depth = 0;
      var current = frontier;
      while (current.isNotEmpty && depth < maxDepth) {
        final next = <Map<String, dynamic>>[];
        for (final e in current) {
          if (e['exclude_recursion'] == true) continue;
          final content = e['content']?.toString() ?? '';
          if (content.isEmpty) continue;
          for (final other in entries) {
            if (_entryMatches(other, content)) addIfNew(other, next);
          }
        }
        current = next;
        depth++;
      }
    }

    // 3. Stable ordering by priority (desc) then insertion_order (asc).
    matched.sort(_compareEntries);
    return matched;
  }

  static bool _entryMatches(Map<String, dynamic> e, String context) {
    final enabled = e['enabled'] != false;
    final content = e['content']?.toString() ?? '';
    if (!enabled || content.isEmpty) return false;
    if (e['constant'] == true) return true;

    final useRegex = e['use_regex'] == true;
    final caseSensitive = e['case_sensitive'] == true;
    final wholeWords = e['match_whole_words'] == true;
    final selective = e['selective'] == true;
    final keys = _strList(e['keys']);
    final secondary = _strList(e['secondary_keys']);
    if (keys.isEmpty && secondary.isEmpty) return false;

    bool hit(String k) =>
        _keyMatches(k, context, useRegex, caseSensitive, wholeWords);

    if (selective) return keys.every(hit) && secondary.every(hit);
    return keys.any(hit) || secondary.any(hit);
  }

  static bool _keyMatches(String key, String text, bool useRegex,
      bool caseSensitive, bool wholeWords) {
    if (key.isEmpty) return false;
    if (useRegex) {
      try {
        return RegExp(key, caseSensitive: caseSensitive).hasMatch(text);
      } catch (_) {
        return false;
      }
    }
    final hay = caseSensitive ? text : text.toLowerCase();
    final needle = caseSensitive ? key : key.toLowerCase();
    if (wholeWords) {
      return RegExp(r'(?<![A-Za-z0-9_])' + RegExp.escape(needle) +
              r'(?![A-Za-z0-9_])')
          .hasMatch(hay);
    }
    return hay.contains(needle);
  }

  static List<String> _strList(dynamic v) =>
      v is List ? [for (final k in v) k.toString()] : <String>[];

  static int _toInt(dynamic v, int fallback) {
    if (v is num) return v.toInt();
    return int.tryParse(v?.toString() ?? '') ?? fallback;
  }

  static int _compareEntries(
      Map<String, dynamic> a, Map<String, dynamic> b) {
    final pa = _toInt(a['priority'], 0);
    final pb = _toInt(b['priority'], 0);
    if (pa != pb) return pb.compareTo(pa); // higher priority first
    return _toInt(a['insertion_order'], 0)
        .compareTo(_toInt(b['insertion_order'], 0));
  }

  static String _expandRandom(String content, Random random) {
    return content.replaceAllMapped(
      RegExp(r'\{\{random:([^}]*)\}\}'),
      (m) {
        final options =
            m.group(1)!.split('|').where((s) => s.isNotEmpty).toList();
        if (options.isEmpty) return '';
        return options[random.nextInt(options.length)];
      },
    );
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
  List<String> matchedEntries(String recentContext, {Random? random}) {
    final out = <String>[];
    for (final book in worldbooks) {
      out.addAll(
          WorldbookMatcher.triggered(book.bookJson, recentContext, random: random));
    }
    return out;
  }

  /// Union of keyword hits across all bound worldbooks, as one【世界书】block.
  String buildWorldbookSection(String recentContext, {Random? random}) {
    final out = matchedEntries(recentContext, random: random);
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
