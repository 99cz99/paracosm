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
- **Skill 成长系统**：带 `core['affinity']`（skill 的三轴成长种子：信任/堕落度/H场景）的角色走 skill 自带数值规则。每轮**单聊**回复后 `MemoryService._reflectSkillGrowth` 把当前 affinity + 最近 12 条对话交给记忆模型，产出更新后 JSON，`sanitizeAffinity` clamp 后写回 **`CharacterAffinities` 表**（按角色×世界，`core['affinity']` 只留作种子不再回写）。⚠️ **别把整段 `core['system_prompt']` 塞进回写 prompt**（skill 系统提示可能几万字，会爆记忆模型上下文、导致返回空/非 JSON）。**只在单聊触发**（群聊/剧情不走）；LLM 驱动、尽力而为（失败静默保旧值）。
- **每会话 API + 采样参数 + 预设**：`Sessions` 增列 `providerId`/`temperature`/`topP`/`maxTokens`/`presencePenalty`/`frequencyPenalty`（null=用默认 1.2 / 1.0 / 4096 / 无）。`resolveProvider(db, store, providerId:)` 按会话指定 provider，查不到回落默认。`Presets` 表存命名采样参数包，聊天页「会话设置」可套用；「我」→「采样预设」管理。presence/frequency penalty 只对 OpenAI 兼容 provider 生效（Anthropic 忽略）。
- **群聊记忆开关**：`Groups.memoryEnabled`（默认开）。群信息页「代入角色记忆」开关；开启时 `group_service.dart` 给每个成员注入其在该世界的记忆（状态/摘要/关系/成长），关闭只注入 core 人设 + 角色对关系。
- **剧情分支**（`features/story/`）：`StoryNodes` 树（子节点存 `chosenIndex`）。选择时先 `getChildByChosenIndex` 复用已生成分支，未命中才生成；「重来」`regenerateNode` 覆盖当前节点并删其子树；`choices` 空数组=结局；分支树可点跳/编辑/删除（`deleteStoryNodeSubtree` 递归删）。
- **后台继续回复**（`core/background/reply_background.dart` + `main.dart`）：`flutter_background_service` 前台服务保活。**不在发送时起服务**（新起后台 engine 会卡 UI），改为 `ChatController.didChangeAppLifecycleState`：`paused` 且 `isGenerating` 时才 `startReplyForeground()`，`resumed` 停止。`chat_screen.dispose` **不 cancel**（全局控制器继续跑，`sendMessage` 落库前已判会话存在）。
- **⚠️ 弹窗导航陷阱（最重要）**：`showDialog` 默认 `useRootNavigator: true`，会把弹窗推到 go_router 的**根 Navigator**，与 `StatefulShellRoute` 的**分支 Navigator** 冲突——弹窗关闭后根 Navigator 状态错乱，直接黑屏（删会话/新单聊/删剧情都踩过）。**所有弹窗必须传 `useRootNavigator: false`**，且按钮要用 builder 传入的 `dialogContext` 调 `Navigator.of(dialogContext).pop()`，不能用外层屏幕的 `context`。`showModalBottomSheet` 默认 `useRootNavigator: false`，选列表类弹窗优先用它。提示一律弹窗（`core/utils/dialogs.dart`），不用聊天气泡/snackbar。
- **聊天/群聊控制器是全局 `NotifierProvider`**（`chatControllerProvider`/`groupChatControllerProvider`，非 autoDispose）：离开页面后流式回复仍在跑。回复落库前要检查会话/群是否还存在（`getSession`/`getGroup`），否则删会话/群后仍写库会撞外键约束崩溃黑屏。
- **流式会话归属**：全局控制器同一时刻只有一个流，`ChatUiState.streamingSessionId` / `GroupChatUiState.streamingGroupId` 记录当前流式属于哪个会话/群；聊天/群聊页只在「流式属于当前」时才渲染流式气泡（否则 A 流式时打开 B，会把 A 的流式气泡串到 B）。
- **后台中断兜底**：`sendMessage` 的 catch 里若 buffer 非空（流式中途被打断，如切后台网络断开）就落库保存**部分回复**、静默停止；一个字都没生成才 rethrow 报错。
- **角色数据响应性**：`chatCharacterProvider` 是 `StreamProvider`（`db.watchCharacter(id)`），改头像/名字即时刷新聊天页；详情页的 `characterProvider` 仍是 FutureProvider，改动后要 `ref.invalidate(characterProvider(id))` 才刷新。
- **会话复用（一个「角色 × 世界」一个会话）**：联系人「开始聊天」和聊天列表「新单聊」都走 `SessionRepository.getOrCreateSession`（按角色+世界复用已有会话，不再无脑新建）；只有「全新开始」才删旧会话重建。
- **消息撤回**：长按消息 → 原生选中工具条（`SelectableText.contextMenuBuilder` + `AdaptiveTextSelectionToolbar`）追加「撤回」项，硬删除 `deleteMessage`。因此 `nextOrderIndex` 用 `orderIndex.max()+1` 而非 `count()`，删中间消息不会让下一条插入撞号。
- **世界适配绑定/解绑**：角色详情「世界适配」卡片可绑定（`_bindWorld`，已绑定世界不重复列出）/编辑 persona/解绑（`link_off` 图标，删适配行不动会话）。解绑后聊天时 `getAdaptation` 返回 null → 不注入该世界适配人设，世界规则仍按会话 worldId 注入。
- **全新开始**：角色已有该「角色×世界」的关系记忆时，开聊前弹「继续 / 全新开始」。全新开始 = 清空该世界关系（`resetCharacterRelation`）+ 删旧会话重建。
- **开场白与翻译缓存**：`SessionRepository.getGreetings()` 返回开场白列表，优先读 `core['greetings_zh']`（中文缓存），否则 `first_mes` + 去重后的 `alternate_greetings`。`createSession` 用缓存中文 `first_mes` 作首条消息。聊天页 AppBar 的 ←/🎲/→（用户回复后隐藏）通过 `db.replaceOpeningMessage`（替换 orderIndex 0）切换开场白。角色详情页「翻译开场白」按钮用 `core/network/llm/translator.dart` **逐条翻译**（`maxTokens: 8192`——2048 会让长开场白截断回退英文；翻译后校验、仍是英文就重试；显示进度；保留原文段落/换行/`{{char}}`/`*动作*` 格式），结果存 `core['greetings_zh']`。翻译无独立模型配置，走默认 provider。
- **`core` 内部字段约定**：`core['affinity']`（skill 成长态）、`core['greetings_zh']`（开场白中文缓存）是 App 内部字段，不属于 SillyTavern persona；`CharacterExporter` 导出时需过滤（已过滤 `affinity`，`greetings_zh` 同理）。
- **角色导入管线**：`CharacterRepository._parseBytes` 按扩展名分发——PNG（tEXt chunk）/JSON 走 `StCardParser`（V1/V2/V3），ZIP/MD 走 `SkillImporter`，统一产出 `ImportedCharacter`，再由 `importCharacter` 落库为 `Characters`（core + 内置 `worldbookJson`）+ 默认 `CharacterAdaptations`（worldId=''）。Skill 的 ZIP 是个文件夹：优先找 JSON 角色卡，否则读根目录 `SKILL.md` 的 frontmatter（`name` + `description`，支持 YAML 块标量 `|`），**正文捕获为 `core['system_prompt']`**。此外 `SkillImporter` 还会解析：`references/affinity.json` → `core['affinity']`；`references/research/*.md` + `quality-validation.md` → 世界书条目（`worldbook.entries`，关键词注入）；`references/sources/**`（game_text）→ `worldbook.sources`（详情页展示用，**不注入**）。`sourceType` 取值 `sillytavern`/`skill`/`manual`，ZIP/MD 记为 `skill`。
- **世界书注入统一**（`core/world/world_context.dart`）：`WorldbookMatcher`（纯关键词匹配，抽自 `MemoryService`）+ `WorldContextBuilder`（`build(worldIds, worldbookIds)` 把实体绑定的世界书并入各世界绑定的世界书）。单聊注入「角色内置世界书 + 角色绑定的共享世界书 + 世界绑定的世界书」并集；群聊/剧情注入「群/剧情绑定的共享世界书 + 世界绑定的世界书」。世界书条目字段：`comment`（名称，UI 展示）+ `keys`（触发关键词数组）+ `content`；`WorldbookParser` 保留 `priority`/`position` 等元数据，世界书编辑页保存时用 `...original` 保留这些字段（别只写 keys/content 丢元数据）。
- **角色创建/编辑/热修改**：`CharacterEditScreen` 的 `characterId` 可空，新建（`CharacterRepository.createCharacter`，`sourceType='manual'`）/编辑共用一屏，字段含 system_prompt/mes_example/creator_notes/nickname/post_history_instructions。聊天页 `…` 菜单「编辑人设」→ `/contacts/:id/edit`；`_buildRequest` 每轮 `getCharacter` 重读 core，改完**下一条消息即生效**（无需刷新 provider）。
- **批量导入**：file_picker 13 的 `FilePicker.pickFiles(...)` 返回 `List<PlatformFile>`（**本就多选，无 `allowMultiple` 参数**），`FilePicker.pickFile` 返回单个 `PlatformFile?`。导入页遍历全部文件、汇总成功/失败数。
- **联系人列表排序 + 置顶**：`Characters.pinnedAt`（null=未置顶）。列表按「置顶区(pinnedAt 倒序) + 拼音首字母分组 A-Z/#」排序，右侧 A-Z 索引条（`Scrollable.ensureVisible` 跳分组）。中文首字母用 `lpinyin`（`core/utils/pinyin.dart` 的 `pinyinInitial`：英文→大写首字母，中文→拼音首字母，数字/符号→#）。置顶/删除走长按底部菜单（`showModalBottomSheet`）。
- **斜杠指令**（`core/commands/slash_commands.dart`）：聊天框 `/` 指令，回复作为 `command_reply` 消息落库。单聊 `executeCommand`：`/status`（结构化状态）/`/relation`（关系或 skill affinity）/`/summary`（滚动摘要）/`/lore`（世界书名称）/`/help`；群聊 `executeGroupCommand`：`/status`（群状态）/`/relation`（所有成员关系）/`/summary`（群摘要）/`/lore`（群绑定世界书）/`/mode`（切 auto/turn/call，`rotate`/`mention` 是别名）/`/help`。加新指令 = `allSlashCommands` 加一条 + 对应 `execute*Command` 加 case。
- **Token 估算**（`core/network/llm/token_estimator.dart`）：无真实 tokenizer，启发式估算（CJK/全角 ≈ 1 token，ASCII ≈ 4 字符/token），UI 一律标「估算」。`ProviderConfigs.contextWindowLimit`（token 数，null=默认 32000）当上下文窗口上限，用于实时 token 显示。
- **会话级世界书选择**：`Sessions.worldbookIdsJson`（JSON 数组）覆盖该会话注入的共享世界书，null = 回退角色绑定默认（`CharacterWorldbooks`）；`/lore` 与 `WorldContextBuilder.build` 均读它。
- **跨语言世界书触发**：世界书匹配是纯字符串，英文关键词配中文消息匹配不上。`translator.dart` 的 `translateKeys` 批量把英文关键词翻成中文、追加进条目 `keys`（正文不翻）；入口是世界书编辑页「翻译关键词（英→中）」和角色详情页「翻译世界书关键词为中文」按钮。

