# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

# Paracosm — 纯客户端 AI 角色扮演 App

用户自带 API key，本地 SQLite 存储，和 AI 角色聊天、玩视觉小说剧情。**无服务器、无账号、无云同步。**

- 应用标识：显示名 **Paracosm**，applicationId **`com.paracosm.app`**（原名 `mj` / `com.example.mj`）。
- Drift 数据库文件名仍叫 `mj`（`database.dart` 的 `driftDatabase(name: 'mj')`）——**别改成 paracosm**，会新建空库丢数据。
- 启动图标由 `tool/gen_icon.py` 生成（像素风对话框，五档 PNG + 自适应图标 + 矢量前景）。

> 开发约定：每次改动记得 bump `pubspec.yaml` 的 `version`（功能/patch → patch 或 minor；破坏性 → major）。

## 技术栈

- Flutter（Android 优先，Android-only 工程）
- 状态管理：Riverpod 3
- 数据库：SQLite + Drift（`drift_flutter` 的 `driftDatabase`）
- Key 存储：flutter_secure_storage（仅 API key）
- 流式：dio + SSE（`ResponseType.stream` + 行解析）
- 路由：go_router（五 Tab `StatefulShellRoute`）
- 后台保活：flutter_background_service（前台服务，切后台继续流式）
- 拼音排序：lpinyin（联系人中文名首字母）
- 更新检查：url_launcher（跳 GitHub Release 下载页）
- Markdown 渲染：`markdown`（纯 Dart 解析 → TextSpan，气泡富文本）
- HTML 渲染：`flutter_widget_from_html_core`（纯 Dart，regex_scripts 产出的 HTML 面板用 `HtmlWidget` 渲染；用 core 版而非增强版，避开 `CachedNetworkImage` 异步下载在 reverse:true 列表的卸载 bug）

## 环境（已装好，位于 E 盘）

| 组件 | 路径 |
|---|---|
| Flutter SDK | `E:\flutter`（stable 3.47.4，Dart 3.13.3） |
| Android SDK | `E:\Android`（platform 36 / build-tools 36.0.0 / 35） |
| JDK 17 | `E:\jdk` |
| 模拟器 AVD | `E:\Android\avd\pixel7.avd`（name: `pixel7`） |

已设 User 级环境变量：`ANDROID_HOME`/`ANDROID_SDK_ROOT`=`E:\Android`、`JAVA_HOME`=`E:\jdk`、`ANDROID_AVD_HOME`=`E:\Android\avd`、`PUB_HOSTED_URL`/`FLUTTER_STORAGE_BASE_URL`（中国镜像）、PATH 含 `E:\flutter\bin`。

## 常用命令

```bash
# 每次 shell 需要（或依赖已持久化的 User 环境变量）：
export PATH="/e/flutter/bin:/e/jdk/bin:$PATH"
export ANDROID_HOME="E:/Android" JAVA_HOME="E:/jdk"

flutter pub get                              # 拉依赖
dart run build_runner build                  # 重新生成 drift 的 database.g.dart
flutter analyze                              # 静态检查（目标 0 issue）
flutter test                                 # 单元测试（纯 Dart + 内存 DAO）
flutter test test/<file>.dart                 # 跑单个测试文件
flutter test --plain-name '<测试名>'           # 按名字跑单个 test()
flutter run -d emulator-5554                 # 模拟器跑（需先启动模拟器）
flutter run -d 10AD6C018M0014Q               # 跑实体手机（Vivo V2301A）
flutter build apk --debug                    # 打 debug 包
flutter build apk --release                  # 打 release 包（通用 APK ~64MB；--split-per-abi 可拆小）
flutter emulators --launch pixel7            # 启动模拟器
```

**部署到手机**（`flutter run` 的流式安装偶发卡死，更稳的做法）：

```bash
flutter build apk --debug
adb install -r build/app/outputs/flutter-apk/app-debug.apk   # 分步执行，别和 build 串一条命令
adb shell am start -n com.paracosm.app/.MainActivity
```

## 项目结构（feature-first）

```
lib/
  core/
    config/       # AppConfig（schemaVersion 等）
    db/           # tables.dart + database.dart（Drift 表 + 查询方法）
    network/llm/  # LlmProvider 抽象 + OpenAI 兼容/Anthropic 实现 + mock + translator（翻译工具）
    network/sse/  # SSE 行解析
    storage/      # flutter_secure_storage 封装
    import/       # 酒馆卡/Skill 解析 → 统一 ImportedCharacter
    backup/       # 数据备份/恢复（JSON 全量导出导入）
    background/   # 后台保活（前台服务）
    providers/    # dbProvider、secureKeyStoreProvider、resolveProvider/resolveActiveProvider
    router/ theme/ utils/
  features/
    chat/         # 会话列表 + 单聊流式（chat_controller）+ 开场白切换
    contacts/     # 联系人 + 导入 + 角色详情/编辑
    group_chat/   # 群聊（多角色 + 三模式 + 角色对关系）
    story/        # 剧情（AI 生成 + 分支树 + 回退 + 存档）
    worlds/       # 异世界 CRUD
    profile/      # 「我」+ API Provider 配置
    assistant/    # 四个内置 AI 助手（builtInKey 角色，复用单聊管线）
    spec/         # 制作规范 + 使用手册（DocViewer 渲染结构化文档）
    home/         # 五 Tab 底部导航壳
    search/       # 角色/消息搜索
```

三层解耦落点：角色 core（`Characters.corePersonaJson`）+ adaptation（`CharacterAdaptations`，默认 `worldId=''`）+ 世界书。世界书分两类：① **角色内置世界书**——导入角色卡时随角色存 `Characters.worldbookJson`（不进库，单聊注入 + 详情「参考资料」展示）；② **共享世界书库** `Worldbooks`——异世界 tab 导入/新建，经 `CharacterWorldbooks`/`WorldWorldbooks`/`GroupWorldbooks`/`StoryWorldbooks` 绑定到角色/世界/群聊/剧情（多对多）。群聊/剧情多世界走 `GroupWorlds`/`StoryWorlds`（`Groups.worldId`/`Stories.worldId` 保留为主世界）。

## 关键设计

