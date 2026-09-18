import 'dart:convert';

import '../db/database.dart';

/// A slash-command definition. Adding a new command = adding one entry below
/// plus a branch in [executeCommand].
class SlashCommand {
  const SlashCommand({
    required this.name,
    required this.category,
    required this.description,
    required this.usage,
    this.params = const [],
    this.detail = '',
  });

  final String name; // e.g. 'status'
  final String category; // 状态 / 记忆 / 世界书 / 群聊 / 系统
  final String description; // one-line summary
  final String usage; // e.g. '/status'
  final List<String> params; // parameter hints (for the popup)
  final String detail; // detailed help (for /help <name>)
}

/// Canonical category order for /help grouping. Unknown categories append.
const _categoryOrder = ['状态', '记忆', '世界书', '群聊', '系统'];

const allSlashCommands = <SlashCommand>[
  SlashCommand(
    name: 'status',
    category: '状态',
    description: '查看当前状态',
    usage: '/status',
    detail: '显示当前会话的结构化状态（scene / facts / items / npcs 等字段，空值不显示）。',
  ),
  SlashCommand(
    name: 'relation',
    category: '状态',
    description: '查看关系',
    usage: '/relation [角色名]',
    params: ['角色名'],
    detail: '显示当前会话角色对你的关系（好感 / 信任 / 亲密 / 备注；skill 角色显示信任 / 堕落数值）。',
  ),
  SlashCommand(
    name: 'summary',
    category: '记忆',
    description: '查看摘要',
    usage: '/summary',
    detail: '显示当前会话的滚动摘要（历史对话压缩）。',
  ),
  SlashCommand(
    name: 'lore',
    category: '世界书',
    description: '查看世界书',
    usage: '/lore',
    detail: '列出所有可用的世界书条目（角色级 + 世界级），只读。',
  ),
  SlashCommand(
    name: 'help',
    category: '系统',
    description: '查看指令帮助',
    usage: '/help [指令名]',
    params: ['指令名'],
    detail: '不带参数：显示所有可用指令，按分类组织。\n'
        '带参数：显示指定指令的详细说明，如 /help status。',
  ),
];

SlashCommand? findCommand(String name) {
  for (final c in allSlashCommands) {
    if (c.name == name) return c;
  }
  return null;
}

/// Builds the /help reply text.
String helpText([String? commandName]) {
  final name = commandName?.trim();
  if (name != null && name.isNotEmpty) {
    final cmd = findCommand(name);
    if (cmd == null) {
      return '未知指令：/$name\n输入 /help 查看所有可用指令。';
    }
    final paramsLine = cmd.params.isEmpty ? '' : '\n参数：${cmd.params.join('、')}';
    return '【/${cmd.name}】${cmd.category}\n'
        '${cmd.description}\n'
        '用法：${cmd.usage}$paramsLine\n\n'
        '${cmd.detail}';
  }

  // Group by category, keep canonical order, hide empty categories.
  final byCategory = <String, List<SlashCommand>>{};
  for (final c in allSlashCommands) {
    byCategory.putIfAbsent(c.category, () => []).add(c);
  }
  final orderedCategories = byCategory.keys.toList()
    ..sort((a, b) {
      final ia = _categoryOrder.indexOf(a);
      final ib = _categoryOrder.indexOf(b);
      final ra = ia < 0 ? _categoryOrder.length : ia;
      final rb = ib < 0 ? _categoryOrder.length : ib;
      return ra.compareTo(rb);
    });

  final buffer = StringBuffer('可用指令：\n');
  for (final cat in orderedCategories) {
    buffer.writeln('【$cat】');
    for (final c in byCategory[cat]!) {
      buffer.writeln('  ${c.usage.padRight(16)} ${c.description}');
    }
  }
  buffer.write('输入 /help 指令名 查看详情');
  return buffer.toString().trimRight();
}