## ⚠️ 已知问题（重要）

1. **native assets 上游 bug**：`objective_c 9.6.x` + `native_toolchain_c 0.19.4` 的构建钩子引用了 `Architecture.arm64e`，但已发布的 `code_assets 2.0.0` 没有该枚举，导致 `flutter test` 报 `Member not found: 'arm64e'`。已在 `pubspec.yaml` 用 `dependency_overrides` 降级到 `objective_c: 9.5.0` + `native_toolchain_c: 0.19.3`（code_assets 1.x）。**不要轻易 `pub upgrade` 移除这两个 override**，会再次踩坑。
2. **中国网络**：pub.dev / Gradle / SDK 都走镜像。Flutter 每次命令的 `git fetch --tags` 会失败（连不上 github），无害，可加 `--no-version-check` 略过。
3. **盘符**：C 盘只剩 ~14GB，Flutter/Android/JDK/AVD 都在 E 盘，别往 C 盘装大件。
4. **模拟器起不来**：`pixel7` 是 x86_64 镜像，报 `x86_64 emulation currently requires hardware acceleration`（WHPX/Hyper-V/HAXM 未启用或 BIOS VT-x 关）。命令行改不了，需在 Windows 功能里开「虚拟机平台/Windows 虚拟机监控程序平台」或 BIOS 开 VT-x。实体手机 `10AD6C018M0014Q` 可用。
5. **`flutter run` 流式安装偶发卡死**：卡在 `Installing...` 不动（还把包装坏、launcher activity 丢失）。改用 `flutter build apk --debug` + `adb install -r` + `adb shell am start` 分步执行（见常用命令）。
6. **flutter_background_service 通知渠道**：`AndroidConfiguration` 别传自定义 `notificationChannelId`——插件只在传 `null` 时才自动建 `FOREGROUND_DEFAULT` 渠道；传了自定义却没建渠道会 `Bad notification for startForeground` 崩溃。
7. **前台服务要后台才起**：发送时 `startService()` 会新起后台 Flutter engine/isolate、卡 UI；用 `didChangeAppLifecycleState(paused)` 才起（见关键设计）。
8. **聊天列表用 `reverse: true`**：别改 `reverse: false` + ScrollController——懒加载 + 气泡高度不一，`jumpTo(maxScrollExtent)` 在打开那一刻不可靠，会停在顶部要手动滑。

