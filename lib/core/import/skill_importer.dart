import 'dart:convert';

import 'package:archive/archive.dart';

import '../utils/app_exception.dart';
import 'imported_character.dart';
import 'st_card_parser.dart';

/// Imports a "Skill" — a folder (zipped) containing a character definition,
/// either as a SillyTavern JSON card or a Markdown file with YAML-ish
/// frontmatter (name/description/personality/scenario/first_mes/tags).
///
/// Also accepts a Claude Code `SKILL.md`: frontmatter with `name` plus a
/// block-scalar `description`, and the character's actual instruction set in
/// the Markdown body (captured as the core `system_prompt`).
class SkillImporter {
  ImportedCharacter importZip(List<int> zipBytes) {
    final archive = ZipDecoder().decodeBytes(zipBytes);
    final affinity = _readAffinity(archive);
    final stateSchema = _readStateSchema(archive);
    final research = readResearchEntries(archive);
    final sources = _readSources(archive);
    final avatar = _readAvatar(archive);
    final images = _readImages(archive);

    // 1. Try any JSON card (skip the affinity/state-schema state files).
    for (final file in archive) {
      if (file.isFile &&
          file.name.toLowerCase().endsWith('.json') &&
          !_isAffinityPath(file.name) &&
          !_isStateSchemaPath(file.name)) {
        try {
          final content = utf8.decode(file.content as List<int>);
          return _withExtras(StCardParser().parse(content), affinity, research,
              sources, stateSchema: stateSchema, avatar: avatar, images: images);
        } catch (_) {
          // keep looking
        }
      }
    }

    // 2. Try Markdown frontmatter. Prefer a root-level `SKILL.md` (Claude
    // Code skill) so that `references/*.md` research files are not mistaken
    // for the character definition.
    final mdFiles = archive
        .where((f) => f.isFile && f.name.toLowerCase().endsWith('.md'))
        .toList()
      ..sort(_compareMarkdownPriority);
    for (final file in mdFiles) {
      final content = utf8.decode(file.content as List<int>);
      final imported = importMarkdown(content);
      if (imported != null) {
        return _withExtras(imported, affinity, research, sources,
            stateSchema: stateSchema, avatar: avatar, images: images);
      }
    }

    throw AppException('ZIP 中未找到角色卡（JSON 或 Markdown 前置元数据）');
  }

