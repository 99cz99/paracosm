import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/db/database.dart';
import '../../../core/import/worldbook_importer.dart';

/// Persists standalone worldbooks into the library.
class WorldbookRepository {
  WorldbookRepository(this._db);

  final AppDatabase _db;
  static final _uuid = const Uuid();

  /// Imports a worldbook from raw file bytes. Dispatches on [filename]:
  /// JSON, Markdown, or ZIP (research notes).
  Future<String> importFromBytes(
    List<int> bytes, {
    String? sourcePath,
    String? filename,
  }) async {
    final draft = _parse(bytes, filename);
    final now = DateTime.now().millisecondsSinceEpoch;
    final id = _uuid.v4();
    await _db.insertWorldbook(WorldbooksCompanion.insert(
      id: id,
      name: draft.name,
      description: Value(draft.description),
      bookJson: Value(jsonEncode(draft.bookJson)),
      sourceType: Value(draft.sourceType),
      sourcePath: Value(draft.sourcePath),
      createdAt: now,
      updatedAt: now,
    ));
    return id;
  }

  /// Imports a worldbook from pasted JSON text.
  Future<String> importFromJson(String jsonText) =>
      importFromBytes(utf8.encode(jsonText));

  WorldbookDraft _parse(List<int> bytes, String? filename) {
    final name = (filename ?? '').toLowerCase();
    final base = _baseName(filename);
    if (name.endsWith('.json')) {
      return WorldbookImporter().parseJson(utf8.decode(bytes));
    }
    if (name.endsWith('.md')) {
      return WorldbookImporter().parseMarkdown(utf8.decode(bytes), name: base);
    }
    if (name.endsWith('.zip')) {
      return WorldbookImporter().parseZip(bytes, name: base);
    }
    // No extension: assume JSON.
    return WorldbookImporter().parseJson(utf8.decode(bytes));
  }

  String _baseName(String? filename) {
    final name = (filename ?? '').split(RegExp(r'[/\\]')).last;
    final noExt =
        name.replaceAll(RegExp(r'\.(json|md|zip)$', caseSensitive: false), '');
    return noExt.isEmpty ? '世界书' : noExt;
  }
}
