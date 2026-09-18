import 'dart:convert';

import 'package:archive/archive.dart';

import '../utils/app_exception.dart';
import 'skill_importer.dart';
import 'worldbook_parser.dart';

/// A parsed standalone worldbook before it is persisted to the library.
class WorldbookDraft {
  WorldbookDraft({
    required this.name,
    required this.description,
    required this.bookJson,
    required this.sourceType,
    this.sourcePath,
  });

  final String name;
  final String description;
  final Map<String, dynamic> bookJson;
  final String sourceType;
  final String? sourcePath;
}

/// Imports a standalone worldbook from a SillyTavern JSON lorebook, a single
/// Markdown file, or a ZIP of research Markdown (reusing [SkillImporter]).
class WorldbookImporter {
  /// Parses a SillyTavern worldbook JSON. Accepts a bare `{entries: ...}` book,
  /// a `world_book` / `character_book` wrapper, or a V2/V3 `data` envelope.
  WorldbookDraft parseJson(String rawJson) {
    final Object? decoded;
    try {
      decoded = jsonDecode(rawJson);
    } on FormatException {
      throw AppException('世界书 JSON 解析失败');
    }
    if (decoded is! Map<String, dynamic>) {
      throw AppException('世界书格式无效：不是 JSON 对象');
    }

    final data = decoded['data'] is Map<String, dynamic>
        ? decoded['data'] as Map<String, dynamic>
        : decoded;

    Map<String, dynamic>? book;
    if (data['world_book'] is Map<String, dynamic>) {
      book = data['world_book'] as Map<String, dynamic>;
    } else if (data['character_book'] is Map<String, dynamic>) {
      book = data['character_book'] as Map<String, dynamic>;
    } else if (data['entries'] is List || data['entries'] is Map) {
      book = data;
    }

    if (book == null) {
      throw AppException('未找到世界书条目（world_book / character_book / entries）');
    }

    final normalized = WorldbookParser().normalize(book);
    final rawName = normalized['name']?.toString().trim() ?? '';
    return WorldbookDraft(
      name: rawName.isNotEmpty ? rawName : '世界书',
      description: (normalized['description']?.toString() ?? '').trim(),
      bookJson: normalized,
      sourceType: 'sillytavern',
    );
  }

  /// Builds a worldbook from a single Markdown file (one entry keyed by the
  /// filename slug + first heading).
  WorldbookDraft parseMarkdown(String md, {String name = '世界书'}) {
    final content = md.trim();
    if (content.isEmpty) throw AppException('Markdown 内容为空');
    final entry = SkillImporter().researchEntry(name, content);
    return WorldbookDraft(
      name: name,
      description: '',
      bookJson: <String, dynamic>{
        'name': name,
        'description': '',
        'entries': [entry],
      },
      sourceType: 'skill',
    );
  }

  /// Builds a worldbook from a ZIP of research Markdown files.
  WorldbookDraft parseZip(List<int> zipBytes, {String name = '世界书'}) {
    final archive = ZipDecoder().decodeBytes(zipBytes);
    final entries = SkillImporter().readResearchEntries(archive);
    if (entries.isEmpty) {
      throw AppException('ZIP 中未找到世界书条目（references/research/*.md）');
    }
    return WorldbookDraft(
      name: name,
      description: '',
      bookJson: <String, dynamic>{
        'name': name,
        'description': '',
        'entries': entries,
      },
      sourceType: 'skill',
    );
  }
}
