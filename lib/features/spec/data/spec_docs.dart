import '../../../core/widgets/doc_viewer.dart';

/// One entry in the 制作规范 list.
class SpecEntry {
  const SpecEntry(this.key, this.title);
  final String key;
  final String title;
}

const specEntries = <SpecEntry>[
  SpecEntry('character', '角色卡制作规范'),
  SpecEntry('world', '世界制作规范'),
  SpecEntry('worldbook', '世界书制作规范'),
  SpecEntry('package', '角色包制作规范'),
];

/// Resolves a doc by key; `manual` serves the 使用手册.
Doc? docForKey(String key) {
  switch (key) {
    case 'character':
      return characterSpec;
    case 'world':
      return worldSpec;
    case 'worldbook':
      return worldbookSpec;
    case 'package':
      return packageSpec;
    case 'manual':
      return manualDoc;
    default:
      return null;
  }
}

const characterSpec = Doc('角色卡制作规范', [
  DocSection('概述', [
    '角色卡（SillyTavern V2/V3）是角色的核心设定，导入后驱动单聊、群聊、剧情里的角色表现。'
        '支持 PNG（含 tEXt 元数据）、JSON 两种格式导入。',
  ]),
  DocSection('核心字段', [
    'name：名字（必填）。',
    'description：角色设定，外貌 / 背景 / 身份，一段话讲清楚「这是谁」。',
    'personality：性格，包括说话方式、语气、习惯。',
    'scenario：场景，开场时角色所处的处境。',
    'first_mes：开场白，角色说给用户的第一句话。',
    'mes_example：对话示例，示范角色的说话风格（可多段）。',
    'system_prompt：系统提示，角色行为准则，可较长；skill 角色的核心机制也写在这里。',
    'post_history_instructions：后置指令，用于约束角色如何解读用户消息。',
    'creator_notes（备注）、nickname（昵称）为辅助字段。tags（标签）用于角色列表分类检索，可多个。',
  ]),
  DocSection('占位符', [
    '{{char}} 会被替换为角色名，{{user}} 会被替换为用户在「我 → 我的名字」里设置的名字。'
        '人设、开场白、世界书内容里都可使用。',
  ]),
  DocSection('三层解耦', [
    '角色由「core 核心人设 + adaptation 世界适配 + 世界书」三层组成。',
    'core 是跨世界通用的人设；adaptation 是角色在某一个世界里的专属语气/人设；'
        '世界书按关键词注入额外设定。',
  ]),
  DocSection('角色内置世界书', [
    '角色卡可内嵌 worldbook 字段（角色自带的世界书，不占共享世界书库）：'
        '{"name":...,"description":...,"entries":[{"comment":...,"keys":[...],"content":...}]}。',
    '命中关键词即在单聊自动注入，详情页「参考资料」可查看；不会写进世界书库。',
  ]),
  DocSection('JSON 示例（骨架，字段值自行填写）', [
    '{\n'
    '  "name": "【自行填写】",\n'
    '  "description": "【自行填写】",\n'
    '  "personality": "【自行填写】",\n'
    '  "scenario": "【自行填写】",\n'
    '  "first_mes": "【自行填写】",\n'
    '  "mes_example": "【自行填写】",\n'
    '  "system_prompt": "【自行填写】",\n'
    '  "post_history_instructions": "【自行填写】"\n'
    '}',
  ]),
  DocSection('导出与导入', [
    '导出为 SillyTavern V2 JSON（不含 app 内部字段）。',
    '导入：联系人页 → 导入角色，支持 PNG / JSON / Skill（ZIP / Markdown），可批量。',
  ]),
]);

const worldSpec = Doc('世界制作规范', [
  DocSection('概述', [
    '世界（异世界）承载世界规则、初始状态与 NPC 池，可绑定到角色、群聊、剧情。'
        '世界与角色通过「世界适配（adaptation）」解耦。',
  ]),
  DocSection('核心字段', [
    'name：名字（必填）。',
    'description：一段话描述这个世界是什么样。',
    'rulesJson：世界规则（世界观、物理/魔法/社会规则）。',
    'initialStateJson：初始状态（开场时的场景、时间、地点、事件）。',
    'npcPoolJson：NPC 池（世界里可出现的角色/NPC）。',
  ]),
  DocSection('JSON 示例（骨架，字段值自行填写）', [
    '{\n'
    '  "type": "paracosm_world",\n'
    '  "name": "【自行填写】",\n'
    '  "description": "【自行填写】",\n'
    '  "rulesJson": "【自行填写】",\n'
    '  "initialStateJson": "【自行填写】",\n'
    '  "npcPoolJson": "【自行填写】"\n'
    '}',
    '可通过世界详情页「导出 / 导入」，也支持粘贴 JSON 导入。',
  ]),
  DocSection('绑定与注入', [
    '世界可绑定世界书；进入该世界的会话会注入世界规则 + 初始状态 + 绑定的世界书。',
    '群聊与剧情可绑定多个世界（Groups.worldId / Stories.worldId 保留为主世界）。',
  ]),
]);

