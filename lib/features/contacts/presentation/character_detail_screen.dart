import 'dart:convert';

import 'package:drift/drift.dart' hide Column;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../core/db/database.dart';
import '../../../core/import/character_exporter.dart';
import '../../../core/network/llm/provider_factory.dart';
import '../../../core/network/llm/translator.dart';
import '../../../core/providers/db_providers.dart';
import '../../../core/providers/llm_providers.dart';
import '../../../core/utils/dialogs.dart';
import '../../../core/utils/multi_select_sheet.dart';
import '../../chat/data/session_repository.dart';
import '../data/character_repository.dart';
import 'contacts_providers.dart';
import 'widgets/avatar_crop_screen.dart';
import 'widgets/character_avatar.dart';
import 'widgets/expandable_section.dart';

class CharacterDetailScreen extends ConsumerWidget {
  const CharacterDetailScreen({super.key, required this.characterId});

  final String characterId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final characterAsync = ref.watch(characterProvider(characterId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('角色详情'),
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share),
            tooltip: '导出',
            onPressed: () => _export(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: '编辑',
            onPressed: () => context.push('/contacts/$characterId/edit'),
          ),
        ],
      ),
      body: characterAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('加载失败：$e')),
        data: (character) {
          if (character == null) return const Center(child: Text('角色不存在'));
          return _build(context, ref, character);
        },
      ),
    );
  }

  Widget _build(BuildContext context, WidgetRef ref, Character c) {
    final core = _decode(c.corePersonaJson);
    final tags = _decodeTags(c.tags);

    final persona = <Widget>[
      ..._section(context, '角色设定', core['description']),
      ..._section(context, '性格', core['personality']),
      ..._section(context, '场景', core['scenario']),
      ..._section(context, '开场白', core['first_mes']),
      ..._section(context, '对话示例', core['mes_example']),
      ..._section(context, '系统提示', core['system_prompt']),
      ..._section(context, '备注', core['creator_notes']),
      ..._section(context, '昵称', core['nickname']),
      ..._section(context, '后置指令', core['post_history_instructions']),
      ..._sectionList(context, '备选开场白', core['alternate_greetings']),
    ];
    final reference = _buildReference(context, c);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Center(
          child: Column(
            children: [
              GestureDetector(
                onTap: () => _changeAvatar(context, ref, c),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CharacterAvatar(
                      name: c.name,
                      avatarPath: c.avatarPath,
                      radius: 52,
                    ),
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: const Icon(
                        Icons.camera_alt,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(c.name, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              if (tags.isNotEmpty)
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    for (final t in tags)
                      Chip(
                        label: Text(t),
                        visualDensity: VisualDensity.compact,
                      ),
                  ],
                ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        FilledButton.icon(
          onPressed: () => _startChat(context, ref),
          icon: const Icon(Icons.chat),
          label: const Text('开始聊天'),
        ),
        if (_hasEnglishGreetings(core)) ...[
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () => _translateGreetings(context, ref, c),
            icon: const Icon(Icons.translate),
            label: const Text('翻译开场白为中文'),
          ),
        ],
        if (_hasEnglishWorldbookKeys(c)) ...[
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () => _translateWorldbookKeys(context, ref, c),
            icon: const Icon(Icons.translate),
            label: const Text('翻译世界书关键词为中文'),
          ),
        ],
        const SizedBox(height: 20),
        Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0,
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          clipBehavior: Clip.antiAlias,
          child: ExpansionTile(
            leading:
                Icon(Icons.public, color: Theme.of(context).colorScheme.primary),
            title: Text('世界适配', style: Theme.of(context).textTheme.titleMedium),
            subtitle: const Text(
              '此角色在该世界中的语气/人设/关系设定（仅本角色单聊生效）；世界的背景/规则/开局状态在「异世界」里维护。',
              style: TextStyle(fontSize: 12),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: _buildAdaptations(context, ref),
              ),
            ],
          ),
        ),
        Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0,
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          clipBehavior: Clip.antiAlias,
          child: ExpansionTile(
            leading:
                Icon(Icons.menu_book, color: Theme.of(context).colorScheme.primary),
            title: Text('世界书', style: Theme.of(context).textTheme.titleMedium),
            subtitle: const Text(
              '绑定世界书（lorebook），命中关键词时注入上下文；也可在「异世界」里导入。',
              style: TextStyle(fontSize: 12),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: _buildWorldbooks(context, ref),
              ),
            ],
          ),
        ),
        if (persona.isNotEmpty)
          _sectionCard(
            context,
            title: '角色信息',
            icon: Icons.badge_outlined,
            children: persona,
          ),
        if (reference.isNotEmpty)
          _sectionCard(
            context,
            title: '参考资料',
            icon: Icons.menu_book_outlined,
            children: reference,
          ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => _delete(context, ref, c),
          icon: const Icon(Icons.delete_outline),
          label: const Text('删除角色'),
          style: OutlinedButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _sectionCard(
    BuildContext context, {
    required String title,
    IconData? icon,
    required List<Widget> children,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: scheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18, color: scheme.primary),
                  const SizedBox(width: 6),
                ],
                Text(title, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildAdaptations(BuildContext context, WidgetRef ref) {
    final async = ref.watch(adaptationsProvider(characterId));
    return async.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(8),
        child: CircularProgressIndicator(),
      ),
      error: (e, _) => Text('加载失败：$e'),
      data: (adaptations) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final a in adaptations)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(a.adaptation.worldId.isEmpty
                      ? Icons.person
                      : (a.worldName == null
                          ? Icons.help_outline
                          : Icons.public)),
                  title: Text(a.adaptation.worldId.isEmpty
                      ? '默认适配'
                      : (a.worldName ?? '已删除的世界')),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        tooltip: '编辑适配',
                        onPressed: () => _editAdaptation(context, ref, a),
                      ),
                      if (a.adaptation.worldId.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.link_off),
                          tooltip: '解绑世界',
                          onPressed: () => _unbindWorld(context, ref, a),
                        ),
                    ],
                  ),
                  onTap: () => _editAdaptation(context, ref, a),
                ),
                if (_persona(a.adaptation.adaptationJson).trim().isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                    child: ExpandableSection(
                      title: '',
                      text: _persona(a.adaptation.adaptationJson),
                    ),
                  ),
              ],
            ),
          TextButton.icon(
            onPressed: () => _bindWorld(context, ref),
            icon: const Icon(Icons.add),
            label: const Text('绑定世界'),
          ),
        ],
      ),
    );
  }

  Future<void> _editAdaptation(
    BuildContext context,
    WidgetRef ref,
    AdaptationWithWorld a,
  ) async {
    final controller = TextEditingController(text: _persona(a.adaptation.adaptationJson));
    final ok = await showDialog<bool>(
      context: context,
      useRootNavigator: false,
      builder: (dialogContext) => AlertDialog(
        title: Text('编辑适配：${a.worldName ?? '默认'}'),
        content: TextField(
          controller: controller,
          maxLines: 6,
          decoration: const InputDecoration(hintText: '该世界下角色的语气/人设/关系设定'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('保存'),
          ),
        ],
      ),
    );
    if (ok != true) return;

    await ref.read(dbProvider).upsertAdaptation(CharacterAdaptationsCompanion.insert(
      id: a.adaptation.id,
      characterId: characterId,
      worldId: Value(a.adaptation.worldId),
      adaptationJson: jsonEncode({'persona': controller.text.trim()}),
      createdAt: a.adaptation.createdAt,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    ));
    if (context.mounted) await showSuccessDialog(context, '已保存');
  }

  Future<void> _bindWorld(BuildContext context, WidgetRef ref) async {
    final worlds = await ref.read(dbProvider).watchWorlds().first;
    if (!context.mounted) return;
    if (worlds.isEmpty) {
      await showErrorDialog(context, '请先在「异世界」创建世界');
      return;
    }

    // Exclude worlds this character is already bound to, so re-binding can't
    // reset an existing adaptation's persona back to an empty one.
    final adaptations = ref.read(adaptationsProvider(characterId)).value ?? [];
    final boundIds = {
      for (final a in adaptations)
        if (a.adaptation.worldId.isNotEmpty) a.adaptation.worldId,
    };
    final available = worlds.where((w) => !boundIds.contains(w.id)).toList();
    if (available.isEmpty) {
      await showErrorDialog(context, '该角色已绑定所有世界');
      return;
    }

    final world = await showDialog<World>(
      context: context,
      useRootNavigator: false,
      builder: (dialogContext) => SimpleDialog(
        title: const Text('选择世界'),
        children: [
          for (final w in available)
            SimpleDialogOption(
              onPressed: () => Navigator.of(dialogContext).pop(w),
              child: ListTile(
                leading: const Icon(Icons.public),
                title: Text(w.name),
              ),
            ),
        ],
      ),
    );
    if (world == null) return;

    final now = DateTime.now().millisecondsSinceEpoch;
    await ref.read(dbProvider).upsertAdaptation(CharacterAdaptationsCompanion.insert(
      id: const Uuid().v4(),
      characterId: characterId,
      worldId: Value(world.id),
      adaptationJson: '{}',
      createdAt: now,
      updatedAt: now,
    ));
    if (context.mounted) await showSuccessDialog(context, '已绑定世界「${world.name}」');
  }

  Future<void> _unbindWorld(
    BuildContext context,
    WidgetRef ref,
    AdaptationWithWorld a,
  ) async {
    final ok = await showConfirmDialog(
      context,
      title: '解绑世界',
      message: '确定解绑「${a.worldName ?? '该世界'}」的适配吗？',
      confirmLabel: '解绑',
    );
    if (!ok) return;
    await ref.read(dbProvider).deleteAdaptation(a.adaptation.id);
    if (context.mounted) await showSuccessDialog(context, '已解绑');
  }

  Widget _buildWorldbooks(BuildContext context, WidgetRef ref) {
    final async = ref.watch(characterWorldbooksProvider(characterId));
    return async.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(8),
        child: CircularProgressIndicator(),
      ),
      error: (e, _) => Text('加载失败：$e'),
      data: (books) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (books.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Text('未绑定世界书'),
            ),
          for (final b in books)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.menu_book),
              title: Text(b.name),
              trailing: IconButton(
                icon: const Icon(Icons.link_off),
                tooltip: '解绑世界书',
                onPressed: () => _unbindWorldbook(context, ref, b),
              ),
            ),
          TextButton.icon(
            onPressed: () => _bindWorldbook(context, ref),
            icon: const Icon(Icons.add),
            label: const Text('绑定世界书'),
          ),
        ],
      ),
    );
  }

  Future<void> _bindWorldbook(BuildContext context, WidgetRef ref) async {
    final books = await ref.read(dbProvider).watchWorldbooks().first;
    if (!context.mounted) return;
    if (books.isEmpty) {
      await showErrorDialog(context, '请先在「异世界」导入世界书');
      return;
    }
    final bound = (ref.read(characterWorldbooksProvider(characterId)).value ?? [])
        .map((b) => b.id)
        .toSet();
    final available = books.where((b) => !bound.contains(b.id)).toList();
    if (available.isEmpty) {
      await showErrorDialog(context, '该角色已绑定全部世界书');
      return;
    }
    final selected = await showMultiSelectSheet(
      context,
      title: '绑定世界书',
      options: [for (final b in available) MultiSelectOption(b.id, b.name)],
    );
    if (selected == null || selected.isEmpty) return;
    final now = DateTime.now().millisecondsSinceEpoch;
    for (final id in selected) {
      await ref.read(dbProvider).bindCharacterWorldbook(characterId, id, now);
    }
    if (context.mounted) await showSuccessDialog(context, '已绑定世界书');
  }

  Future<void> _unbindWorldbook(
    BuildContext context,
    WidgetRef ref,
    Worldbook b,
  ) async {
    final ok = await showConfirmDialog(
      context,
      title: '解绑世界书',
      message: '确定解绑「${b.name}」吗？',
      confirmLabel: '解绑',
    );
    if (!ok) return;
    await ref.read(dbProvider).unbindCharacterWorldbook(characterId, b.id);
    if (context.mounted) await showSuccessDialog(context, '已解绑');
  }

  Future<void> _startChat(BuildContext context, WidgetRef ref) async {
    // Only offer worlds this character is actually bound to (via a world
    // adaptation); otherwise start in the default (no-world) context directly.
    final adaptations =
        ref.read(adaptationsProvider(characterId)).value ?? const [];
    final bound = adaptations
        .where((a) => a.adaptation.worldId.isNotEmpty)
        .toList();

    String? selectedWorldId;
    if (bound.isNotEmpty) {
      final choice = await showDialog<_StartChoice>(
        context: context,
        useRootNavigator: false,
        builder: (dialogContext) => SimpleDialog(
          title: const Text('选择世界'),
          children: [
            SimpleDialogOption(
              onPressed: () =>
                  Navigator.of(dialogContext).pop(const _StartChoice(null)),
              child: const ListTile(
                leading: Icon(Icons.person),
                title: Text('默认（无世界）'),
              ),
            ),
            for (final a in bound)
              SimpleDialogOption(
                onPressed: () => Navigator.of(dialogContext)
                    .pop(_StartChoice(a.adaptation.worldId)),
                child: ListTile(
                  leading: const Icon(Icons.public),
                  title: Text(a.worldName ?? a.adaptation.worldId),
                ),
              ),
          ],
        ),
      );
      if (choice == null) return;
      selectedWorldId = choice.worldId;
    }

    final db = ref.read(dbProvider);
    final character = await db.getCharacter(characterId);

    // Session-level worldbook selection (overrides character binding).
    List<String>? selectedWorldbookIds;
    final allBooks = await db.watchWorldbooks().first;
    if (allBooks.isNotEmpty && context.mounted) {
      final charBound = (await db.watchWorldbooksForCharacter(characterId).first)
          .map((b) => b.id)
          .toSet();
      if (!context.mounted) return;
      selectedWorldbookIds = await showMultiSelectSheet(
        context,
        title: '选择世界书（本次会话）',
        options: [for (final b in allBooks) MultiSelectOption(b.id, b.name)],
        initial: charBound,
      );
    }

    final worldKey = selectedWorldId ?? '';
    final hasMemory = await db.hasCharacterMemory(characterId, worldKey);

    var freshStart = false;
    if (hasMemory) {
      if (!context.mounted) return;
      freshStart =
          await showFreshStartDialog(context, character?.name ?? '该角色') ??
              false;
      if (!context.mounted) return;
    }

    final repo = SessionRepository(db);
    final String sessionId;
    if (freshStart) {
      // Wipe this (character, world) story: clear relation + world memory +
      // skill growth, drop the existing session, then start fresh.
      await db.resetCharacterRelation(characterId, worldKey);
      await db.resetCharacterMemory(characterId, worldKey);
      await db.resetCharacterAffinity(characterId, worldKey);
      final existing =
          await db.getSessionForCharacter(characterId, selectedWorldId);
      if (existing != null) await db.deleteSession(existing.id);
      sessionId = await repo.createSession(characterId,
          worldId: selectedWorldId, worldbookIds: selectedWorldbookIds);
    } else {
      sessionId = await repo.getOrCreateSession(characterId,
          worldId: selectedWorldId, worldbookIds: selectedWorldbookIds);
    }
    if (context.mounted) {
      // Pop this detail page so the contacts branch returns to the list;
      // otherwise switching back to the contacts tab flashes the stale detail
      // during goBranch's reset.
      if (context.canPop()) context.pop();
      context.go('/chat/$sessionId');
    }
  }

  bool _hasEnglishGreetings(Map<String, dynamic> core) {
    if (needsTranslation((core['first_mes'] ?? '').toString())) return true;
    final alts = core['alternate_greetings'];
    if (alts is List) {
      return alts.any((a) => needsTranslation(a.toString()));
    }
    return false;
  }

  bool _hasEnglishWorldbookKeys(Character c) {
    final worldbook = c.worldbookJson == null ? null : _decode(c.worldbookJson!);
    if (worldbook == null) return false;
    final entries = worldbook['entries'];
    if (entries is! List) return false;
    for (final e in entries) {
      if (e is! Map) continue;
      final keys = e['keys'] is List
          ? (e['keys'] as List).map((k) => k.toString())
          : const <String>[];
      if (keys.any(needsTranslation)) return true;
    }
    return false;
  }

  /// Translates the character's English greetings to Chinese and caches the
  /// result under `core['greetings_zh']`, so chats can start in Chinese.
  Future<void> _translateGreetings(
    BuildContext context,
    WidgetRef ref,
    Character c,
  ) async {
    final core = _decode(c.corePersonaJson);

    // 已翻译过就不再重翻（避免覆盖已有中文缓存、浪费一次 LLM 调用）。
    final cachedZh = core['greetings_zh'];
    if (cachedZh is List && cachedZh.isNotEmpty) {
      if (context.mounted) {
        await showSuccessDialog(context, '开场白已翻译过，无需重复翻译');
      }
      return;
    }

    // 保留原文格式：只 trim + 精确去重，不做空白折叠（否则换行/段落结构会丢）。
    final greetings = <String>[];
    void add(String s) {
      final t = s.trim();
      if (t.isEmpty || greetings.contains(t)) return;
      greetings.add(t);
    }

    add((core['first_mes'] ?? '').toString());
    final alts = core['alternate_greetings'];
    if (alts is List) {
      for (final a in alts) {
        add(a.toString());
      }
    }
    if (greetings.isEmpty) return;

    final config = await resolveActiveProvider(
      ref.read(dbProvider),
      ref.read(secureKeyStoreProvider),
    );
    if (config == null) {
      if (context.mounted) {
        await showErrorDialog(context, '请先在「我」中配置 API Provider');
      }
      return;
    }

    if (!context.mounted) return;
    final progress = ValueNotifier<int>(0);
    final total = greetings.length;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: false,
      builder: (_) => ValueListenableBuilder<int>(
        valueListenable: progress,
        builder: (context, value, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 12),
              Text('翻译中 $value / $total'),
            ],
          ),
        ),
      ),
    );

    final zh = <String>[];
    try {
      for (var i = 0; i < greetings.length; i++) {
        final g = greetings[i];
        if (!needsTranslation(g)) {
          zh.add(g);
        } else {
          final t = await translateToChinese(buildLlmProvider(config), g);
          zh.add(t.isNotEmpty ? t : g);
        }
        progress.value = i + 1;
      }
    } catch (e) {
      if (context.mounted) Navigator.of(context).pop();
      if (context.mounted) await showErrorDialog(context, '翻译失败：$e');
      return;
    }

    core['greetings_zh'] = zh;
    await ref.read(dbProvider).updateCharacter(
          c.id,
          CharactersCompanion(
            corePersonaJson: Value(jsonEncode(core)),
            updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
          ),
        );
    ref.invalidate(characterProvider(c.id));

    if (context.mounted) Navigator.of(context).pop();
    if (context.mounted) await showSuccessDialog(context, '已翻译并保存');
  }

  List<Widget> _section(BuildContext context, String title, dynamic value) {
    final text = value?.toString().trim() ?? '';
    if (text.isEmpty) return const [];
    return [ExpandableSection(title: title, text: text)];
  }

  List<Widget> _sectionList(BuildContext context, String title, dynamic value) {
    if (value is! List) return const [];
    final items = <String>[];
    for (final e in value) {
      final text = e?.toString().trim() ?? '';
      if (text.isNotEmpty) items.add(text);
    }
    if (items.isEmpty) return const [];
    return [
      for (var i = 0; i < items.length; i++)
        ExpandableSection(
          title: items.length == 1 ? title : '$title ${i + 1}',
          text: items[i],
        ),
    ];
  }

  /// Worldbook entries (research notes) + original game-text sources, shown as
  /// collapsible sections at the bottom of the detail page.
  List<Widget> _buildReference(BuildContext context, Character c) {
    final worldbook = c.worldbookJson == null ? null : _decode(c.worldbookJson!);
    if (worldbook == null) return const [];

    final widgets = <Widget>[];

    final entries = worldbook['entries'];
    if (entries is List && entries.isNotEmpty) {
      final children = <Widget>[];
      for (final e in entries) {
        if (e is! Map) continue;
        final content = (e['content'] ?? '').toString();
        if (content.trim().isEmpty) continue;
        final comment = (e['comment'] ?? '').toString().trim();
        final keys = e['keys'] is List ? (e['keys'] as List).join(' / ') : '';
        final title = comment.isNotEmpty
            ? comment
            : (keys.isNotEmpty ? keys : '条目');
        children.add(ExpandableSection(
          title: title,
          text: content,
        ));
      }
      if (children.isNotEmpty) {
        widgets.add(ExpansionTile(
          title: Text('世界书（${children.length}）'),
          children: children,
        ));
      }
    }

    final sources = worldbook['sources'];
    if (sources is List && sources.isNotEmpty) {
      final children = <Widget>[];
      for (final s in sources) {
        if (s is! Map) continue;
        final name = (s['name'] ?? '').toString();
        final content = (s['content'] ?? '').toString();
        if (content.trim().isEmpty) continue;
        children.add(ExpandableSection(title: name, text: content));
      }
      if (children.isNotEmpty) {
        widgets.add(ExpansionTile(
          title: Text('原文（${children.length}）'),
          children: children,
        ));
      }
    }

    return widgets;
  }

  Future<void> _changeAvatar(
    BuildContext context,
    WidgetRef ref,
    Character c,
  ) async {
    final files = await FilePicker.pickFiles(type: FileType.image);
    if (files.isEmpty) return;
    final file = files.first;
    final bytes = await file.readAsBytes();
    if (!context.mounted) return;
    final cropped = await Navigator.of(context).push<Uint8List>(
      MaterialPageRoute(
        builder: (_) => AvatarCropScreen(imageBytes: Uint8List.fromList(bytes)),
      ),
    );
    if (cropped == null || cropped.isEmpty) return;

    final path = await CharacterRepository(ref.read(dbProvider))
        .saveAvatar(cropped, oldPath: c.avatarPath);
    await ref.read(dbProvider).updateCharacter(
          c.id,
          CharactersCompanion(
            avatarPath: Value(path),
            updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
          ),
        );
    ref.invalidate(characterProvider(c.id));
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, Character c) async {
    final ok = await showConfirmDialog(
      context,
      title: '删除角色',
      message: '确定删除「${c.name}」？其所有会话也会被删除。',
      confirmLabel: '删除',
    );
    if (!ok) return;
    await CharacterRepository(ref.read(dbProvider)).deleteCharacter(c.id);
    if (context.mounted) context.pop();
  }

  String _persona(String json) {
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return (map['persona'] ?? '').toString();
    } catch (_) {
      return '';
    }
  }

  Map<String, dynamic> _decode(String s) {
    try {
      return jsonDecode(s) as Map<String, dynamic>;
    } catch (_) {
      return <String, dynamic>{};
    }
  }

  /// Translates the built-in worldbook's English keys to Chinese and appends
  /// them, so it triggers on Chinese messages too.
  Future<void> _translateWorldbookKeys(
    BuildContext context,
    WidgetRef ref,
    Character c,
  ) async {
    final worldbook = c.worldbookJson == null ? null : _decode(c.worldbookJson!);
    if (worldbook == null) return;
    final entries = worldbook['entries'];
    if (entries is! List || entries.isEmpty) return;

    final allKeys = <String>[];
    for (final e in entries) {
      if (e is! Map) continue;
      final keys = e['keys'] is List
          ? (e['keys'] as List).map((k) => k.toString())
          : const <String>[];
      allKeys.addAll(keys.where(needsTranslation));
    }
    if (allKeys.isEmpty) {
      if (context.mounted) await showSuccessDialog(context, '没有需要翻译的英文关键词');
      return;
    }

    final config = await resolveActiveProvider(
      ref.read(dbProvider),
      ref.read(secureKeyStoreProvider),
    );
    if (config == null) {
      if (context.mounted) {
        await showErrorDialog(context, '请先在「我」中配置 API Provider');
      }
      return;
    }

    if (context.mounted) {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        useRootNavigator: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );
    }

    final Map<String, String> translated;
    try {
      translated = await translateKeys(buildLlmProvider(config), allKeys);
    } catch (e) {
      if (context.mounted) Navigator.of(context).pop();
      if (context.mounted) await showErrorDialog(context, '翻译失败：$e');
      return;
    }
    if (context.mounted) Navigator.of(context).pop();
    if (translated.isEmpty) {
      if (context.mounted) {
        await showErrorDialog(context, '翻译失败，请检查 API Provider 或重试');
      }
      return;
    }

    for (final e in entries) {
      if (e is! Map) continue;
      final keys = e['keys'] is List
          ? (e['keys'] as List).map((k) => k.toString()).toList()
          : <String>[];
      final newKeys = <String>[];
      for (final k in keys) {
        newKeys.add(k);
        final zh = translated[k];
        if (zh != null && zh.isNotEmpty && zh != k) newKeys.add(zh);
      }
      e['keys'] = newKeys;
    }

    await ref.read(dbProvider).updateCharacter(
          c.id,
          CharactersCompanion(worldbookJson: Value(jsonEncode(worldbook))),
        );
    if (context.mounted) await showSuccessDialog(context, '已翻译世界书关键词');
  }

  Future<void> _export(BuildContext context, WidgetRef ref) async {
    final c = await ref.read(dbProvider).getCharacter(characterId);
    if (c == null) return;
    final worldbook = c.worldbookJson == null ? null : _decode(c.worldbookJson!);
    final json = CharacterExporter().exportToJson(
      name: c.name,
      core: _decode(c.corePersonaJson),
      worldbook: worldbook,
      tags: _decodeTags(c.tags),
    );
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      useRootNavigator: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('导出角色卡'),
        content: SizedBox(
          width: 360,
          child: SingleChildScrollView(
            child: Text(json, style: const TextStyle(fontSize: 12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: json));
              Navigator.of(dialogContext).pop();
            },
            child: const Text('复制 JSON'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  List<String> _decodeTags(String s) {
    try {
      return List<String>.from(jsonDecode(s) as List<dynamic>);
    } catch (_) {
      return const <String>[];
    }
  }
}

class _StartChoice {
  const _StartChoice(this.worldId);

  final String? worldId;
}
