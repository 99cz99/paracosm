import 'package:drift/drift.dart';

/// 角色（联系人）：core 是核心人格，adaptation 存于 [CharacterAdaptations]。
class Characters extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();

  /// 核心人格 JSON（description/personality/scenario/first_mes/system_prompt…）。
  TextColumn get corePersonaJson => text()();

  /// 世界书 JSON（MVP 暂存于此，P2 迁入 Worlds）。
  TextColumn get worldbookJson => text().nullable()();

  TextColumn get avatarPath => text().nullable()();

  /// JSON 数组（自由标签，不做内容管控）。
  TextColumn get tags => text().withDefault(const Constant('[]'))();

  /// 来源：sillytavern / skill / manual。
  TextColumn get sourceType => text()();

  TextColumn get sourcePath => text().nullable()();

  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  /// 置顶时间戳；null = 未置顶（联系人列表置顶区按此倒序）。
  IntColumn get pinnedAt => integer().nullable()();

  /// 内置助手标识（角色/世界/世界书/使用助手）；null = 普通角色。
  TextColumn get builtInKey => text().nullable()();

  /// 虚拟年龄（角色设定/外表年龄，自由文本）。
  TextColumn get virtualAge => text().nullable()();

  /// 真实年龄（设定内实际年龄，自由文本，用于声明成年）。
  TextColumn get realAge => text().nullable()();

  /// 角色图库（JSON 数组 `[{name, path}]`，情绪图/背景图，聊天里按名字命中发图）。
  TextColumn get imageGalleryJson => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// 各世界适配：一个角色可有多行，按 worldId 区分。
/// 默认适配用 worldId='' 表示（不设外键，避免空串破坏约束）。
class CharacterAdaptations extends Table {
  TextColumn get id => text()();
  TextColumn get characterId => text().references(Characters, #id, onDelete: KeyAction.cascade)();

  /// 空串表示默认适配；非空逻辑上引用 Worlds.id。
  TextColumn get worldId => text().withDefault(const Constant(''))();

  /// 语气/人设/关系设定 JSON。
  TextColumn get adaptationJson => text()();

  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {characterId, worldId},
      ];
}

/// 异世界：规则、世界书、初始状态、NPC 池。
class Worlds extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get rulesJson => text().withDefault(const Constant('{}'))();
  TextColumn get worldbookJson => text().withDefault(const Constant('{}'))();
  TextColumn get initialStateJson => text().withDefault(const Constant('{}'))();
  TextColumn get npcPoolJson => text().withDefault(const Constant('{}'))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