const worldbookSpec = Doc('世界书制作规范', [
  DocSection('概述', [
    '世界书（lorebook）是一组「关键词 → 内容」条目，当最近消息命中关键词时，'
        '对应条目自动注入 system prompt，无需常驻上下文。',
  ]),
  DocSection('条目字段', [
    'comment / name：条目名称（UI 展示用）。',
    'keys：触发关键词数组，命中即注入。',
    'content：条目内容（设定/背景/规则）。',
    'priority / position：优先级与位置（可选，编辑时保留）。',
  ]),
  DocSection('JSON 示例（骨架，字段值自行填写）', [
    '{\n'
    '  "name": "【自行填写】",\n'
    '  "description": "【自行填写】",\n'
    '  "entries": [\n'
    '    {"comment": "【自行填写】", "keys": ["【自行填写】"], "content": "【自行填写】"}\n'
    '  ]\n'
    '}',
    '支持 JSON / Markdown / zip 导入，以及粘贴 JSON 导入。',
  ]),
  DocSection('关键词设计', [
    '关键词用角色名、地点名、专有名词等明确触发词；纯字符串匹配，英文关键词可一键翻译成中文。',
    '命中范围是最近若干条消息，避免无关条目污染上下文。',
  ]),
]);

const packageSpec = Doc('角色包制作规范', [
  DocSection('概述', [
    '角色包（Skill）是一个 ZIP 或 Markdown 包，可携带角色人设、成长系统、研究资料与原文。'
        '与单张角色卡相比，角色包更适合带完整机制的复杂角色。',
  ]),
  DocSection('ZIP 结构', [
    '优先找 JSON 角色卡；否则读根目录 SKILL.md 的 frontmatter（name + description，'
        '支持 YAML 块标量 |），正文作为 system_prompt。',
    'references/affinity.json：成长三轴种子（信任 / 堕落度 / H 场景），写入 core["affinity"]。',
    'references/research/*.md + quality-validation.md：研究资料，解析为世界书条目（关键词注入）。',
    'references/sources/**：原文（详情页展示用，不注入）。',
  ]),
  DocSection('JSON 示例（骨架，字段值自行填写）', [
    'references/affinity.json（成长三轴种子）：\n'
    '{\n'
    '  "trust_value": "【自行填写】",\n'
    '  "trust_level": "【自行填写】",\n'
    '  "corruption_value": "【自行填写】",\n'
    '  "corruption_level": "【自行填写】",\n'
    '  "total_h_scenes_completed": "【自行填写】"\n'
    '}',
  ]),
  DocSection('Markdown 结构', [
    '单个 SKILL.md：frontmatter 写 name/description，正文即 system_prompt。',
  ]),
]);