- **五 Tab 路由**：`StatefulShellRoute.indexedStack` → 聊天 / 剧情 / 联系人 / 异世界 / 我；`/search` 是壳外顶层路由（非 Tab）。
- **Tab 切换重置**（`home/presentation/home_shell.dart`）：`goBranch(index, initialLocation: index >= 2 || index == currentIndex)`。联系人/异世界/我（index≥2）每次进入回到首页（避免停在旧详情页）；聊天/剧情（0/1）保留导航栈（避免打断进行中的流式/剧情生成）。
- **go_router 带参数路由要加 `ValueKey`**：`/contacts/:characterId` 这类同一路由、不同参数，go_router 复用 widget 时若无 key 会显示上一个角色的陈旧数据。所有带 `:param` 的 route builder 都要传 `key: ValueKey(param)`（`core/router/app_router.dart` 已统一加）。
- **LLM Provider 抽象**：`LlmProvider.streamChat()` 返回 `Stream<ChatChunk>`。`OpenAiCompatibleProvider`（chat/completions + SSE，覆盖 DeepSeek/Kimi/GLM/SiliconFlow/OpenAI）与 `AnthropicProvider`（Messages API）双实现。活跃配置每次发送时现场解析（`resolveActiveProvider`），避免 Riverpod 缓存旧 key。Provider 列表页「点一下选中」切换当前 API（编辑走单独按钮）。
- **Drift companion 陷阱**：带 `withDefault(...)` 的列在 companion 里是 `Value<T>`，必须用 `Value(...)` 包裹；不带默认的非空列才是裸类型。UI 文件里 `import 'package:drift/drift.dart' hide Column;`（避开 Flutter 的 `Column`）。
- **Schema 迁移**：改表结构要同步 `AppConfig.schemaVersion`（迁移时递增，见 `app_config.dart`）+ 在 `database.dart` 的 `migration.onUpgrade` 写 `from < N` 分支，再 `dart run build_runner build` 重生成 `database.g.dart`。改主键需删表重建——关系/affinity 这类可重抽取数据直接 `deleteTable`+`createTable` 即可（数据可接受丢失）。
- **Riverpod 3 dispose 陷阱**：`dispose()` 里不能用 `ref.read(...)`——widget 卸载时 BuildContext 已失效，抛 `Using "ref" when unmounted is unsafe`。改成在 `build()` 里把 notifier 存成字段，`dispose()` 用字段调（如 `chat_screen.dart` 的 `_controller?.cancel()`）。
- **记忆系统**（`features/chat/data/memory_service.dart`）：每轮回复后异步（`unawaited`）抽取「结构化状态 + 滚动摘要」——存 **`CharacterMemories` 表**（按「角色×世界」复合主键隔离，**删会话即删除该角色×世界的记忆**）；`SessionStates` 表只保留**会话级 `summaryIndex` 游标**（本会话摘要到第几条）。世界书按关键词注入 system prompt（纯字符串匹配，无 LLM）。关系（`CharacterRelations`）与 Skill 成长（`CharacterAffinities`）也按「角色×世界」隔离（`worldId` 空串=默认）——同角色在不同世界各自独立，不串味。「全新开始」清空该角色×世界的全部记忆（关系+成长+状态+摘要）。抽取/摘要可用「记忆模型」（`ProviderConfigs.memoryModel`）指定便宜模型。
- **认知态与摘要可靠性**：状态+关系/成长合并成 `MemoryService._extractMemory` **一次 LLM 调用**（输出 `{state, relation|affinity}`），抽取窗口为最近 **`stateExtractWindow=6`** 条；`stateJson` 种子扩为认知维度（time/place/scene/environment/char_outfit/char_body/nearby_items/npcs/style{person,perspective,onomatopoeia}/facts），注入时用 `slash_commands.dart` 的 `formatStateForPrompt`/`formatRelationForPrompt` 格式化成可读块（非裸 JSON）。**记忆抽取 `maxTokens=16384`**（推理模型思考不再耗尽、返回空；群聊状态/角色对关系同）。摘要 `summaryWindow=8`/`keepRecent=4`（短会话也生成）、`_summarize` `maxTokens=2048`、**空摘要不推进 `summaryIndex`**（重试一次仍空则保消息下轮再试，防丢记忆）；摘要只扫 `visibleToAi` 消息（命令消息不进摘要）；记忆更新改用**会话 provider**（`resolveProvider(providerId: session.providerId)`）而非默认；`_runMemoryUpdate`/`_runGroupMemoryUpdate` 的 `resolveProvider` 也包在 try/catch 里。
- **记忆年龄上下文**：`MemoryService._ageContext` 把角色的 `realAge`/`virtualAge` 注入记忆抽取/摘要的 prompt（`realAge` 非空时附带「对话中出现的其他角色（NPC）同样为成年设定」），避免记忆模型（如 deepseek-chat）把成人角色扮演误判成「涉未成年」。`_looksLikeRefusal` 识别并丢弃模型的安全拒绝文案——新输出按空处理（不写进 `summaryText`），旧的拒绝文案在下次摘要时也按空处理覆盖。
- **Skill 成长系统**：带 `core['affinity']`（skill 的三轴成长种子：信任/堕落度/H场景）的角色走 skill 自带数值规则。成长更新已并入 `MemoryService._extractMemory`（与状态抽取**合并成一次 LLM 调用**，输出 `{state, affinity}`），`sanitizeAffinity` clamp 后写回 **`CharacterAffinities` 表**（按角色×世界，`core['affinity']` 只留作种子不再回写）。⚠️ **别把整段 `core['system_prompt']` 塞进回写 prompt**（skill 系统提示可能几万字，会爆记忆模型上下文、导致返回空/非 JSON）。**只在单聊触发**（群聊/剧情不走）；LLM 驱动、尽力而为（失败静默保旧值）。
- **每会话 API + 采样参数 + 预设**：`Sessions` 增列 `providerId`/`temperature`/`topP`/`maxTokens`/`presencePenalty`/`frequencyPenalty`（null=用默认 1.2 / 1.0 / 4096 / 无）。`resolveProvider(db, store, providerId:)` 按会话指定 provider，查不到回落默认。`Presets` 表存命名采样参数包，聊天页「会话设置」可套用；「我」→「采样预设」管理。presence/frequency penalty 只对 OpenAI 兼容 provider 生效（Anthropic 忽略）。
- **群聊记忆开关**：`Groups.memoryEnabled`（默认开）。群信息页「代入角色记忆」开关；开启时 `group_service.dart` 给每个成员注入其在该世界的记忆（状态/摘要/关系/成长），关闭只注入 core 人设 + 角色对关系。
- **剧情分支**（`features/story/`）：`StoryNodes` 树（子节点存 `chosenIndex`）。选择时先 `getChildByChosenIndex` 复用已生成分支，未命中才生成；「重来」`regenerateNode` 覆盖当前节点并删其子树；`choices` 空数组=结局；分支树可点跳/编辑/删除（`deleteStoryNodeSubtree` 递归删）。
- **后台继续回复**（`core/background/reply_background.dart` + `main.dart`）：`flutter_background_service` 前台服务保活。**不在发送时起服务**（新起后台 engine 会卡 UI），改为 `ChatController.didChangeAppLifecycleState`：`paused` 且 `anyGenerating` 时才 `startReplyForeground()`，`resumed` 停止。`chat_screen.dispose` **不 cancel**（全局控制器继续跑，`sendMessage` 落库前已判会话存在）。
- **⚠️ 弹窗导航陷阱（最重要）**：`showDialog` 默认 `useRootNavigator: true`，会把弹窗推到 go_router 的**根 Navigator**，与 `StatefulShellRoute` 的**分支 Navigator** 冲突——弹窗关闭后根 Navigator 状态错乱，直接黑屏（删会话/新单聊/删剧情都踩过）。**所有弹窗必须传 `useRootNavigator: false`**，且按钮要用 builder 传入的 `dialogContext` 调 `Navigator.of(dialogContext).pop()`，不能用外层屏幕的 `context`。`showModalBottomSheet` 默认 `useRootNavigator: false`，选列表类弹窗优先用它。提示一律弹窗（`core/utils/dialogs.dart`），不用聊天气泡/snackbar。
- **聊天/群聊控制器是全局 `NotifierProvider`**（`chatControllerProvider`/`groupChatControllerProvider`，非 autoDispose）：离开页面后流式回复仍在跑。回复落库前要检查会话/群是否还存在（`getSession`/`getGroup`），否则删会话/群后仍写库会撞外键约束崩溃黑屏。
- **单聊并发流（每会话独立）**：`chatControllerProvider` 仍是全局协调器（非 autoDispose），但内部按 sessionId 分片——`ChatController._streams: Map<String,_SessionStream>` + `ChatUiState.streams: Map<String,StreamSessionState>`（每会话一条不可变流态）。**多个单聊可同时流式、切页互不打断**；UI 用 `select((s) => s.isGenerating(sessionId))` / `s.streams[sessionId]?.text` 按会话取，`sendMessage` 只拦「本会话已在生成」（`_streams[sessionId]?.isGenerating`），不再全局互斥；`cancel(sessionId)` 按会话取消。群聊仍是单流（`GroupChatUiState.streamingGroupId` 记录归属）。
- **群聊流式按角色分割**：auto 模式下模型一次生成多个角色的回复（`名字：` 前缀分隔），`GroupChatUiState` 存 `streamingSegments`（`List<({speakerId, content})>`），流式每收到 delta 就用 `_parseReplies` 实时分割、**每个角色一个气泡**（持久化也走 `_parseReplies`）。别把整段 buffer 当一个 speaker 渲染。
- **后台中断兜底**：`sendMessage` 的 catch 里若 buffer 非空（流式中途被打断，如切后台网络断开）就落库保存**部分回复**、静默停止；一个字都没生成才 rethrow 报错。
- **角色数据响应性**：`chatCharacterProvider` 是 `StreamProvider`（`db.watchCharacter(id)`），改头像/名字即时刷新聊天页；详情页的 `characterProvider` 仍是 FutureProvider，改动后要 `ref.invalidate(characterProvider(id))` 才刷新。
- **会话复用（一个「角色 × 世界」一个会话）**：联系人「开始聊天」和聊天列表「新单聊」都走 `SessionRepository.getOrCreateSession`（按角色+世界复用已有会话，不再无脑新建）；只有「全新开始」才删旧会话重建。
- **消息撤回**：长按消息 → 原生选中工具条（`SelectableText.contextMenuBuilder` + `AdaptiveTextSelectionToolbar`）追加「撤回」项，硬删除 `deleteMessage`。因此 `nextOrderIndex` 用 `orderIndex.max()+1` 而非 `count()`，删中间消息不会让下一条插入撞号。
- **世界适配绑定/解绑**：角色详情「世界适配」卡片可绑定（`_bindWorld`，已绑定世界不重复列出）/编辑 persona/解绑（`link_off` 图标，删适配行不动会话）。解绑后聊天时 `getAdaptation` 返回 null → 不注入该世界适配人设，世界规则仍按会话 worldId 注入。
- **全新开始**：角色已有该「角色×世界」的关系记忆时，开聊前弹「继续 / 全新开始」。全新开始 = 清空该世界关系（`resetCharacterRelation`）+ 删旧会话重建。
- **开场白与翻译缓存**：`SessionRepository.getGreetings()` 返回开场白列表，优先读 `core['greetings_zh']`（中文缓存），否则 `first_mes` + 去重后的 `alternate_greetings`。`createSession` 用缓存中文 `first_mes` 作首条消息。聊天页 AppBar 的 ←/🎲/→（用户回复后隐藏）通过 `db.replaceOpeningMessage`（替换 orderIndex 0）切换开场白。角色详情页「翻译开场白」按钮用 `core/network/llm/translator.dart` **逐条翻译**（`maxTokens: 16384`——2048 会让长开场白截断回退英文，8192 又会被推理模型（deepseek-v4-pro）的思考耗尽、`content` 返回空；翻译后校验、仍是英文就重试；显示进度；保留原文段落/换行/`{{char}}`/`*动作*` 格式），结果存 `core['greetings_zh']`。翻译无独立模型配置，走默认 provider。
- **`core` 内部字段约定**：`core['affinity']`（skill 成长态）、`core['greetings_zh']`（开场白中文缓存）是 App 内部字段，不属于 SillyTavern persona；`CharacterExporter` 导出时需过滤（已过滤 `affinity`，`greetings_zh` 同理）。
- **角色导入管线**：`CharacterRepository._parseBytes` 按扩展名分发——PNG（tEXt chunk）/JSON 走 `StCardParser`（V1/V2/V3），ZIP/MD 走 `SkillImporter`，统一产出 `ImportedCharacter`，再由 `importCharacter` 落库为 `Characters`（core + 内置 `worldbookJson`）+ 默认 `CharacterAdaptations`（worldId=''）。Skill 的 ZIP 是个文件夹：优先找 JSON 角色卡，否则读根目录 `SKILL.md` 的 frontmatter（`name` + `description`，支持 YAML 块标量 `|`），**正文捕获为 `core['system_prompt']`**。此外 `SkillImporter` 还会解析：`references/affinity.json` → `core['affinity']`；`references/research/*.md` + `quality-validation.md` → 世界书条目（`worldbook.entries`，关键词注入）；`references/sources/**`（game_text）→ `worldbook.sources`（详情页展示用，**不注入**）。`sourceType` 取值 `sillytavern`/`skill`/`manual`，ZIP/MD 记为 `skill`。
- **世界书注入与匹配**（`core/world/world_context.dart`）：`WorldbookMatcher`（纯本地匹配，无 LLM）+ `WorldContextBuilder`（`build(worldIds, worldbookIds)` 把实体绑定的世界书并入各世界绑定的世界书）。单聊注入「角色内置世界书 + 角色绑定的共享世界书 + 世界绑定的世界书」并集；群聊/剧情注入「群/剧情绑定的共享世界书 + 世界绑定的世界书」。条目字段：`comment`（名称）+ `keys` + `content`；`WorldbookParser` 保留 `priority`/`position` 等元数据，编辑页保存用 `...original` 保留（别只写 keys/content 丢元数据）。**匹配已支持 SillyTavern 丰富字段**：`use_regex`（正则）、`case_sensitive`（默认大小写不敏感）、`secondary_keys`、`selective`（AND：所有 keys 且所有 secondary 都命中才触发）、`match_whole_words`、递归（book 级 `recursive_scanning`+`scan_depth` + 条目级 `exclude_recursion`，命中条目内容再触发其它条目）、排序 `priority` 降序 + `insertion_order` 升序、`{{random:a|b}}` 动态展开。
- **角色创建/编辑/热修改**：`CharacterEditScreen` 的 `characterId` 可空，新建（`CharacterRepository.createCharacter`，`sourceType='manual'`）/编辑共用一屏，字段含 system_prompt/mes_example/creator_notes/nickname/post_history_instructions。聊天页 `…` 菜单「编辑人设」→ `/contacts/:id/edit`；`_buildRequest` 每轮 `getCharacter` 重读 core，改完**下一条消息即生效**（无需刷新 provider）。
- **用户消息处理 + 后置指令**：`_systemPromptSections` 末尾注入「用户消息处理」默认指令（OOC `(())`/`【】`、`{{user}}`、多意图、人称文风，见 `chat_controller._defaultMessageHandling`）；若 `core['post_history_instructions']` 非空则注入角色自己的（该字段之前存了却从不注入，已修活）。
- **内置 AI 助手**（`features/assistant/`）：角色/世界/世界书/使用四个助手建模为**内置角色**（`Characters.builtInKey` 非空 + `sourceType='assistant'`，schema v16 加列），`assistant_seed.dart` 幂等 seed（按 `builtInKey` 判存在；**对已存在的助手也会回写内置 prompt**，让措辞/格式修复生效——内置定义始终权威）。system prompt 存 `corePersonaJson['system_prompt']`；seed 还会把 `assets/assistant_avatars/*.png` 拷到文档目录回填 `avatarPath`（内置头像）。入口「我 → 助手」，点击复用 `SessionRepository.getOrCreateSession` + 单聊 `ChatScreen`（worldId=''）。**助手结果一键导入**：助手聊天里，助手消息含可导入 JSON 时消息下渲染「导入」按钮——`importable_detector.dart` 从回复抽 JSON 并分类（角色卡/世界/世界书），点按钮走 `CharacterRepository.importCharacter`/`parseWorldJson`/`WorldbookRepository.importFromJson` 一键落库。联系人列表 `charactersProvider` 按 `builtInKey == null` 过滤。
- **角色年龄字段（schema v17）**：`Characters.virtualAge`（虚拟年龄 = 角色对外呈现/自称的年龄，被问就答这个）+ `realAge`（真实年龄 = 设定内实际年龄，仅作幕后「已成年」背书、不对外透露）。聊天 `_systemPromptSections` 注入 `【年龄】` 段（只注入非空字段；两字段都填时追加「被问及年龄按对外年龄回答」）。自由文本、不随 SillyTavern 导出、不做内容拦截。
- **批量导入**：file_picker 13 的 `FilePicker.pickFiles(...)` 返回 `List<PlatformFile>`（**本就多选，无 `allowMultiple` 参数**），`FilePicker.pickFile` 返回单个 `PlatformFile?`。导入页遍历全部文件、汇总成功/失败数。
- **联系人列表排序 + 置顶**：`Characters.pinnedAt`（null=未置顶）。列表按「置顶区(pinnedAt 倒序) + 拼音首字母分组 A-Z/#」排序，右侧 A-Z 索引条（懒加载 `ListView.builder`，`ScrollController` + 固定行高 offset 估算跳分组）。中文首字母用 `lpinyin`（`core/utils/pinyin.dart` 的 `pinyinInitial`：英文→大写首字母，中文→拼音首字母，数字/符号→#）。置顶/删除走长按底部菜单（`showModalBottomSheet`）。
- **斜杠指令**（`core/commands/slash_commands.dart`）：聊天框 `/` 指令，回复作为 `command_reply` 消息落库。单聊 `executeCommand`：`/status`（结构化状态）/`/relation`（关系或 skill affinity）/`/summary`（滚动摘要）/`/lore`（世界书名称）/`/help`；群聊 `executeGroupCommand`：`/status`（群状态）/`/relation`（所有成员关系）/`/summary`（群摘要）/`/lore`（群绑定世界书）/`/mode`（切 auto/turn/call，`rotate`/`mention` 是别名）/`/help`。加新指令 = `allSlashCommands` 加一条 + 对应 `execute*Command` 加 case。`/status` 用 `_formatValue`/`_formatInline` **递归**格式化嵌套 Map/List（`、`/`key：value` 拼接），别用 `JsonEncoder` 兜底（否则 state 里的嵌套结构会原样倒出 JSON）。
- **Token 估算**（`core/network/llm/token_estimator.dart`）：无真实 tokenizer，启发式估算（CJK/全角 ≈ 1 token，ASCII ≈ 4 字符/token），UI 一律标「估算」。`ProviderConfigs.contextWindowLimit`（token 数，null=默认 32000）当上下文窗口上限，用于实时 token 显示。
- **会话累计 token 消耗**（真实 usage，非估算）：OpenAI 兼容请求加 `stream_options: {'include_usage': true}` 才回传 usage；`chat_controller.sendMessage` 捕获 `chunk.promptTokens/completionTokens`，写 `Messages.metadata`（JSON）+ 累加回写 `Sessions.totalPromptTokens/totalCompletionTokens`（schema v15 加两列，`database.dart` 有 `addSessionTokens`）。聊天页 token 面板显示「本会话累计消耗」。群聊暂未做（`GroupMessages` 无 metadata 列）。
- **省 token / 缓存命中**：`_buildRequest` 超 `contextWindowLimit - outputReserve` 时从最旧 history 丢弃（已入摘要，安全，保底 2 条）；Anthropic system 加 `cache_control:{type:"ephemeral"}` 断点；开场白示例 `first_mes` 在用户回复后不再注入（`includeExample: !hasUserReply`）；世界书条目去重（set 字面量）。
- **会话级世界书选择**：`Sessions.worldbookIdsJson`（JSON 数组）覆盖该会话注入的共享世界书，null = 回退角色绑定默认（`CharacterWorldbooks`）；`/lore` 与 `WorldContextBuilder.build` 均读它。
- **跨语言世界书触发**：世界书匹配是纯字符串，英文关键词配中文消息匹配不上。`translator.dart` 的 `translateKeys` 批量把英文关键词翻成中文、追加进条目 `keys`（正文不翻）；入口是世界书编辑页「翻译关键词（英→中）」和角色详情页「翻译世界书关键词为中文」按钮。
- **头像加载与性能**：`CharacterAvatar`/`GroupAvatar` 的 `build` 里**别用 `File(...).existsSync()`**（同步 I/O 卡 UI），改 `Image.file` + `errorBuilder` 兜底 + `cacheWidth`/`cacheHeight`（头像原图是 crop 的原分辨率，decode 大图会卡列表）。`saveAvatar`/`saveGroupAvatar` 用 `core/utils/avatar_image.dart` 的 `resizeAvatarPng`（256×256）压缩、写 `<uuid>.png`、并删旧头像文件；`main.dart` 里 `unawaited(migrateLargeAvatars())` 启动时清理历史大图（角色卡 PNG 当头像会留下 6.8MB 的 tEXt 元数据）。联系人列表已改 `ListView.builder` 懒加载，A-Z 跳转用 `ScrollController` + 固定行高估算 offset（`_headerHeight`/`_itemHeight`）。
- **启动画面（splash）**：`launch_background.xml` 背景固定品牌紫 `#7C6FDE`（`colors.xml` 的 `launch_background`），暗色模式才不黑屏。Android 12+（targetSdk≥31）走系统 SplashScreen，`values-v31`/`values-night-v31/styles.xml` 需显式设 `windowSplashScreenBackground`（不透明，否则背景透明透 task snapshot）+ `windowSplashScreenIconBackgroundColor`（`@android:color/transparent`，否则图标带紫色色块）+ `windowSplashScreenAnimatedIcon`（`@drawable/ic_splash`，无背景对话框、垂直居中，内联脚本生成）。⚠️ `python tool/gen_icon.py` 会**重写 `colors.xml`** 丢掉 `launch_background`，跑完要手动加回。三点动画在 **Flutter 启动页** `lib/core/splash/splash_screen.dart`（`/splash` 首屏）实现：渲染 `assets/ic_splash.png`（去点版）+ 三个浅青方形点错峰淡入淡出，~1.6s 后 `context.go('/chat')`；`_iconSize=288` 对齐原生图标尺寸、`StackFit.expand` 避免点被裁掉。`drawable/ic_splash.png` 保留三点（原生阶段静态显示），`assets/ic_splash.png` 去点（Flutter 用），由 `tool/strip_splash_dots.py` 生成（读带点版、把 `#BFF3FA` 替换成 `#12242E`）。交接闪变两个坑：① 三点用 `_loop`（`..repeat()`）+ `_intro`（一次性 600ms）双控制器（`TickerProviderStateMixin`），透明度 `1-(1-staggered)*_intro.value` 让首帧全亮匹配原生、再缓入呼吸；② `Image.asset` 异步解码会让气泡首帧「弹出」，改在 `main()` 里 `rootBundle.load`+`ui.instantiateImageCodec` 预解码到 `splash_icon.dart` 的全局 `ui.Image`，splash 用 `RawImage` 渲染。
- **检查更新**（`core/network/update_checker.dart`）：`checkForUpdate()` 请求 `https://api.github.com/repos/{AppConfig.githubRepo}/releases/latest`（`AppConfig.githubRepo='99cz99/paracosm'`，GitHub API 要带 `User-Agent` 头），解析 `tag_name` 去 `v` 前缀，和本地 `PackageInfo.version` **语义化对比**。「我」→「检查更新」入口，有新版本弹窗 + `url_launcher` 跳 release 页。「自动更新」已取消——只提示，不下载不安装。
- **占位符替换**（`core/utils/prompt_template.dart` 的 `applyPlaceholders(text, charName, userName)`）：把 `{{char}}`/`{{user}}`（含大小写变体）替换成角色名/用户名。用户名存 `Settings` 表 `user_name`（默认「我」，「我」页「我的名字」可改）。替换点：单聊 `chat_controller._buildSections` 构建完 sections 后**统一替换**（覆盖人设/记忆/世界书）；群聊/剧情在 `_persona` 里替换、**世界书 section 也走 `applyPlaceholders`**（群聊 `{{char}}` 多角色无单义置空、剧情用 story 角色）；**开场白**在 `SessionRepository._firstMessage`/`getGreetings` 里替换（否则首条消息显示 `{{char}}` 字面量）。
- **实体导出/导入**（分享用，复制 JSON 方式）：世界书导出 `core/import/worldbook_exporter.dart`（SillyTavern lorebook JSON `{name, description, entries}`）；世界导出/导入 `features/worlds/data/world_exporter.dart`（`exportWorldJson`/`parseWorldJson`，导入时 id 重新生成）；会话导出 `features/chat/data/session_exporter.dart`。导出统一「弹窗显示 JSON + 复制」，导入用 `FilePicker.pickFiles` 或**粘贴 JSON**（世界/世界书支持，`core/utils/dialogs.dart` 的 `showPasteTextDialog` + 底部弹窗二选一；世界书走 `WorldbookRepository.importFromJson`）。入口：世界书编辑页 AppBar「导出」、世界详情页 AppBar「导出+导入」、聊天页「更多」菜单「导出会话」。
- **流式气泡局部重建（性能）**：`ChatScreen.build` **别 `select` 流式文本**（每次 delta 变化会重建整个屏幕）。只 `select((s) => s.isGenerating(sessionId))` 决定气泡显隐，把流式气泡抽成独立 `_StreamingBubble`（内部 `select((s) => s.streams[sessionId]?.text)`），逐字更新只重建这个小气泡。`_StreamingBubble` 里要「已持久化」防抖（`streamingText.isNotEmpty && == 最后一条消息` 时隐藏），空文字要显示思考中转圈（`MessageBubble(isStreaming && content.isEmpty)`）。
- **气泡 Markdown/富文本**（`core/widgets/markdown_text.dart`）：用户+助手气泡用 `MarkdownSelectableText`（`SelectableText.rich` + 纯 Dart `markdown` 包解析 → TextSpan），支持 `**加粗**`/`*斜体*`/`` `行内代码` ``/``` 代码块 ```/列表/标题/删除线/链接（着色不跳转）。**必须走 `SelectableText.rich`**（保住选中/复制/撤回 `contextMenuBuilder`），不能用 `MarkdownBody`（不可选中、丢撤回）。代码块用 `WidgetSpan` 包圆角灰底 `Container` + 内层 `SelectableText`（块内可复制）；`encodeHtml: false`（否则代码里 `"` 变 `&quot;`）；整段 ````markdown/```md 单 fence 会解包重按 Markdown 渲染（助手习惯把回答包进 fence）。流式半截 `*`/`**` 先按字面量显示、闭合后生效；系统/命令消息（`_buildSystem`）保持纯文本。
- **群聊自动发言规则**（schema v18，`Groups.autoSpeakJson` JSON 数组）：每条规则 `{id, pattern(正则), characterId, delay(秒), probability(0-100), enabled}`。`group_chat_controller.dart` 抽出 `_runAssistantTurn`（用户回合与自动发言共用流式核心）；回合完成后 `_evaluateAutoSpeak`（`AutoSpeakRules.evaluate` 纯函数匹配正则+概率 → `Timer(delay)` → `_autoSpeak` 强制指定角色发言）。**用户和 AI 后都触发**（链式），连续自动发言深度上限 `_maxAutoSpeakDepth=3`；`state.isGenerating` 或群已删则跳过；用户发新消息 `_cancelAutoSpeakTimers()` 取消待触发。规则 UI 在群信息页「自动发言规则」区块。
- **带配图角色卡**（schema v19 `Characters.imageGalleryJson`）：导入时提取卡片配图——**头像**：PNG 卡（`_parseBytes` `withAvatar`，PNG 即立绘）/ V3 `assets` 的 `icon` / JSON `image` base64 / Skill 的 `avatar.*`；**图库**：V3 `assets` 的 `emotion`/`background`、`extensions.risuai.additionalAssets`（`[name, base64WebP]`）、`extensions.chub.expressions`、Skill ZIP 图片（文件名当 name）。图存 `documents/character_images/<id>/`（`resizeImage` 等比缩 512 剥元数据），清单存 `imageGalleryJson`（`[{name,path}]`）。**渲染**（`message_bubble.dart`）：`<img="名字">` → 图库本地图；SillyTavern **regex_scripts**（存 `core['regex_scripts']`，`applyRegexScripts` 做 JS 正则 `/p/flags` + `$1` 反向引用）把 `<CG{代码}>` 等转成 HTML——`<img src=url>` 用 `Image.network`、含 HTML 时整段走 `_HtmlView`（`HtmlWidget`，`buildAsync:false` 同步构建 + `_sanitizeHtml` 六步预处理：剥 style/script、扁平化 details/summary、剥 body、markdown 加粗、去引用符、中和溢出 CSS——`display:flex→block`、剥 `height`/`max-width`/`gap`、`position:absolute→static`，否则面板固定尺寸溢出 320px 气泡）。`CharacterExporter` 导出时过滤 `regex_scripts`/`imageGalleryJson` 等内部 key。
- **regex_scripts 标志位**（`core/utils/regex_scripts.dart`）：`applyRegexScripts` 只套显示内容，必须跳过 `disabled:true` 和 `promptOnly:true` 的脚本。忽略 `promptOnly` 会把「删除<TTL>」这类 prompt-only 删除脚本套到显示上，落库补全 `</TTL>` 时删掉包裹状态栏/微信面板的 `<TTL>` 块 → **面板整块消失**（1.17.20 修，`regex_scripts_test.dart` 有回归用例）。

- **外观颜色（全局 + 每会话）**（schema v20/v21）：`Sessions` 加 `bubbleUserColor`/`bubbleAssistantColor`/`userTextColor`/`assistantTextColor`（hex，null=用全局），全局存 Settings 键 `chat_user_bubble_color` 等。`chatColorsProvider`（`chat_providers.dart`）按「会话列 → 全局 → null」解析成 `ChatColors`；`MessageBubble` 加 `bubbleColor`/`textColor` 参数（null 回落主题 `primaryContainer`/`surfaceContainerHighest`）。选色用 `core/widgets/color_field.dart` 的 `ColorRow`（点行弹 `showColorPicker` 底部色板：预设色块 + `#RRGGBB` hex 输入 + 默认）。
- **附件上传**（`ChatController.sendAttachments`）：聊天输入框 📎 → `FilePicker.pickFiles(type: any)` → 拷到 `documents/chat_attachments/<uuid><ext>` → 暂存 `_pending` chip → 用户输入要求后一起发。图片落 `type:'image'`（`_buildRequest` 读文件 `base64Encode` 转 `ChatMessage.images` 多模态发给模型识图）；文本文件（`_readTextFile`，`_textExtensions` 白名单 + 含 null 字节判二进制）读内容落用户消息；不可读文件落「收到文件 name」note 触发回复。文件卡片 `_buildFile`（图标+文件名），附件按 `role` 右对齐（用户侧）。
- **消息内联文字色**：`markdown_text.dart` 的 `_inlineSpans`/`_colorizeText` 识别 `<font color="X">`/`<span style="color:X">`（hex + 常见命名色，`_colorTag`）；`message_bubble.dart` 的 `_stripHtmlKeepColor` 剥其他 HTML 但保留 font/span 颜色标签。
- **自动续写**：`sendMessage`/`_runReply` 流式循环里，`finishReason=='length'`（maxTokens 截断）且 buffer 非空时，把已生成段 +「继续输出，直接接上文，不要重复」喂回重发，上限 5 段；token 跨段累加。