/// Builds the /status reply text: structured state only. Relation lives in
/// /relation and the narrative summary in /summary.
Future<String> statusText(AppDatabase db, Session session) async {
  final character = await db.getCharacter(session.characterId);
  final worldId = session.worldId ?? '';
  if (character == null) return '【当前状态】\n暂无状态信息';

  final memory = await db.getCharacterMemory(character.id, worldId);
  final stateStr = memory?.stateJson ?? '';
  final stateSchema = _readStateSchema(character);

  final stateLines = _formatState(stateStr, stateSchema);
  return '【当前状态】\n${stateLines.isEmpty ? '暂无状态信息' : stateLines}';
}

/// Builds the /relation reply text for the session's character, optionally
/// filtered by a character name argument.
Future<String> _relationCommand(
  AppDatabase db,
  Session session,
  String? nameArg,
) async {
  final character = await db.getCharacter(session.characterId);
  if (character == null) return '暂无关系信息';

  final name = nameArg?.trim();
  if (name != null && name.isNotEmpty && name != character.name) {
    return '角色「$name」不存在，当前在场：${character.name}';
  }

  final text = await _relationText(db, character, session.worldId ?? '');
  return '【关系】\n${text.isEmpty ? '暂无关系信息' : text}';
}

/// Builds the /summary reply text from the rolling summary.
Future<String> _summaryCommand(AppDatabase db, Session session) async {
  final character = await db.getCharacter(session.characterId);
  if (character == null) return '暂无摘要';

  final memory =
      await db.getCharacterMemory(character.id, session.worldId ?? '');
  final summary = memory?.summaryText ?? '';
  return '【摘要】\n${summary.isEmpty ? '暂无摘要' : summary}';
}

/// Builds the /lore reply text: lists available worldbook entries, grouped by
/// character-level (built-in + character-bound) and world-level (world-bound).
Future<String> _loreCommand(AppDatabase db, Session session) async {
  final character = await db.getCharacter(session.characterId);
  if (character == null) return '暂无世界书条目';
  final worldId = session.worldId ?? '';

  final charBookJsons = <String>[
    if (character.worldbookJson != null &&
        character.worldbookJson!.isNotEmpty &&
        character.worldbookJson != '{}')
      character.worldbookJson!,
  ];
  final charBoundIds = await db.getCharacterWorldbookIds(character.id);
  for (final b in await db.getWorldbooksByIds(charBoundIds.toSet())) {
    charBookJsons.add(b.bookJson);
  }

  final worldBoundIds = await db.getWorldWorldbookIds(worldId);
  final worldBookJsons = <String>[];
  for (final b in await db.getWorldbooksByIds(worldBoundIds.toSet())) {
    worldBookJsons.add(b.bookJson);
  }

  final charEntries = _formatLoreEntries(charBookJsons);
  final worldEntries = _formatLoreEntries(worldBookJsons);
  if (charEntries.isEmpty && worldEntries.isEmpty) return '暂无世界书条目';

  final buffer = StringBuffer();
  if (charEntries.isNotEmpty) {
    buffer.writeln('【角色世界书】');
    buffer.writeln(charEntries);
  }
  if (worldEntries.isNotEmpty) {
    if (buffer.isNotEmpty) buffer.writeln();
    buffer.writeln('【世界世界书】');
    buffer.writeln(worldEntries);
  }
  return buffer.toString().trimRight();
}

/// Formats worldbook entries into a numbered list: `1. 标题（关键词：…）`.
String _formatLoreEntries(List<String> bookJsons) {
  final lines = <String>[];
  var n = 1;
  for (final json in bookJsons) {
    for (final e in _parseEntries(json)) {
      if (e['enabled'] == false) continue;
      final title = (e['comment'] ?? '').toString().trim();
      if (title.isEmpty) continue;
      final keys = e['keys'] is List
          ? (e['keys'] as List)
              .map((k) => k.toString())
              .where((k) => k.isNotEmpty)
              .toList()
          : <String>[];
      final keysLine = keys.isEmpty ? '' : '（关键词：${keys.join('、')}）';
      lines.add('$n. $title$keysLine');
      n++;
    }
  }
  return lines.join('\n');
}