## 当前进度

已实现：酒馆卡导入（PNG/JSON，V1/V2/V3）、Skill 导入（ZIP/Markdown，含 affinity.json 三轴 / research 世界书 / sources 原文）、联系人列表/详情/编辑（含头像、标签）、角色导出（SillyTavern V2 JSON）、异世界 CRUD、角色 core+adaptation 三层解耦、选世界进会话、单聊 SSE 流式（后台中断保部分回复）、消息持久化+长按复制、Provider 配置+测试连接+点选切换、记忆系统（状态/关系抽取、滚动摘要、世界书关键词注入）、Skill 成长系统（单聊每轮三轴回写）、群聊（多角色+三种模式+角色对关系）、剧情模式（AI 生成+分支树+回退+存档）、搜索（角色/消息）、数据备份/恢复（含 providerConfigs，API key 不存）、头像裁剪、群信息页（成员增删/改名/换头像/解散）、开场白自动发出+聊天内 ←/🎲/→ 切换（用户回复后隐藏）、英文开场白翻译缓存、WeChat 式角色详情页（卡片分区、长文本折叠、世界书/原文两级折叠）、聊天列表真实角色/群头像、聊天页查看角色详情（点标题/头像/… 菜单）、消息撤回（长按选中菜单）、世界绑定/解绑 + 全新开始、记忆按「角色×世界」隔离（关系 + Skill 成长）、一个「角色×世界」一个会话（新单聊复用）、聊天列表显示世界名、世界级记忆（`CharacterMemories` 状态/摘要按角色×世界隔离，删会话即删除）、每会话 API + 采样参数（温度/maxTokens/penalty）+ 采样预设、群聊独立记忆（状态/摘要，与单聊隔离）、剧情分支（重新生成/复用分支/结局/树状图节点编辑删除）、后台继续回复（前台服务保活）、参数标签英文+简介、世界适配折叠+说明、世界书独立库（JSON/Markdown/zip 导入 + 手动编辑 + 绑定到角色/世界/群聊/剧情）、群聊/剧情多世界绑定（`GroupWorlds`/`StoryWorlds`）、群聊/剧情注入世界规则+初始状态+世界书、角色完整人设编辑（system_prompt/mes_example/备注/昵称/后置指令）+ 聊天页「编辑人设」快捷入口、自定义角色创建（sourceType=manual）、批量导入、聊天列表世界标签（单聊+群聊）、联系人首字母拼音排序（lpinyin）+ 置顶 + 右侧 A-Z 索引条、改名 Paracosm + 包名 `com.paracosm.app`（原 mj）+ 像素风启动图标、备份补齐（`Presets`/`Settings`/`GroupMemories` 三表 + `Characters.pinnedAt` + 会话/群的采样列）、斜杠指令（`/status` `/relation` `/summary` `/lore` `/mode` `/help`，单聊+群聊）、token 估算 + 上下文窗口上限、会话级世界书选择（`Sessions.worldbookIdsJson`）、跨语言世界书触发（关键词英→中翻译）。

未实现（后续阶段）：向量召回、FTS5 全文索引、WorkManager 定时后台任务、故障转移（多 Provider 自动切换）。