## ⚠️ 已知问题（重要）

1. **native assets 上游 bug**：`objective_c 9.6.x` + `native_toolchain_c 0.19.4` 的构建钩子引用了 `Architecture.arm64e`，但已发布的 `code_assets 2.0.0` 没有该枚举，导致 `flutter test` 报 `Member not found: 'arm64e'`。已在 `pubspec.yaml` 用 `dependency_overrides` 降级到 `objective_c: 9.5.0` + `native_toolchain_c: 0.19.3`（code_assets 1.x）。**不要轻易 `pub upgrade` 移除这两个 override**，会再次踩坑。
2. **中国网络**：pub.dev / Gradle / SDK 都走镜像。Flutter 每次命令的 `git fetch --tags` 会失败（连不上 github），无害，可加 `--no-version-check` 略过。
3. **盘符**：C 盘只剩 ~14GB，Flutter/Android/JDK/AVD 都在 E 盘，别往 C 盘装大件。
4. **模拟器起不来**：`pixel7` 是 x86_64 镜像，报 `x86_64 emulation currently requires hardware acceleration`（WHPX/Hyper-V/HAXM 未启用或 BIOS VT-x 关）。命令行改不了，需在 Windows 功能里开「虚拟机平台/Windows 虚拟机监控程序平台」或 BIOS 开 VT-x。实体手机 `10AD6C018M0014Q` 可用。
5. **`flutter run` 流式安装偶发卡死**：卡在 `Installing...` 不动（还把包装坏、launcher activity 丢失）。改用 `flutter build apk --debug` + `adb install -r` + `adb shell am start` 分步执行（见常用命令）。
6. **flutter_background_service 通知渠道**：`AndroidConfiguration` 别传自定义 `notificationChannelId`——插件只在传 `null` 时才自动建 `FOREGROUND_DEFAULT` 渠道；传了自定义却没建渠道会 `Bad notification for startForeground` 崩溃。
7. **前台服务要后台才起**：发送时 `startService()` 会新起后台 Flutter engine/isolate、卡 UI；用 `didChangeAppLifecycleState(paused)` 才起（见关键设计）。
8. **聊天列表用 `reverse: true`**：别改 `reverse: false` + ScrollController——懒加载 + 气泡高度不一，`jumpTo(maxScrollExtent)` 在打开那一刻不可靠，会停在顶部要手动滑。
9. **别跑 `flutter clean`（会清掉 sqlite3 原生资产、重建连不上 GitHub）**：`sqlite3` 包的 native assets 钩子要从 GitHub 下载预编译 `.so`（`github.com/simolus3/sqlite3.dart/releases`），中国网络连不上 github。`flutter clean` 删掉 `.dart_tool/hooks_runner/shared/sqlite3/build/download-<hash 前8位>/libsqlite3.so` 缓存后，重建就报 `Building assets for package:sqlite3 failed`（SocketException timeout）。恢复：用 GitHub 代理 `https://gh-proxy.com/https://github.com/...` 下回 3 个 ABI 的 `.so`（arm/arm64/x64 的 sha256 见 `sqlite3` 包 `lib/src/hook/asset_hashes.dart`），按 `download-<hash 前8位>` 放回上面缓存目录即可。另外，`pubspec.yaml` 里 `assets/` 目录声明**不包含子目录**——新增 `assets/xxx/` 子目录要显式加 `- assets/xxx/`（如 `assets/assistant_avatars/`），否则打不进包。
10. **HTML 面板渲染的已知限制**：regex_scripts 产出的面板（微信/论坛/状态栏）由 core 版 `HtmlWidget` 渲染，**非像素级还原**——core 包不支持 `<svg>` 图标（论坛面板的点赞/转发图标显示为空，装饰性）、面板为「响应式堆叠」而非原 flex 布局；远程图 `files.catbox.moe` 在国内 **SSL 握手失败**加载不出（网络问题，非代码 bug，后续方向=导入时离线缓存远程图）。
11. **PDF 渲染成图走不通**：`pdf_render` 用旧 v1 插件 API（`Registrar`）与 Flutter 3.47 不兼容（`Unresolved reference 'Registrar'`）；`pdfrx` 构建时从 github.com 下载 pdfium（同 sqlite3 原生资产坑，见上面第 9 条）。当前上传 PDF 只显示文件卡片、不读内容；要支持需离线缓存 pdfium 或换直接收 PDF 的多模态 API。