const manualDoc = Doc('软件使用手册', [
  DocSection('简介', [
    'Paracosm 是纯客户端的 AI 角色扮演 App：自带 API key，本地 SQLite 存储，无服务器、无账号、无云同步。',
    '你的角色、剧情、记忆只存本机；API key 仅加密存本机，只用于请求你配置的服务商。',
  ]),
  DocSection('五个主标签', [
    '聊天：单聊与群聊的会话列表，入口处可「新单聊」。',
    '剧情：AI 生成的分支剧情，可回退、存档、重来。',
    '联系人：角色列表、导入、详情与编辑（含头像、标签、置顶）。',
    '异世界：世界与世界书的增删改查、绑定、导入导出。',
    '我：API Provider、采样预设、实时 Token 显示、搜索、助手、制作规范、使用手册、备份恢复、我的名字、检查更新。',
  ]),
  DocSection('导入角色', [
    '联系人 → 导入角色：支持 PNG / JSON 角色卡与 Skill（ZIP / Markdown），可批量多选，也支持粘贴 JSON。',
    '「开始聊天」会自动复用同一「角色 × 世界」下的会话，不会重复新建。',
  ]),
  DocSection('角色创建与编辑', [
    '可在联系人页手动创建角色，也可在聊天页「…」菜单 →「编辑人设」修改。',
    '可编辑的字段：角色名、角色设定、性格、场景、开场白、对话示例、系统提示（行为准则）、后置指令、备注、昵称、标签。',
    '改完人设后，下一条消息即生效，无需重启。',
  ]),
  DocSection('角色详情页', [
    '点角色进入详情页，可查看/编辑头像、标签、置顶；长文本折叠，内置世界书与原文两级折叠。',
    '世界适配：给角色在某一个世界里绑定专属人设；可绑定 / 编辑 / 解绑。',
    '全新开始：角色已有该「角色 × 世界」的记忆时，开聊前可选「全新开始」，清空该世界的关系记忆并重建会话。',
    '翻译开场白：把英文开场白逐条翻译成中文缓存。',
    '翻译世界书关键词：把世界书的英文关键词批量翻译成中文（提升命中率）。',
  ]),
  DocSection('年龄字段', [
    '角色可填「虚拟年龄」（对外呈现 / 自称的年龄）与「真实年龄」（设定内实际年龄，仅作幕后「已成年」背书）。',
    '两者都填时，被问及年龄按「虚拟年龄」回答；真实年龄不对外透露。',
    '自由文本，不随导出、不做内容拦截。',
  ]),
  DocSection('配置 API', [
    '我 → API Provider：填 baseUrl / model / API key，支持 OpenAI 兼容与 Anthropic 两类，'
        '可测试连接、点选切换当前 provider。API key 只存本地安全存储。',
  ]),
  DocSection('会话设置与 token', [
    '聊天页「会话设置」：可为每个会话单独指定 provider、温度、maxTokens、presence/frequency penalty。',
    '采样预设：把常用采样参数存成命名预设，「我 → 采样预设」管理、聊天页一键套用。',
    'token 面板：显示本会话累计消耗（真实 usage）；「我 → 实时 Token 显示」可开关顶部 token 估算。',
    '超过模型上下文窗口上限时，会自动裁剪最早的历史（已进摘要的部分，安全）。',
  ]),
  DocSection('单聊', [
    'SSE 流式回复，切后台继续生成。',
    '开场白：用户回复前可用 ← / 🎲 / → 切换开场白。',
    '消息撤回：长按消息 → 选中工具条 →「撤回」。',
  ]),
  DocSection('群聊', [
    '多角色同屏，三种发言模式：auto（AI 决定）/ turn（轮流）/ call（点名 @角色）。',
    '群信息页可增删成员、改角色名、换头像、解散群。',
    '「代入角色记忆」开关：开启后给每个成员注入其在对应世界的记忆。',
    '角色对关系：每对角色间的关系 / 亲密度会随对话自动抽取。',
  ]),
  DocSection('剧情', [
    'AI 生成分支剧情；选择时复用已生成分支，未命中才生成。',
    '支持回退、存档（重命名 / 删除）、多根节点；分支树可点跳 / 编辑 / 删除节点。',
    'choices 为空数组即结局。',
  ]),
  DocSection('世界与世界书', [
    '世界（异世界）承载世界规则、初始状态、NPC 池，可绑定到角色、群聊、剧情；群聊 / 剧情可绑定多个世界。',
    '世界书（lorebook）是「关键词 → 内容」条目，命中关键词即在对话注入；分角色内置与共享世界书库两类。',
    '世界书可绑定到角色 / 世界 / 群聊 / 剧情；会话可单独选择注入哪些世界书（会话级世界书选择）。',
    '世界书条目可在编辑页「测试触发」预览关键词命中；英文关键词可一键翻译成中文。',
    '世界 / 世界书支持 JSON / 粘贴导入与导出。',
  ]),
  DocSection('记忆与斜杠指令', [
    '每轮回复后异步抽取「结构化状态 + 滚动摘要」，按「角色 × 世界」隔离；关系与 skill 成长也按角色 × 世界独立。',
    '斜杠指令（聊天框输入 /）：',
    '/status 当前状态 · /relation 关系 · /summary 摘要 · /lore 世界书 · /mode 群聊发言模式 · /help 帮助。',
  ]),
  DocSection('助手与制作规范', [
    '我 → 助手：角色 / 世界 / 世界书制作助手 + 软件使用助手；助手消息里含可导入 JSON 时，点「导入」按钮一键落库。',
    '我 → 制作规范：角色卡 / 世界 / 世界书 / 角色包四份制作规范。',
  ]),
  DocSection('搜索', [
    '我 → 搜索：可搜角色与消息（消息结果带角色名）。',
  ]),
  DocSection('占位符与用户名', [
    '人设、开场白、世界书内容里可用 {{char}}（角色名）与 {{user}}（你的名字）。',
    '「我 → 我的名字」设置后，{{user}} 会替换成这个名字。',
  ]),
  DocSection('备份与更新', [
    '我 → 备份数据 / 恢复数据：全量 JSON 导出导入（API key 不随备份导出）。',
    '我 → 检查更新：对比 GitHub Releases 提示新版本并跳转下载页。',
  ]),
]);
