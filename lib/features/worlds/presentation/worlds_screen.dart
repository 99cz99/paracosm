import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/db/database.dart';
import '../../../core/providers/db_providers.dart';
import '../../../core/utils/dialogs.dart';
import '../data/worldbook_repository.dart';
import '../data/world_exporter.dart';
import 'worlds_providers.dart';

class WorldsScreen extends ConsumerWidget {
  const WorldsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final worldsAsync = ref.watch(worldsProvider);
    final worldbooksAsync = ref.watch(worldbooksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('异世界'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: '新建 / 导入',
            onPressed: () => _showAddMenu(context, ref),
          ),
        ],
      ),
      body: ListView(
        children: [
          _sectionHeader(context, '世界'),
          worldsAsync.when(
            loading: () => const _Loading(),
            error: (e, _) => Padding(
              padding: const EdgeInsets.all(24),
              child: Text('加载失败：$e'),
            ),
            data: (worlds) => worlds.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text('还没有异世界，点右上角 + 新建'),
                  )
                : Column(
                    children: [
                      for (final w in worlds)
                        ListTile(
                          leading: const Icon(Icons.public),
                          title: Text(w.name),
                          subtitle: Text(w.description ?? ''),
                          onTap: () => context.push('/worlds/${w.id}'),
                          onLongPress: () => _confirmDeleteWorld(context, ref, w),
                        ),
                    ],
                  ),
          ),
          const Divider(),
          _sectionHeader(context, '世界书'),
          worldbooksAsync.when(
            loading: () => const _Loading(),
            error: (e, _) => Padding(
              padding: const EdgeInsets.all(24),
              child: Text('加载失败：$e'),
            ),
            data: (books) => books.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text('还没有世界书，点右上角书本图标导入，或「新建」手动创建'),
                  )
                : Column(
                    children: [
                      for (final b in books)
                        ListTile(
                          leading: const Icon(Icons.menu_book),
                          title: Text(b.name),
                          subtitle: Text(_entryCountLabel(b.bookJson)),
                          onTap: () =>
                              context.push('/worlds/worldbooks/${b.id}/edit'),
                          onLongPress: () => _confirmDeleteBook(context, ref, b),
                        ),
                    ],
                  ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title, {Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: Theme.of(context).textTheme.titleMedium),
          ),
          ?trailing,
        ],
      ),
    );
  }

  String _entryCountLabel(String bookJson) {
    try {
      final map = jsonDecode(bookJson) as Map<String, dynamic>;
      final entries = map['entries'];
      if (entries is List) return '${entries.length} 条词条';
    } catch (_) {}
    return '无词条';
  }

  Future<void> _showAddMenu(BuildContext context, WidgetRef ref) async {
    final action = await showModalBottomSheet<_AddAction>(
      context: context,
      useRootNavigator: false,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.public),
              title: const Text('新建世界'),
              onTap: () => Navigator.of(sheetContext).pop(_AddAction.newWorld),
            ),
            ListTile(
              leading: const Icon(Icons.file_download_outlined),
              title: const Text('导入世界'),
              onTap: () =>
                  Navigator.of(sheetContext).pop(_AddAction.importWorld),
            ),
            ListTile(
              leading: const Icon(Icons.menu_book),
              title: const Text('新建世界书'),
              onTap: () =>
                  Navigator.of(sheetContext).pop(_AddAction.newWorldbook),
            ),
            ListTile(
              leading: const Icon(Icons.folder_open),
              title: const Text('导入世界书'),
              onTap: () =>
                  Navigator.of(sheetContext).pop(_AddAction.importWorldbook),
            ),
          ],
        ),
      ),
    );
    if (action == null || !context.mounted) return;
    switch (action) {
      case _AddAction.newWorld:
        context.push('/worlds/edit');
        break;
      case _AddAction.importWorld:
        await _importWorld(context, ref);
        break;
      case _AddAction.newWorldbook:
        context.push('/worlds/worldbooks/new');
        break;
      case _AddAction.importWorldbook:
        await _importWorldbook(context, ref);
        break;
    }
  }

  Future<void> _importWorld(BuildContext context, WidgetRef ref) async {
    final mode = await showModalBottomSheet<_ImportMode>(
      context: context,
      useRootNavigator: false,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.folder_open),
              title: const Text('文件导入'),
              onTap: () => Navigator.of(sheetContext).pop(_ImportMode.file),
            ),
            ListTile(
              leading: const Icon(Icons.content_paste),
              title: const Text('粘贴 JSON'),
              onTap: () => Navigator.of(sheetContext).pop(_ImportMode.paste),
            ),
          ],
        ),
      ),
    );
    if (mode == null || !context.mounted) return;

    String? raw;
    if (mode == _ImportMode.paste) {
      raw = await showPasteTextDialog(context,
          title: '粘贴世界 JSON', hint: '{...世界 JSON...}');
      if (raw == null || raw.trim().isEmpty) return;
    } else {
      final files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      if (files.isEmpty) return;
      raw = utf8.decode(await files.first.readAsBytes());
    }

    final companion = parseWorldJson(raw);
    if (companion == null) {
      if (context.mounted) await showErrorDialog(context, '不是有效的世界导出 JSON');
      return;
    }
    await ref.read(dbProvider).insertWorld(companion);
    if (context.mounted) await showSuccessDialog(context, '已导入');
  }

  Future<void> _importWorldbook(BuildContext context, WidgetRef ref) async {
    final mode = await showModalBottomSheet<_ImportMode>(
      context: context,
      useRootNavigator: false,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.folder_open),
              title: const Text('文件导入'),
              onTap: () => Navigator.of(sheetContext).pop(_ImportMode.file),
            ),
            ListTile(
              leading: const Icon(Icons.content_paste),
              title: const Text('粘贴 JSON'),
              onTap: () => Navigator.of(sheetContext).pop(_ImportMode.paste),
            ),
          ],
        ),
      ),
    );
    if (mode == null || !context.mounted) return;

    final repo = WorldbookRepository(ref.read(dbProvider));
    if (mode == _ImportMode.paste) {
      final text = await showPasteTextDialog(context,
          title: '粘贴世界书 JSON', hint: '{...世界书 JSON...}');
      if (text == null || text.trim().isEmpty) return;
      try {
        await repo.importFromJson(text);
        if (context.mounted) await showSuccessDialog(context, '已导入世界书');
      } catch (e) {
        if (context.mounted) await showErrorDialog(context, '导入失败：$e');
      }
      return;
    }

    final files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json', 'md', 'zip'],
    );
    if (files.isEmpty) return;
    final file = files.first;
    final bytes = await file.readAsBytes();
    try {
      await repo.importFromBytes(
        bytes,
        sourcePath: file.path ?? file.name,
        filename: file.name,
      );
      if (context.mounted) await showSuccessDialog(context, '已导入世界书');
    } catch (e) {
      if (context.mounted) await showErrorDialog(context, '导入失败：$e');
    }
  }

  Future<void> _confirmDeleteWorld(
    BuildContext context,
    WidgetRef ref,
    World w,
  ) async {
    final ok = await showConfirmDialog(
      context,
      title: '删除世界',
      message: '确定删除「${w.name}」？',
    );
    if (!ok) return;
    await ref.read(dbProvider).deleteWorld(w.id);
    if (context.mounted) await showSuccessDialog(context, '已删除');
  }

  Future<void> _confirmDeleteBook(
    BuildContext context,
    WidgetRef ref,
    Worldbook b,
  ) async {
    final ok = await showConfirmDialog(
      context,
      title: '删除世界书',
      message: '确定删除「${b.name}」？',
    );
    if (!ok) return;
    await ref.read(dbProvider).deleteWorldbook(b.id);
    if (context.mounted) await showSuccessDialog(context, '已删除');
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(24),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

enum _ImportMode { file, paste }

enum _AddAction { newWorld, importWorld, newWorldbook, importWorldbook }