## 当前进度

已实现：酒馆卡导入（PNG/JSON，V1/V2/V3）、Skill 导入（ZIP/Markdown，含 affinity.json 三轴 / research 世界书 / sources 原文）、联系人列表/详情/编辑（含头像、标签）、角色导出（SillyTavern V2 JSON）、异世界 CRUD、角色 core+adaptation 三层解耦、选世界进会话、单聊 SSE 流式（后台中断保部分回复）、消息持久化+长按复制、Provider 配置+测试连接+点选切换、记忆系统（状态/关系抽取、滚动摘要、世界书关键词注入）、Skill 成长系统（单聊每轮三轴回写）、群聊（多角色+三种模式+角色对关系）、剧情模式（AI 生成+分支树+回退+存档）、搜索（角色/消息）、数据备份/恢复（含 providerConfigs，API key 不存）、头像裁剪、群信息页（成员增删/改名/换头像/解散）、开场白自动发出+聊天内 ←/🎲/→ 切换（用户回复后隐藏）、英文开场白翻译缓存、WeChat 式角色详情页（卡片分区、长文本折叠、世界书/原文两级折叠）、聊天列表真实角色/群头像、聊天页查看角色详情（点标题/头像/… 菜单）、消息撤回（长按选中菜单）、世界绑定/解绑 + 全新开始、记忆按「角色×世界」隔离（关系 + Skill 成长）、一个「角色×世界」一个会话（新单聊复用）、聊天列表显示世界名、世界级记忆（`CharacterMemories` 状态/摘要按角色×世界隔离，删会话即删除）、每会话 API + 采样参数（温度/maxTokens/penalty）+ 采样预设、群聊独立记忆（状态/摘要，与单聊隔离）、剧情分支（重新生成/复用分支/结局/树状图节点编辑删除）、后台继续回复（前台服务保活）、参数标签英文+简介、世界适配折叠+说明、世界书独立库（JSON/Markdown/zip 导入 + 手动编辑 + 绑定到角色/世界/群聊/剧情）、群聊/剧情多世界绑定（`GroupWorlds`/`StoryWorlds`）、群聊/剧情注入世界规则+初始状态+世界书、角色完整人设编辑（system_prompt/mes_example/备注/昵称/后置指令）+ 聊天页「编辑人设」快捷入口、自定义角色创建（sourceType=manual）、批量导入、聊天列表世界标签（单聊+群聊）、联系人首字母拼音排序（lpinyin）+ 置顶 + 右侧 A-Z 索引条、改名 Paracosm + 包名 `com.paracosm.app`（原 mj）+ 像素风启动图标、备份补齐（`Presets`/`Settings`/`GroupMemories` 三表 + `Characters.pinnedAt` + 会话/群的采样列）、斜杠指令（`/status` `/relation` `/summary` `/lore` `/mode` `/help`，单聊+群聊）、token 估算 + 上下文窗口上限、会话级世界书选择（`Sessions.worldbookIdsJson`）、跨语言世界书触发（关键词英→中翻译）、头像懒加载/缩略图/保存压缩（含旧大图迁移）、启动画面（品牌紫背景 + 无背景对话框图标 + Android 12 splash 修复）、检查更新（GitHub Releases 版本对比 + 提示跳转）、占位符 `{{user}}`/`{{char}}` 替换（含用户名设置）、世界书/世界/会话导出导入、流式气泡局部重建优化、群聊创建角色拼音排序、世界适配编辑按钮。