/// Parses a worldbook JSON blob into its entry maps.
List<Map<String, dynamic>> _parseEntries(String bookJson) {
  try {
    final map = jsonDecode(bookJson) as Map<String, dynamic>;
    final entries = map['entries'];
    if (entries is! List) return const [];
    return entries.whereType<Map<String, dynamic>>().toList();
  } catch (_) {
    return const [];
  }
}

/// Reads and formats the relation: plain relation for regular characters,
/// skill-growth affinity for skill characters. Returns '' when empty.
Future<String> _relationText(
  AppDatabase db,
  Character character,
  String worldId,
) async {
  if (_hasSkillGrowth(character)) {
    final affinity = await db.getCharacterAffinity(character.id, worldId);
    return _formatAffinity(affinity?.affinityJson);
  }
  final relation = await db.getCharacterRelation(character.id, worldId);
  return _formatRelation(relation?.relationJson);
}

/// Parses a slash input like "/status" or "/help status" and dispatches it.
/// Returns the reply text to insert as a `command_reply` message.
Future<String> executeCommand(
  AppDatabase db,
  Session session,
  String input,
) async {
  final trimmed = input.trim();
  final body = trimmed.startsWith('/') ? trimmed.substring(1) : trimmed;
  final parts = body.split(RegExp(r'\s+'));
  final name = parts.first;
  final arg = parts.length > 1 ? parts.sublist(1).join(' ') : null;

  switch (name) {
    case 'help':
      return helpText(arg);
    case 'status':
      return await statusText(db, session);
    case 'relation':
      return await _relationCommand(db, session, arg);
    case 'summary':
      return await _summaryCommand(db, session);
    case 'lore':
      return await _loreCommand(db, session);
    default:
      return '未知指令：/$name\n输入 /help 查看所有可用指令。';
  }
}

/// Same rule as `MemoryService.hasSkillGrowth` (kept inline to avoid a
/// core→feature import): a skill character carries a non-empty affinity seed.
bool _hasSkillGrowth(Character character) {
  try {
    final core = jsonDecode(character.corePersonaJson) as Map<String, dynamic>;
    return core['affinity'] is Map && (core['affinity'] as Map).isNotEmpty;
  } catch (_) {
    return false;
  }
}

/// Reads the character's skill-defined state field names (key → display label),
/// stored under `core['state_schema']`.
Map<String, dynamic>? _readStateSchema(Character character) {
  try {
    final core = jsonDecode(character.corePersonaJson) as Map<String, dynamic>;
    final schema = core['state_schema'];
    return schema is Map<String, dynamic> ? schema : null;
  } catch (_) {
    return null;
  }
}

/// Chinese labels for known state fields. Unknown fields show their key as-is.
const _stateLabels = {
  'time': '时间',
  'location': '地点',
  'scene': '场景',
  'facts': '已知事实',
  'items': '物品',
  'npcs': '人物',
};

/// Chinese labels for relation + affinity (skill growth) keys.
const _relationLabels = {
  'affection': '好感',
  'trust': '信任',
  'intimacy': '亲密',
  'notes': '备注',
  'trust_level': '信任等级',
  'trust_value': '信任值',
  'corruption_value': '堕落值',
  'corruption_level': '堕落等级',
  'total_h_scenes_completed': 'H场景完成次数',
  'corruption_milestones': '堕落里程碑',
  'last_session': '上次会话',
};

/// Formats a state JSON blob into readable lines, hoisting core fields
/// (time/location) first and dropping empty values.
String _formatState(String stateStr, [Map<String, dynamic>? stateSchema]) {
  final map = _tryJsonMap(stateStr);
  if (map == null) return '';

  String labelOf(String key) {
    final schemaLabel = stateSchema?[key];
    if (schemaLabel is String && schemaLabel.isNotEmpty) return schemaLabel;
    return _stateLabels[key] ?? key;
  }

  final blocks = <String>[];
  void addField(String key, dynamic value) {
    if (_isEmpty(value)) return;
    blocks.add(_formatValue(labelOf(key), value));
  }

  addField('time', map['time']);
  addField('location', map['location']);
  for (final entry in map.entries) {
    if (entry.key == 'time' || entry.key == 'location') continue;
    addField(entry.key, entry.value);
  }
  return blocks.join('\n');
}

