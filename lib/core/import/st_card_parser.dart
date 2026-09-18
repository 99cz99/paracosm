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
    } on FormatException {
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
    };

    // Default (worldId='') adaptation starts empty — the personality already
    // lives in `core['personality']` and must not be duplicated here. `worldId`
    // is a table column, not a key inside the adaptation JSON.
    final adaptation = <String, dynamic>{'persona': ''};

    Map<String, dynamic>? worldbook;
    if (data['character_book'] is Map<String, dynamic>) {
      worldbook = WorldbookParser()
          .normalize(data['character_book'] as Map<String, dynamic>);
    }

    final tags = data['tags'] is List
        ? List<String>.from((data['tags'] as List).map((e) => e.toString()))
        : <String>[];

    return ImportedCharacter(
      name: name,
      core: core,
      adaptation: adaptation,
      worldbook: worldbook,
      tags: tags,
    );
  }
}