本轮新增：摘要可靠性（短会话生成 / 空摘要不丢记忆 / 记忆用会话 provider）、单聊并发流（每会话独立流式、切页不打断）、世界/世界书粘贴 JSON 导入、会话累计 token 消耗（真实 usage + 面板显示，schema v15 加 `Sessions` token 列）、上下文硬裁剪、用户消息处理默认指令 + `post_history_instructions` 注入、角色认知维度（时间/空间/服装/身体/环境/物品/关系/人称/视角）、省 token/缓存（Anthropic `cache_control` + 开场白去冗余 + 世界书去重）、四个 AI 助手 + 制作规范 + 使用手册（schema v16 加 `Characters.builtInKey`）、启动页三点动画（`strip_splash_dots.py` 去点脚本 + intro 淡入 + 图标预解码）。

助手完善：内置头像（`assets/assistant_avatars/` + seed 回填 `avatarPath`）、助手结果一键导入（`importable_detector.dart` + 消息下「导入」按钮）、修正「酒馆」措辞 + 补全助手格式（内置 prompt 权威回写）。

本轮新增（v1.16）：角色年龄字段（虚拟/真实年龄，schema v17，注入【年龄】段）、世界书「测试触发」预览 + 副标题改词条数 + 关键词分隔符支持顿号、异世界导入入口合并为「+」菜单、搜索消息结果带角色名（导航 push→go 修 GlobalKey 冲突）、助手优化（逐个设计/不急着吐 JSON/开场白说明用法）、/summary 修复（不再回退 /status 状态）、剧情完善（存档管理重命名删除、多根节点/编辑子分支/读档悬空校验、长剧情上下文截断）、群聊 bug 修复（nextGroupOrderIndex 改 max+1、删角色清 PairRelations 孤儿、turn 轮换改 lastSpeakerId、世界/世界书编辑竞态、sendMessage 先判群存在）、群聊性能（群级 provider 贯穿记忆/关系抽取、角色对关系节流+transcript 截断、建群去重 N+1→聚合查询、群摘要 maxTokens 2048）。