/// 会话 = 角色 × 世界 × 用户 的一次具体演出。
class Sessions extends Table {
  TextColumn get id => text()();
  TextColumn get characterId => text().references(Characters, #id, onDelete: KeyAction.cascade)();

  /// 逻辑上引用 Worlds.id（无外键，允许为空）。
  TextColumn get worldId => text().nullable()();

  /// 逻辑上引用 CharacterAdaptations.id（无外键）。
  TextColumn get adaptationId => text().nullable()();

  TextColumn get title => text().nullable()();

  /// 用户人设 JSON（可选，空着跳过）。
  TextColumn get persona => text().nullable()();

  /// 跨世界记忆开关，默认开启。
  BoolColumn get memoryEnabled => boolean().withDefault(const Constant(true))();

  TextColumn get contextWindowLimit => text().nullable()();

  /// 会话级采样参数（null = 用默认）。[providerId] 指向 [ProviderConfigs].id。
  TextColumn get providerId => text().nullable()();
  RealColumn get temperature => real().nullable()();
  RealColumn get topP => real().nullable()();
  IntColumn get maxTokens => integer().nullable()();
  RealColumn get presencePenalty => real().nullable()();
  RealColumn get frequencyPenalty => real().nullable()();

  /// 会话级世界书选择（JSON 数组）；null = 用角色绑定默认。
  TextColumn get worldbookIdsJson => text().nullable()();

  /// 本会话累计消耗的 token（prompt/completion，逐轮累加）。
  IntColumn get totalPromptTokens => integer().nullable()();
  IntColumn get totalCompletionTokens => integer().nullable()();

  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  IntColumn get lastMessageAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

/// 消息。
class Messages extends Table {
  TextColumn get id => text()();
  TextColumn get sessionId => text().references(Sessions, #id, onDelete: KeyAction.cascade)();

  /// user / assistant / system / npc / tool。
  TextColumn get role => text()();
  TextColumn get content => text()();

  /// 会话内递增序号。
  IntColumn get orderIndex => integer()();
  IntColumn get timestamp => integer()();

  /// JSON：token 数、finishReason、模型名等。
  TextColumn get metadata => text().withDefault(const Constant('{}'))();

  /// 指令消息类型：null=普通消息，'command'=用户指令，'command_reply'=App 回复。
  TextColumn get type => text().nullable()();

  /// 是否进入 AI Prompt。指令消息为 false，不进下一轮上下文。
  BoolColumn get visibleToAi => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

/// 会话状态（结构化 JSON）+ 滚动摘要（与会话一对一）。
class SessionStates extends Table {
  TextColumn get sessionId => text().references(Sessions, #id, onDelete: KeyAction.cascade)();
  TextColumn get stateJson => text().withDefault(const Constant('{}'))();
  TextColumn get summaryText => text().withDefault(const Constant(''))();
  IntColumn get summaryIndex => integer().withDefault(const Constant(0))();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {sessionId};
}

/// 用户 ↔ 角色 的关系（结构化 JSON）。按「角色 × 世界」隔离：
/// 空串 worldId 表示默认（无世界）。
class CharacterRelations extends Table {
  TextColumn get characterId => text().references(Characters, #id, onDelete: KeyAction.cascade)();
  TextColumn get worldId => text().withDefault(const Constant(''))();
  TextColumn get relationJson => text().withDefault(const Constant('{}'))();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {characterId, worldId};
}

/// Skill 角色的成长三轴（信任/堕落度等），同样按「角色 × 世界」隔离。
/// 初始值仍留在 `core['affinity']`（导入时的种子），这里存各世界的当前状态。
class CharacterAffinities extends Table {
  TextColumn get characterId => text().references(Characters, #id, onDelete: KeyAction.cascade)();
  TextColumn get worldId => text().withDefault(const Constant(''))();
  TextColumn get affinityJson => text().withDefault(const Constant('{}'))();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {characterId, worldId};
}

/// 角色 × 世界 的世界级记忆（结构化状态 + 滚动摘要），与 [SessionStates] 的
/// 会话级 summaryIndex 分离，使状态/摘要跨会话（删会话）保留。
class CharacterMemories extends Table {
  TextColumn get characterId => text().references(Characters, #id, onDelete: KeyAction.cascade)();
  TextColumn get worldId => text().withDefault(const Constant(''))();
  TextColumn get stateJson => text().withDefault(const Constant('{}'))();
  TextColumn get summaryText => text().withDefault(const Constant(''))();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {characterId, worldId};
}

/// Provider 配置。API key 不落表，只存 secure storage 的引用名。
class ProviderConfigs extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();

  /// openai / anthropic。
  TextColumn get type => text()();
  TextColumn get baseUrl => text()();
  TextColumn get model => text()();

  /// 指向 flutter_secure_storage 的键名（如 `llm_api_key_<id>`）。
  TextColumn get apiKeyRef => text().withDefault(const Constant(''))();
  TextColumn get extraParamsJson => text().withDefault(const Constant('{}'))();

  /// 记忆抽取/摘要用的模型名（可选，留空则用 [model]；用于「便宜模型」）。
  TextColumn get memoryModel => text().nullable()();

  /// 模型上下文窗口上限（token 数），用于实时 token 显示；null = 用默认 32000。
  IntColumn get contextWindowLimit => integer().nullable()();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

/// 采样预设：命名的采样参数包（可含 provider），会话可套用。
class Presets extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();

  /// 指向 [ProviderConfigs].id，可空（空 = 用全局默认 provider）。
  TextColumn get providerId => text().nullable()();
  RealColumn get temperature => real().nullable()();
  RealColumn get topP => real().nullable()();
  IntColumn get maxTokens => integer().nullable()();
  RealColumn get presencePenalty => real().nullable()();
  RealColumn get frequencyPenalty => real().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

/// 通用键值设置。
class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

/// 群聊会话：世界 + 多角色。
class Groups extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get worldId => text().nullable()(); // 逻辑引用 Worlds.id
  TextColumn get avatarPath => text().nullable()();

  /// auto / turn / call。
  TextColumn get speakMode => text().withDefault(const Constant('auto'))();

  /// 是否把每个角色的记忆（关系/状态/摘要/成长）代入群聊 system prompt。
  BoolColumn get memoryEnabled => boolean().withDefault(const Constant(true))();

  /// 自动发言规则（JSON 数组）：{id, pattern(正则), characterId, delay, probability, enabled}。
  TextColumn get autoSpeakJson => text().nullable()();

  /// 群级采样参数 + Provider（null = 用默认）。[providerId] 指向 [ProviderConfigs].id。
  TextColumn get providerId => text().nullable()();
  RealColumn get temperature => real().nullable()();
  RealColumn get topP => real().nullable()();
  IntColumn get maxTokens => integer().nullable()();
  RealColumn get presencePenalty => real().nullable()();
  RealColumn get frequencyPenalty => real().nullable()();

  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  IntColumn get lastMessageAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

/// 群成员（角色）。
class GroupMembers extends Table {
  TextColumn get id => text()();
  TextColumn get groupId => text().references(Groups, #id, onDelete: KeyAction.cascade)();
  TextColumn get characterId => text().references(Characters, #id, onDelete: KeyAction.cascade)();
  IntColumn get joinOrder => integer()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {groupId, characterId},
      ];
}

/// 群聊消息；speakerCharacterId 为空表示用户发言。
class GroupMessages extends Table {
  TextColumn get id => text()();
  TextColumn get groupId => text().references(Groups, #id, onDelete: KeyAction.cascade)();
  TextColumn get speakerCharacterId => text().nullable()();
  TextColumn get role => text()(); // user / assistant / system
  TextColumn get content => text()();
  IntColumn get orderIndex => integer()();
  IntColumn get timestamp => integer()();

  /// 指令消息类型：null=普通消息，'command'=用户指令，'command_reply'=App 回复。
  TextColumn get type => text().nullable()();

  /// 是否进入 AI Prompt。指令消息为 false。
  BoolColumn get visibleToAi => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

/// 角色间关系（群内角色对，独立于用户↔角色关系）。
class PairRelations extends Table {
  TextColumn get id => text()();
  TextColumn get groupId => text().references(Groups, #id, onDelete: KeyAction.cascade)();
  TextColumn get charA => text()();
  TextColumn get charB => text()();
  TextColumn get relationJson => text().withDefault(const Constant('{}'))();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {groupId, charA, charB},
      ];
}

/// 群聊的独立记忆（结构化状态 + 滚动摘要 + summaryIndex 游标），与单聊记忆
/// （CharacterMemories / CharacterRelations / CharacterAffinities）完全隔离。
class GroupMemories extends Table {
  TextColumn get groupId =>
      text().references(Groups, #id, onDelete: KeyAction.cascade)();
  TextColumn get stateJson => text().withDefault(const Constant('{}'))();
  TextColumn get summaryText => text().withDefault(const Constant(''))();
  IntColumn get summaryIndex => integer().withDefault(const Constant(0))();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {groupId};
}

/// 剧情（视觉小说剧本）。
class Stories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get characterId => text().nullable()();
  TextColumn get worldId => text().nullable()();
  TextColumn get coverPath => text().nullable()();

  /// 当前节点（自动存档位置）。
  TextColumn get currentNodeId => text().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

/// 剧情节点（构成分支树）。
class StoryNodes extends Table {
  TextColumn get id => text()();
  TextColumn get storyId => text().references(Stories, #id, onDelete: KeyAction.cascade)();
  TextColumn get parentId => text().nullable()();
  TextColumn get narrative => text()();
  TextColumn get choicesJson => text().withDefault(const Constant('[]'))();

  /// 父节点选了哪个选项到达本节点（根节点为 null）。
  IntColumn get chosenIndex => integer().nullable()();
  IntColumn get depth => integer().withDefault(const Constant(0))();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

/// 剧情存档（手动存档 + 快速存档）。
class StorySaves extends Table {
  TextColumn get id => text()();
  TextColumn get storyId => text().references(Stories, #id, onDelete: KeyAction.cascade)();
  TextColumn get label => text()();
  TextColumn get currentNodeId => text().nullable()();
  BoolColumn get isQuick => boolean().withDefault(const Constant(false))();
  IntColumn get savedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

/// 世界书（独立资产库）。`bookJson` 存 normalized worldbook：
/// {name, description, scan_depth, token_budget, recursive_scanning,
///  entries:[...], sources:[...]?} —— `sources` 是 App 扩展（原文展示，不注入）。
class Worldbooks extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().withDefault(const Constant(''))();

  /// normalized 世界书 JSON（entries 触发关键词，sources 仅展示）。
  TextColumn get bookJson => text().withDefault(const Constant('{"entries":[]}'))();

  /// sillytavern / skill / manual。
  TextColumn get sourceType => text().withDefault(const Constant('manual'))();
  TextColumn get sourcePath => text().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

/// 角色 ↔ 世界书（多对多）。
class CharacterWorldbooks extends Table {
  TextColumn get characterId =>
      text().references(Characters, #id, onDelete: KeyAction.cascade)();
  TextColumn get worldbookId =>
      text().references(Worldbooks, #id, onDelete: KeyAction.cascade)();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {characterId, worldbookId};
}

/// 世界 ↔ 世界书（绑定到世界后，进入该世界自动生效）。
class WorldWorldbooks extends Table {
  TextColumn get worldId =>
      text().references(Worlds, #id, onDelete: KeyAction.cascade)();
  TextColumn get worldbookId =>
      text().references(Worldbooks, #id, onDelete: KeyAction.cascade)();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {worldId, worldbookId};
}

/// 群聊 ↔ 世界书（多对多）。
class GroupWorldbooks extends Table {
  TextColumn get groupId =>
      text().references(Groups, #id, onDelete: KeyAction.cascade)();
  TextColumn get worldbookId =>
      text().references(Worldbooks, #id, onDelete: KeyAction.cascade)();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {groupId, worldbookId};
}

/// 剧情 ↔ 世界书（多对多）。
class StoryWorldbooks extends Table {
  TextColumn get storyId =>
      text().references(Stories, #id, onDelete: KeyAction.cascade)();
  TextColumn get worldbookId =>
      text().references(Worldbooks, #id, onDelete: KeyAction.cascade)();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {storyId, worldbookId};
}

/// 群聊 ↔ 世界（多对多）。`Groups.worldId` 保留为主世界（记忆作用域/列表展示），
/// 本表才是注入用的完整世界集合。
class GroupWorlds extends Table {
  TextColumn get groupId =>
      text().references(Groups, #id, onDelete: KeyAction.cascade)();
  TextColumn get worldId =>
      text().references(Worlds, #id, onDelete: KeyAction.cascade)();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {groupId, worldId};
}

/// 剧情 ↔ 世界（多对多）。`Stories.worldId` 保留为主世界，本表为完整集合。
class StoryWorlds extends Table {
  TextColumn get storyId =>
      text().references(Stories, #id, onDelete: KeyAction.cascade)();
  TextColumn get worldId =>
      text().references(Worlds, #id, onDelete: KeyAction.cascade)();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {storyId, worldId};
}
