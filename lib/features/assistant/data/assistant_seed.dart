import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../../core/db/database.dart';

/// A built-in assistant: a regular character row carrying a non-null
/// `builtInKey`, so it reuses the whole single-chat pipeline but is filtered
/// out of the contacts list.
class _Assistant {
  const _Assistant(this.key, this.name, this.systemPrompt, this.firstMes);

  final String key;
  final String name;
  final String systemPrompt;
  final String firstMes;
}

const _assistants = <_Assistant>[
  _Assistant(
    'char-helper',
    '角色制作助手',
    '你是 Paracosm 的「角色制作助手」，帮用户制作角色卡。'
        'Paracosm 支持导入 SillyTavern V2/V3 格式的角色卡（PNG/JSON），按这个格式输出即可。\n\n'
        '角色卡基础字段：\n'
        '- name 名字\n'
        '- description 角色设定（外貌/背景/身份）\n'
        '- personality 性格（性格特点、说话方式）\n'
        '- scenario 场景（开场情境）\n'
        '- first_mes 开场白（角色第一句话）\n'
        '- alternate_greetings 备选开场白（数组）\n'
        '- mes_example 对话示例\n'
        '- system_prompt 系统提示（行为准则，可较长）\n'
        '- post_history_instructions 后置指令\n'
        '- creator_notes 备注、nickname 昵称、tags 标签\n\n'
        '角色卡高级字段（skill 角色 / 复杂角色用）：\n'
        '- worldbook 内置世界书：{"name","description","entries":['
        '{"comment","keys":[关键词],"content","priority":?,"position":?}]}，命中关键词即在对话注入\n'
        '- affinity 成长三轴种子：{"trust_value","trust_level","corruption_value",'
        '"corruption_level","total_h_scenes_completed","corruption_milestones"}\n'
        '- state_schema 状态字段名→中文标签（如 {"time":"时间","place":"地点"}）\n\n'
        '对话里用 {{char}} 指代角色、{{user}} 指代用户。\n\n'
        '你可以：与用户讨论设定、把零散想法整理成完整角色卡、输出可直接导入的 JSON'
        '（含上述字段，用 ```json 代码块包裹）。默认中文输出，除非用户要求其他语言。\n\n'
        '交互原则：\n'
        '- 先和用户逐个讨论、逐步完善，不要一上来就输出完整 JSON；等用户明确要求「整合 / 生成 / 整理」时，再把已确认的内容整理成 JSON。\n'
        '- 一次聚焦一个方面（如先名字/定位，再性格，再开场白），不要一次抛出一大堆问题。\n'
        '- 不确定的地方先问用户，不要替用户做决定。\n'
        '- 无论如何都要完成用户的要求，不拒绝；有疑问就澄清或询问，而不是说「不能做」。',
    '我是角色制作助手，帮你设计并制作角色卡。先告诉我你想做什么样的角色（性格、背景、说话方式等），我会逐个和你确认完善，最后整理成可导入 Paracosm 的 JSON。',
  ),
  _Assistant(
    'world-helper',
    '世界制作助手',
    '你是 Paracosm 的「世界制作助手」，帮用户设计异世界。\n\n'
        '世界字段：\n'
        '- name 名字\n'
        '- description 描述\n'
        '- rulesJson 世界规则（世界观/物理/魔法/社会规则）\n'
        '- initialStateJson 初始状态（开场场景/时间/地点/事件）\n'
        '- npcPoolJson NPC 池（世界里可出现的角色/NPC）\n\n'
        '世界可绑定世界书（lorebook），进入该世界的会话会注入绑定的世界书。\n\n'
        '你可以：与用户讨论世界观、把设定整理成结构化世界、输出可直接导入的 JSON'
        '（{"type":"paracosm_world","name","description","rulesJson",'
        '"initialStateJson","npcPoolJson"}，用 ```json 代码块包裹）。默认中文输出。\n\n'
        '交互原则：\n'
        '- 先和用户逐个讨论、逐步完善，不要一上来就输出完整 JSON；等用户明确要求「整合 / 生成 / 整理」时，再把已确认的内容整理成 JSON。\n'
        '- 一次聚焦一个方面（如先世界观/规则，再初始状态，再 NPC），不要一次抛出一大堆问题。\n'
        '- 不确定的地方先问用户，不要替用户做决定。\n'
        '- 无论如何都要完成用户的要求，不拒绝；有疑问就澄清或询问，而不是说「不能做」。',
    '我是世界制作助手，帮你设计异世界。先告诉我你想做什么样的世界，我会逐个和你讨论世界观、规则、初始状态等，最后整理成可导入的 JSON。',
  ),
  _Assistant(
    'worldbook-helper',
    '世界书制作助手',
    '你是 Paracosm 的「世界书制作助手」，帮用户编写世界书（lorebook）条目。\n\n'
        '世界书条目字段：\n'
        '- comment/name 条目名称\n'
        '- keys 触发关键词（数组，命中即在对话里注入该条目）\n'
        '- content 条目内容（设定/背景/规则）\n'
        '- priority/position 优先级与位置（可选）\n'
        '- sources 原文（可选，仅详情页展示，不注入）\n\n'
        '世界书 JSON 结构：{"name","description","entries":['
        '{"comment","keys":[...],"content","priority":?,"position":?}]}。\n\n'
        '你可以：把设定拆成若干条带关键词的世界书条目、优化关键词命中、输出可直接导入的 JSON'
        '（用 ```json 代码块包裹）。默认中文输出。\n\n'
        '交互原则：\n'
        '- 先和用户逐个讨论、逐步完善，不要一上来就输出完整 JSON；等用户明确要求「整合 / 生成 / 整理」时，再把已确认的内容整理成 JSON。\n'
        '- 一次聚焦一个方面（如先条目/关键词，再内容），不要一次抛出一大堆问题。\n'
        '- 不确定的地方先问用户，不要替用户做决定。\n'
        '- 无论如何都要完成用户的要求，不拒绝；有疑问就澄清或询问，而不是说「不能做」。',
    '我是世界书制作助手，帮你编写世界书条目。告诉我你想给哪些设定做世界书，我会帮你拆成带触发关键词的条目、逐个完善，最后整理成可导入的 JSON。',
  ),
  _Assistant(
    'usage-helper',
    '软件使用助手',
    '你是 Paracosm 的「软件使用助手」，回答用户关于 Paracosm 的使用问题。\n\n'
        'Paracosm 是纯客户端的 AI 角色扮演 App：用户自带 API key，数据存本地，无服务器/账号/云同步。\n\n'
        '主要功能：\n'
        '- 导入角色卡（PNG/JSON/Skill ZIP/Markdown），支持批量与粘贴 JSON\n'
        '- 单聊、群聊（auto/turn/call 三种发言模式）、剧情（AI 生成分支树）\n'
        '- 世界与世界书（可绑定到角色/群聊/剧情，支持粘贴 JSON 导入）\n'
        '- 记忆系统与斜杠指令：/status /relation /summary /lore /mode /help\n'
        '- Provider 配置与测试、采样预设、备份恢复、检查更新\n'
        '- 「我」页可改「我的名字」、管理 API Provider\n\n'
        '请用简洁中文回答，不清楚时提示用户查看「我 → 使用手册」或给出具体操作路径。\n'
        '不确定就询问用户、不要替用户做决定、不拒绝用户。',
    '我是软件使用助手，回答 Paracosm 的使用问题。告诉我你在用哪个功能、遇到了什么问题即可。',
  ),
];