本轮新增（v1.17）：记忆抽取重构——状态+关系/成长合并成 `_extractMemory` 一次 LLM 调用（省一半调用）、记忆抽取 `maxTokens=16384`（推理模型思考不再耗尽）、摘要筛掉命令消息（`visibleToAi`）、`resolveProvider` 包 try、记忆年龄上下文（`_ageContext` 注入 realAge/virtualAge + NPC 成年声明，`_looksLikeRefusal` 丢弃安全拒绝文案、旧拒绝按空覆盖）、回退命令 await（`/status` `/relation` `/summary` 直接读库秒回）、建议「记忆模型」设 deepseek-chat 降本提速。

本轮新增（1.17.6–1.17.12）：气泡 Markdown/富文本渲染（`markdown` 包 → `SelectableText.rich`，代码块圆角灰底、```markdown 单 fence 解包）、世界书匹配增强（正则/大小写/次要关键词/selective AND/递归+深度/priority 排序/`{{random}}` + 群聊剧情世界书补 `{{char}}`/`{{user}}`）、群聊自动发言规则（schema v18，正则触发+延迟+概率、链式深度上限 3）。

本轮新增（1.17.13–1.17.17）：带配图角色卡——头像提取（PNG 卡/V3 assets icon/JSON image/Skill avatar）+ 角色图库（schema v19 `imageGalleryJson`，V3 assets emotion/background + risuai.additionalAssets + chub.expressions + Skill 图）+ `<img="名字">` 内嵌图渲染 + SillyTavern regex_scripts（`applyRegexScripts` JS 正则→Dart、`$1` 反向引用）+ `<CG>` 远程图（`Image.network`）+ HTML 完整渲染（`flutter_widget_from_html_core` 的 `HtmlWidget`，对话框/论坛/微信气泡/状态面板全显示）。

本轮新增（1.17.20）：修复带配图角色卡「面板消失」——真根因是 `applyRegexScripts` 忽略 SillyTavern 脚本的 `promptOnly`/`disabled` 标志，prompt-only 删除脚本「删除<TTL>」在落库时删掉了包裹状态栏/微信面板的 `<TTL>` 块；已跳过这两类脚本。同步：HTML 渲染从 WebView（reverse:true 列表条纹/空白被弃用）换成 `flutter_widget_from_html_core` 的 `HtmlWidget`（`buildAsync:false` + `_sanitizeHtml` 中和溢出 CSS）。

本轮新增（1.17.21）：世界书「深度分层」+ 嵌套字段解析——`WorldbookParser` 读条目 `extensions` 子对象（`case_sensitive`/`match_whole_words`/`exclude_recursion`/`probability`/`group`/`priority`）并新增 `depth` 字段，`WorldbookMatcher` 加 `depth` 门控（`constant=true` 的常驻条目也按聊天深度逐步解锁，单聊/群聊/剧情三处注入点传消息总数）；regex prompt 侧清理——`applyRegexScripts`（显示）加 `role` 按 `placement`（1=用户输入/2=AI 输出）区分消息来源，新增 `applyPromptRegexScripts` 在 `_buildRequest` 对历史消息按 `minDepth`/`maxDepth` 门控剥离旧 AI 输出里的 `<TTL>` 块。⚠️ 已导入的卡需**重新导入**才带上 `depth`（parser 只在导入时跑）。

本轮新增（1.17.22–1.17.24）：HTML 面板渲染三连——① **粉色对话框 CSS 内联**（`core/utils/html_sanitize.dart` 抽出 `sanitizeHtml`：把 `<style>` 类 CSS 内联到 `class` 元素、渐变降级为末尾 `#hex` 纯色、`flex`→`block`/`position`→`static`、丢弃 width/height/gap/box-shadow 等溢出属性）；② **显示侧 minDepth 门控**（`applyRegexScripts` 加 `depth`，「微信删除」只删 ≥4 层的旧消息、保留最近 4 条；`chat_screen` 按 `reversed` 下标传 depth）；③ **面板可折叠**（去掉 `sanitizeHtml` 里 `<details>`/`<summary>` 的摊平，`flutter_widget_from_html_core` 原生渲染成折叠面板、默认折叠点标题展开）。顺带修了 markdown 加粗 `**x**`→`<b>` 用 `replaceAll` 的 `$1` 不生效 bug（改 `replaceAllMapped`）。