  /// Reads the skill's persistent state file, if present. The character's
  /// three-axis system (trust/corruption) seeds from this at chat time.
  Map<String, dynamic>? _readAffinity(Archive archive) {
    for (final file in archive) {
      if (!file.isFile || !_isAffinityPath(file.name)) continue;
      try {
        final decoded = jsonDecode(utf8.decode(file.content as List<int>));
        if (decoded is Map<String, dynamic>) return decoded;
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  static bool _isAffinityPath(String name) =>
      name.replaceAll('\\', '/').toLowerCase() == 'references/affinity.json';

  /// Reads the skill's state field-name map, if present. Used by /status to
  /// label state fields with the author's own names (Chinese or English).
  Map<String, dynamic>? _readStateSchema(Archive archive) {
    for (final file in archive) {
      if (!file.isFile || !_isStateSchemaPath(file.name)) continue;
      try {
        final decoded = jsonDecode(utf8.decode(file.content as List<int>));
        if (decoded is Map<String, dynamic>) return decoded;
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  static bool _isStateSchemaPath(String name) =>
      name.replaceAll('\\', '/').toLowerCase() == 'references/state_schema.json';

  /// Reads a root-level avatar image (`avatar.*` / `role_avatar.*` /
  /// `portrait.*`), if the ZIP carries one.
  List<int>? _readAvatar(Archive archive) {
    const names = {
      'avatar.png', 'avatar.jpg', 'avatar.jpeg',
      'role_avatar.png', 'role_avatar.jpg', 'role_avatar.jpeg',
      'portrait.png', 'portrait.jpg', 'portrait.jpeg',
    };
    for (final file in archive) {
      if (!file.isFile) continue;
      final base =
          file.name.replaceAll('\\', '/').split('/').last.toLowerCase();
      if (names.contains(base)) return file.content as List<int>;
    }
    return null;
  }

  /// Reads non-research image files as the character's sendable gallery
  /// (filename without extension becomes the trigger name).
  List<ImportedImage> _readImages(Archive archive) {
    final images = <ImportedImage>[];
    for (final file in archive) {
      if (!file.isFile) continue;
      final name = file.name.replaceAll('\\', '/');
      final lower = name.toLowerCase();
      if (lower.startsWith('references/')) continue;
      if (!lower.endsWith('.png') &&
          !lower.endsWith('.jpg') &&
          !lower.endsWith('.jpeg') &&
          !lower.endsWith('.webp')) {
        continue;
      }
      final stem = name.split('/').last.replaceFirst(
          RegExp(r'\.(png|jpg|jpeg|webp)$', caseSensitive: false), '');
      if (stem.isEmpty) continue;
      images.add(ImportedImage(name: stem, bytes: file.content as List<int>));
    }
    return images;
  }

  ImportedCharacter _withExtras(
    ImportedCharacter c,
    Map<String, dynamic>? affinity,
    List<Map<String, dynamic>> research,
    List<Map<String, dynamic>> sources, {
    Map<String, dynamic>? stateSchema,
    List<int>? avatar,
    List<ImportedImage> images = const [],
  }) {
    final hasAffinity = affinity != null && affinity.isNotEmpty;
    final hasResearch = research.isNotEmpty;
    final hasSources = sources.isNotEmpty;
    final hasStateSchema = stateSchema != null && stateSchema.isNotEmpty;
    if (!hasAffinity && !hasResearch && !hasSources && !hasStateSchema) return c;

    Map<String, dynamic>? worldbook = c.worldbook;
    if (hasResearch || hasSources) {
      worldbook = Map<String, dynamic>.from(worldbook ?? <String, dynamic>{});
      if (hasResearch) {
        final existing = worldbook['entries'];
        worldbook['entries'] = <dynamic>[
          ...(existing is List ? existing : const <dynamic>[]),
          ...research,
        ];
      }
      if (hasSources) {
        final existing = worldbook['sources'];
        worldbook['sources'] = <dynamic>[
          ...(existing is List ? existing : const <dynamic>[]),
          ...sources,
        ];
      }
    }

    return ImportedCharacter(
      name: c.name,
      core: c.core,
      adaptation: c.adaptation,
      worldbook: worldbook,
      tags: c.tags,
      sourcePath: c.sourcePath,
      affinity: hasAffinity ? affinity : null,
      stateSchema: hasStateSchema ? stateSchema : null,
      avatarBytes: avatar ?? c.avatarBytes,
      gallery: [...c.gallery, ...images],
      regexScripts: c.regexScripts,
    );
  }

  /// Reads the skill's original game-text sources (`references/sources/**`) as
  /// {name, content} pairs. Display-only (too large to inject) — stored under
  /// `worldbook.sources`, kept apart from the keyword-triggered `entries`.
  List<Map<String, dynamic>> _readSources(Archive archive) {
    final sources = <Map<String, dynamic>>[];
    for (final file in archive) {
      if (!file.isFile) continue;
      final name = file.name.replaceAll('\\', '/');
      final lower = name.toLowerCase();
      if (!lower.startsWith('references/sources/')) continue;
      if (!lower.endsWith('.txt') && !lower.endsWith('.md')) continue;
      final content = utf8.decode(file.content as List<int>);
      if (content.trim().isEmpty) continue;
      final rel = name.replaceFirst(RegExp(r'^references/sources/'), '');
      sources.add({'name': rel, 'content': content});
    }
    return sources;
  }

  /// Reads the skill's research notes (`references/research/*.md` and
  /// `references/quality-validation.md`) into worldbook-style entries so they
  /// can be injected on keyword match — the game-text sources are skipped
  /// (far too large to inject).
  List<Map<String, dynamic>> readResearchEntries(Archive archive) {
    final entries = <Map<String, dynamic>>[];
    for (final file in archive) {
      if (!file.isFile) continue;
      final name = file.name.replaceAll('\\', '/');
      final lower = name.toLowerCase();
      if (!lower.endsWith('.md')) continue;
      if (lower == 'skill.md') continue;
      final isResearch = lower.startsWith('references/research/');
      final isValidation = lower == 'references/quality-validation.md';
      if (!isResearch && !isValidation) continue;

      final content = utf8.decode(file.content as List<int>);
      if (content.trim().isEmpty) continue;
      entries.add(researchEntry(name, content));
    }
    return entries;
  }

  Map<String, dynamic> researchEntry(String path, String content) {
    final keys = <String>{};
    final slug = _slug(path);
    if (slug.isNotEmpty) keys.add(slug);
    final heading = _firstHeading(content);
    if (heading != null && heading.isNotEmpty) keys.add(heading);
    return {
      'keys': keys.toList(),
      'content': content,
      'enabled': true,
      'constant': false,
    };
  }

  String _slug(String path) {
    final base = path.split('/').last;
    final noExt = base.replaceAll(RegExp(r'\.md$', caseSensitive: false), '');
    return noExt.replaceFirst(RegExp(r'^\d+[-_ ]?'), '');
  }

  String? _firstHeading(String content) {
    final m = RegExp(r'^#+\s+(.+)$', multiLine: true).firstMatch(content);
    return m?.group(1)?.trim();
  }

  static int _compareMarkdownPriority(ArchiveFile a, ArchiveFile b) {
    int score(ArchiveFile f) {
      final name = f.name.toLowerCase();
      if (name.split('/').last == 'skill.md') return 0;
      if (!name.contains('/')) return 1;
      return 2;
    }

    return score(a).compareTo(score(b));
  }

  ImportedCharacter? importMarkdown(String md) {
    final parsed = _parseFrontmatter(md);
    if (parsed == null) return null;
    final fm = parsed.frontmatter;
    final name = (fm['name'] ?? '').trim();
    if (name.isEmpty) return null;

    // For Claude Code-style skills the character definition lives in the
    // Markdown body rather than in frontmatter; capture it as the core
    // system prompt so it actually shapes the character's behaviour.
    final body = parsed.body.trim();
    final systemPrompt = body.isNotEmpty ? body : (fm['system_prompt'] ?? '');

    final core = <String, dynamic>{
      'description': fm['description'] ?? '',
      'personality': fm['personality'] ?? '',
      'scenario': fm['scenario'] ?? '',
      'first_mes': fm['first_mes'] ?? '',
      'mes_example': fm['mes_example'] ?? '',
      'system_prompt': systemPrompt,
      'creator_notes': '',
      'nickname': '',
      'alternate_greetings': <dynamic>[],
    };
    final adaptation = <String, dynamic>{'persona': ''};
    return ImportedCharacter(
      name: name,
      core: core,
      adaptation: adaptation,
      tags: _parseTags(fm['tags']),
    );
  }

  _ParsedMarkdown? _parseFrontmatter(String md) {
    // Normalise CRLF so Windows-authored Markdown parses like LF.
    final trimmed = md.replaceAll('\r\n', '\n').trimLeft();
    if (!trimmed.startsWith('---')) return null;

    // `afterOpen` starts right after the opening `---` (leading `\n` kept).
    final afterOpen = trimmed.substring(3);
    final close = RegExp(r'\n---[ \t]*\r?\n').firstMatch(afterOpen);
    final String block;
    final String body;
    if (close == null) {
      block = afterOpen;
      body = '';
    } else {
      block = afterOpen.substring(0, close.start);
      body = afterOpen.substring(close.end);
    }

    final map = _parseYamlish(block);
    if (map.isEmpty) return null;
    return _ParsedMarkdown(map, body);
  }

  Map<String, String> _parseYamlish(String block) {
    final lines = block.split('\n');
    final map = <String, String>{};
    var i = 0;
    while (i < lines.length) {
      final line = lines[i];
      final idx = line.indexOf(':');
      if (idx <= 0) {
        i++;
        continue;
      }
      final key = line.substring(0, idx).trim();
      final value = line.substring(idx + 1).trim();
      if (value == '|' || value == '>') {
        // YAML block scalar: consume subsequent indented (or blank) lines.
        final collected = <String>[];
        var j = i + 1;
        while (j < lines.length) {
          final l = lines[j];
          if (l.trim().isEmpty) {
            collected.add('');
            j++;
            continue;
          }
          if (l.startsWith(' ') || l.startsWith('\t')) {
            collected.add(l);
            j++;
            continue;
          }
          break;
        }
        final content = _dedent(collected);
        map[key] = value == '|' ? content.join('\n') : content.join(' ');
        i = j;
      } else {
        map[key] = _unquote(value);
        i++;
      }
    }
    return map;
  }

  List<String> _dedent(List<String> lines) {
    var minIndent = -1;
    for (final line in lines) {
      if (line.trim().isEmpty) continue;
      var count = 0;
      while (count < line.length && line[count] == ' ') {
        count++;
      }
      if (minIndent < 0 || count < minIndent) minIndent = count;
    }
    if (minIndent <= 0) return lines;
    return lines.map((line) {
      if (line.trim().isEmpty) return '';
      return line.length >= minIndent ? line.substring(minIndent) : line.trimLeft();
    }).toList();
  }

  String _unquote(String value) {
    if (value.length >= 2) {
      final first = value[0];
      final last = value[value.length - 1];
      if ((first == '"' && last == '"') || (first == "'" && last == "'")) {
        return value.substring(1, value.length - 1);
      }
    }
    return value;
  }

  List<String> _parseTags(String? raw) {
    if (raw == null || raw.trim().isEmpty) return [];
    if (raw.startsWith('[') && raw.endsWith(']')) {
      return raw
          .substring(1, raw.length - 1)
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }
    return [raw.trim()];
  }
}

class _ParsedMarkdown {
  _ParsedMarkdown(this.frontmatter, this.body);

  final Map<String, String> frontmatter;
  final String body;
}