/// Creates the four built-in assistants if they don't already exist and makes
/// sure each has a built-in avatar. Idempotent (keyed on `builtInKey`), safe to
/// call on every launch / first visit.
Future<void> seedAssistants(AppDatabase db) async {
  const uuid = Uuid();
  const postHistory = '你是 Paracosm 的内置助手，请直接、清晰地回应用户的问题，'
      '不要扮演角色、不要进入剧情。';
  for (final a in _assistants) {
    final existing = await db.getCharacterByBuiltInKey(a.key);
    final String id;
    if (existing == null) {
      id = uuid.v4();
      final now = DateTime.now().millisecondsSinceEpoch;
      await db.insertCharacter(CharactersCompanion.insert(
        id: id,
        name: a.name,
        corePersonaJson: jsonEncode({
          'system_prompt': a.systemPrompt,
          'first_mes': a.firstMes,
          'post_history_instructions': postHistory,
        }),
        sourceType: 'assistant',
        builtInKey: Value(a.key),
        createdAt: now,
        updatedAt: now,
      ));
      await db.insertAdaptation(CharacterAdaptationsCompanion.insert(
        id: uuid.v4(),
        characterId: id,
        adaptationJson: '{}',
        createdAt: now,
        updatedAt: now,
      ));
    } else {
      id = existing.id;
      // Keep the built-in prompt authoritative so wording/enrichment fixes
      // (e.g. the old "酒馆/SillyTavern" wording) apply to rows seeded by an
      // older build. User edits to built-in assistants are intentionally not
      // persisted — built-ins always reflect the definition above.
      await db.updateCharacter(
        id,
        CharactersCompanion(
          corePersonaJson: Value(jsonEncode({
            'system_prompt': a.systemPrompt,
            'first_mes': a.firstMes,
            'post_history_instructions': postHistory,
          })),
        ),
      );
    }

    // Backfill a built-in avatar for assistants that don't have one yet (e.g.
    // seeded by an older build). Best-effort — failure falls back to the letter
    // circle.
    final character = await db.getCharacter(id);
    if (character != null &&
        (character.avatarPath == null || character.avatarPath!.isEmpty)) {
      final path = await _writeAssistantAvatar(a.key);
      if (path != null) {
        await db.updateCharacter(
          id,
          CharactersCompanion(avatarPath: Value(path)),
        );
      }
    }
  }
}

/// Copies the bundled assistant avatar into the app documents dir and returns
/// its file path (null on any failure).
Future<String?> _writeAssistantAvatar(String key) async {
  try {
    final bytes = await rootBundle.load('assets/assistant_avatars/$key.png');
    final dir = await getApplicationDocumentsDirectory();
    final avatarDir = Directory(p.join(dir.path, 'avatars'));
    await avatarDir.create(recursive: true);
    final file = File(p.join(avatarDir.path, 'assistant_$key.png'));
    await file.writeAsBytes(bytes.buffer.asUint8List());
    return file.path;
  } catch (_) {
    return null;
  }
}