/// Formats a plain relation JSON blob (non-skill) into labelled lines.
String _formatRelation(String? relationStr) {
  final map = _tryJsonMap(relationStr ?? '');
  if (map == null) return '';

  final blocks = <String>[];
  for (final entry in map.entries) {
    if (_isEmpty(entry.value)) continue;
    blocks.add(
        _formatValue(_relationLabels[entry.key] ?? entry.key, entry.value));
  }
  return blocks.join('\n');
}

/// Formats a skill-growth affinity JSON into a compact, human-readable list:
/// merges level+value axes, drops unreached milestones, keeps the notes.
String _formatAffinity(String? affinityStr) {
  final map = _tryJsonMap(affinityStr ?? '');
  if (map == null) return '';

  final lines = <String>[];

  final trustLevel = map['trust_level'];
  final trustValue = map['trust_value'];
  if (trustLevel != null || trustValue != null) {
    lines.add('信任：Lv${trustLevel ?? '?'} · ${trustValue ?? '?'}/100');
  }

  final corruptionLevel = map['corruption_level'];
  final corruptionValue = map['corruption_value'];
  if (corruptionLevel != null || corruptionValue != null) {
    lines.add('堕落：Lv${corruptionLevel ?? '?'} · ${corruptionValue ?? '?'}/100');
  }

  final hScenes = map['total_h_scenes_completed'];
  if (hScenes != null) lines.add('H场景完成：$hScenes 次');

  final lastSession = map['last_session'];
  if (lastSession != null && lastSession.toString().isNotEmpty) {
    lines.add('上次会话：$lastSession');
  }

  final milestones = map['corruption_milestones'];
  if (milestones is Map && milestones.isNotEmpty) {
    const labels = {
      'lv1_reached': 'Lv1',
      'lv2_reached': 'Lv2',
      'lv3_reached': 'Lv3',
      'lv4_reached': 'Lv4',
      'lv5_reached': 'Lv5',
    };
    final reached = <String>[];
    milestones.forEach((k, v) {
      if (v == true) reached.add(labels[k] ?? k.toString());
    });
    if (reached.isNotEmpty) lines.add('堕落里程碑：${reached.join('、')}');
  }

  final notes = map['notes'];
  if (notes != null && notes.toString().isNotEmpty) {
    lines.add('备注：$notes');
  }

  return lines.join('\n');
}

/// Renders one labelled value as a single human-readable line: scalars inline,
/// lists joined by `、`, maps as `key：value` pairs joined by `、`.
String _formatValue(String label, dynamic value) {
  final String text;
  if (value is List) {
    text = value.map(_scalar).where((s) => s.isNotEmpty).join('、');
  } else if (value is Map) {
    text = value.entries
        .map((e) => '${e.key}：${_scalar(e.value)}')
        .join('、');
  } else {
    text = value.toString();
  }
  return '$label：$text';
}

/// Compact string for a list/map item; nested structures fall back to JSON.
String _scalar(dynamic value) {
  if (value is String || value is num || value is bool) return value.toString();
  return const JsonEncoder().convert(value);
}

Map<String, dynamic>? _tryJsonMap(String raw) {
  if (raw.trim().isEmpty || raw == '{}') return null;
  try {
    final decoded = jsonDecode(raw);
    return decoded is Map<String, dynamic> ? decoded : null;
  } catch (_) {
    return null;
  }
}

bool _isEmpty(dynamic value) {
  if (value == null) return true;
  if (value is String) return value.isEmpty;
  if (value is List) return value.isEmpty;
  if (value is Map) return value.isEmpty;
  return false;
}
