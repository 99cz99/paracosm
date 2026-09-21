import 'dart:convert';

import '../utils/app_exception.dart';
import 'imported_character.dart';
import 'worldbook_parser.dart';

/// Parses a SillyTavern character card (V1 / V2 / V3 JSON) into the unified
/// [ImportedCharacter] model.
class StCardParser {
  ImportedCharacter parse(String rawJson) {
    final Object? decoded;
    try {
      decoded = jsonDecode(rawJson);
    } catch (_) {
      // Non-standard cards may carry BOM, trailing garbage or invalid escapes;
      // surface one consistent error instead of leaking the FormatException.
      throw AppException('角色卡 JSON 解析失败');
    }
    if (decoded is! Map<String, dynamic>) {
      throw AppException('角色卡格式无效：不是 JSON 对象');
    }
    return parseMap(decoded);
  }

  ImportedCharacter parseMap(Map<String, dynamic> root) {
    // V2/V3 wrap fields under `data`; V1 is flat.
    final data = root['data'] is Map<String, dynamic>
        ? root['data'] as Map<String, dynamic>
        : root;

    final name = (data['name'] ?? '').toString().trim();
    if (name.isEmpty) {
      throw AppException('角色卡缺少 name 字段');
    }

    final core = <String, dynamic>{
      'description': (data['description'] ?? '').toString(),
      'personality': (data['personality'] ?? '').toString(),
      'scenario': (data['scenario'] ?? '').toString(),
      'first_mes': (data['first_mes'] ?? '').toString(),
      'mes_example': (data['mes_example'] ?? '').toString(),
      'system_prompt': (data['system_prompt'] ?? '').toString(),
      'post_history_instructions':
          (data['post_history_instructions'] ?? '').toString(),
      'creator_notes': (data['creator_notes'] ?? '').toString(),
      'nickname': (data['nickname'] ?? '').toString(),
      'alternate_greetings': data['alternate_greetings'] is List
          ? List<dynamic>.from(data['alternate_greetings'] as List)
          : <dynamic>[],
      // Standard SillyTavern fields that would otherwise be dropped on re-import
      // (kept so a round-trip via the exporter doesn't lose them).
      'creator': (data['creator'] ?? '').toString(),
      'character_version': (data['character_version'] ?? '').toString(),
      'group_only_greetings': data['group_only_greetings'] is List
          ? List<dynamic>.from(data['group_only_greetings'] as List)
          : <dynamic>[],
    };

    // Default (worldId='') adaptation starts empty — the personality already
    // lives in `core['personality']` and must not be duplicated here. `worldId`
    // is a table column, not a key inside the adaptation JSON.
    final adaptation = <String, dynamic>{'persona': ''};

    // The built-in world book is emitted as `character_book` (SillyTavern) but
    // the assistant and some tools use `worldbook` / `world_book` — accept all.
    final bookRaw =
        data['character_book'] ?? data['worldbook'] ?? data['world_book'];
    Map<String, dynamic>? worldbook;
    if (bookRaw is Map<String, dynamic>) {
      worldbook = WorldbookParser().normalize(bookRaw);
    }

    // Skill growth seed + state field-name map ride on the card as top-level
    // fields (assistant / skill cards); persist them under core-reserved keys.
    final affinityRaw = data['affinity'];
    final affinity = affinityRaw is Map && affinityRaw.isNotEmpty
        ? Map<String, dynamic>.from(affinityRaw)
        : null;
    final stateSchemaRaw = data['state_schema'];
    final stateSchema = stateSchemaRaw is Map && stateSchemaRaw.isNotEmpty
        ? Map<String, dynamic>.from(stateSchemaRaw)
        : null;

    final tags = data['tags'] is List
        ? List<String>.from((data['tags'] as List).map((e) => e.toString()))
        : <String>[];

    // V3 `assets` array (top-level, beside `data`): `icon` → avatar,
    // `emotion`/`background` → gallery of sendable images.
    List<int>? avatarBytes;
    final gallery = <ImportedImage>[];
    final regexScripts = <Map<String, dynamic>>[];
    final assets = root['assets'];
    if (assets is List) {
      for (final a in assets) {
        if (a is! Map) continue;
        final bytes = _dataUriBytes(a['uri']?.toString() ?? '');
        if (bytes == null) continue;
        final type = a['type']?.toString() ?? '';
        final assetName = (a['name']?.toString() ?? '').trim();
        if (type == 'icon') {
          avatarBytes ??= bytes;
        } else if (type == 'emotion' || type == 'background') {
          if (assetName.isNotEmpty) {
            gallery.add(ImportedImage(name: assetName, bytes: bytes));
          }
        }
      }
    }
    // Chub.ai / risuai: embedded images under `extensions`.
    final ext = data['extensions'];
    if (ext is Map) {
      final risuai = ext['risuai'];
      if (risuai is Map && risuai['additionalAssets'] is List) {
        for (final a in risuai['additionalAssets'] as List) {
          if (a is! List || a.length < 2) continue;
          final name = a[0]?.toString().trim() ?? '';
          final bytes = _tryBase64(a[1]?.toString() ?? '');
          if (name.isNotEmpty && bytes != null) {
            gallery.add(ImportedImage(name: name, bytes: bytes));
          }
        }
      }
      final chub = ext['chub'];
      if (chub is Map && chub['expressions'] is Map) {
        (chub['expressions'] as Map).forEach((k, v) {
          final name = k.toString().trim();
          if (name.isEmpty) return;
          final bytes = v is String
              ? _tryBase64(v)
              : (v is Map ? _tryBase64(v['image']?.toString() ?? '') : null);
          if (bytes != null) {
            gallery.add(ImportedImage(name: name, bytes: bytes));
          }
        });
      }
      final scripts = ext['regex_scripts'];
      if (scripts is List) {
        for (final s in scripts) {
          if (s is! Map) continue;
          if (s['disabled'] == true) continue;
          if (s['markdownOnly'] != true) continue;
          regexScripts.add(Map<String, dynamic>.from(s));
        }
      }
    }
    // Fallback: base64 `image` field (V2 / tool-exported cards).
    if (avatarBytes == null) {
      final imageRaw = data['image'];
      if (imageRaw is String && imageRaw.isNotEmpty) {
        try {
          avatarBytes = base64.decode(imageRaw);
        } catch (_) {}
      }
    }

    return ImportedCharacter(
      name: name,
      core: core,
      adaptation: adaptation,
      worldbook: worldbook,
      tags: tags,
      affinity: affinity,
      stateSchema: stateSchema,
      avatarBytes: avatarBytes,
      gallery: gallery,
      regexScripts: regexScripts,
    );
  }

  static List<int>? _dataUriBytes(String uri) {
    if (!uri.startsWith('data:')) return null;
    final comma = uri.indexOf(',');
    if (comma < 0) return null;
    try {
      return base64.decode(uri.substring(comma + 1));
    } catch (_) {
      return null;
    }
  }

  static List<int>? _tryBase64(String s) {
    try {
      return base64.decode(s);
    } catch (_) {
      return null;
    }
  }
}