本轮新增（1.17.25–1.17.28）：P0 三 bug——联系人名字/标签溢出（title 加 `maxLines:1`+ellipsis）、剧情选角色按拼音排序（复用群聊 `pinyinInitial`）、助手世界规则空白（`parseWorldJson` 归一化纯字符串为 `{"text":…}`）；P2 快速 UI——AppBar「转到最早」按钮、多个开场白折叠成「备选开场白（N）」、HTML 面板改 `SelectionArea` 支持拖动选中/复制/撤回、输入框 `maxLines` 4→8、助手回复到 `maxTokens` 自动续写（`finishReason=='length'` 时把已生成段 +「继续」喂回，上限 5 段）。

本轮新增（1.17.29–1.17.32）：翻译进度 + 后台翻译（`translation_controller.dart` 全局非 autoDispose，详情页非阻塞进度条）；外观颜色（用户/角色气泡色 + 用户/角色文本色，全局「我」页 + 每会话，schema v20/v21，`ColorRow`+`showColorPicker` hex 输入）；消息内联文字色（`markdown_text.dart` 的 `_colorizeText` 处理 `<font color>`/`<span style=color>`）。

本轮新增（1.17.33–1.17.36）：聊天上传附件（📎 选图/文件 → 暂存 chip → 输入要求再发）；图片走多模态 `ChatMessage.images` 发给模型识图、文本文件读内容发角色、其他文件显示文件卡片 + 发「收到文件」；PDF 渲染成图未做（见已知问题）。

本轮新增（1.17.37–1.17.38）：助手出卡完成后「为这张卡配图？」弹窗（#19，多选图作封面/头像/图库，修时序竞态——drift watch 送达滞后时短暂重试）；角色卡导出为 PNG 下载/分享（#13，`PngCardWriter` 写 `chara` tEXt chunk + `share_plus`）；HTML 卡创作提示（#16，assistant prompt + `html_sanitize.dart` 抽出 `sanitizeHtml` 供气泡渲染复用）。

未实现（后续阶段）：向量召回、FTS5 全文索引、WorkManager 定时后台任务、故障转移（多 Provider 自动切换）。
