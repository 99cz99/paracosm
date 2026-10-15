import 'dart:convert';

import 'package:drift/drift.dart' hide Column;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/db/database.dart';
import '../../../core/import/system_prompt_preset.dart';
import '../../../core/providers/db_providers.dart';
import '../../../core/utils/dialogs.dart';

final systemPromptPresetsProvider =
    StreamProvider<List<SystemPromptPreset>>((ref) {
  return ref.watch(dbProvider).watchSystemPromptPresets();
});

/// Manages reusable system-prompt presets (a library of prompt snippets that
/// can be bound to characters and injected at chat time).
class SystemPromptPresetScreen extends ConsumerWidget {
  const SystemPromptPresetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final presetsAsync = ref.watch(systemPromptPresetsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('系统提示词预设'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            tooltip: '导入预设',
            onPressed: () => _import(context, ref),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(context, ref),
        child: const Icon(Icons.add),
      ),
      body: presetsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('加载失败：$e')),
        data: (presets) {
          if (presets.isEmpty) {
            return const Center(child: Text('还没有预设，点右下角添加，或右上角导入'));
          }
          return ListView.builder(
            itemCount: presets.length,
            itemBuilder: (context, index) {
              final p = presets[index];
              return ListTile(
                leading: const Icon(Icons.article_outlined),
                title: Text(p.name,
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text(
                  _preview(p.content),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: '编辑',
                  onPressed: () => _openForm(context, ref, existing: p),
                ),
                onLongPress: () => _showActions(context, ref, p),
              );
            },
          );
        },
      ),
    );
  }

  String _preview(String content) {
    final oneLine = content.replaceAll('\n', ' ').trim();
    return oneLine.length > 60 ? '${oneLine.substring(0, 60)}…' : oneLine;
  }

  Future<void> _openForm(
    BuildContext context,
    WidgetRef ref, {
    SystemPromptPreset? existing,
  }) async {
    final result = await showDialog<_PresetFormResult>(
      context: context,
      useRootNavigator: false,
      builder: (_) => _PresetFormDialog(existing: existing),
    );
    if (result == null) return;

    final db = ref.read(dbProvider);
    final now = DateTime.now().millisecondsSinceEpoch;
    if (existing == null) {
      await db.insertSystemPromptPreset(SystemPromptPresetsCompanion.insert(
        id: const Uuid().v4(),
        name: result.name,
        content: result.content,
        createdAt: now,
        updatedAt: now,
      ));
    } else {
      await db.updateSystemPromptPreset(
          existing.id,
          SystemPromptPresetsCompanion(
            name: Value(result.name),
            content: Value(result.content),
            updatedAt: Value(now),
          ));
    }
    if (context.mounted) await showSuccessDialog(context, '已保存');
  }

  Future<void> _showActions(
    BuildContext context,
    WidgetRef ref,
    SystemPromptPreset p,
  ) async {
    final action = await showModalBottomSheet<_PresetAction>(
      context: context,
      useRootNavigator: false,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('编辑'),
              onTap: () => Navigator.of(sheetContext).pop(_PresetAction.edit),
            ),
            ListTile(
              leading: const Icon(Icons.ios_share),
              title: const Text('导出'),
              onTap: () => Navigator.of(sheetContext).pop(_PresetAction.export),
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('删除'),
              onTap: () => Navigator.of(sheetContext).pop(_PresetAction.delete),
            ),
          ],
        ),
      ),
    );
    if (action == null || !context.mounted) return;
    switch (action) {
      case _PresetAction.edit:
        await _openForm(context, ref, existing: p);
        break;
      case _PresetAction.export:
        await _export(context, p);
        break;
      case _PresetAction.delete:
        await _delete(context, ref, p);
        break;
    }
  }

  Future<void> _import(BuildContext context, WidgetRef ref) async {
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
              title: const Text('粘贴文本 / JSON'),
              onTap: () => Navigator.of(sheetContext).pop(_ImportMode.paste),
            ),
          ],
        ),
      ),
    );
    if (mode == null || !context.mounted) return;

    String? raw;
    String? fallbackName;
    if (mode == _ImportMode.paste) {
      raw = await showPasteTextDialog(context,
          title: '粘贴系统提示词', hint: '纯文本，或 {name, content} JSON');
      if (raw == null || raw.trim().isEmpty) return;
    } else {
      final files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json', 'txt', 'md'],
      );
      if (files.isEmpty) return;
      final file = files.first;
      raw = utf8.decode(await file.readAsBytes());
      final name = file.name;
      final dot = name.lastIndexOf('.');
      fallbackName = dot > 0 ? name.substring(0, dot) : name;
    }

    final companion = parseSystemPromptImport(raw, fallbackName: fallbackName);
    if (companion == null) {
      if (context.mounted) {
        await showErrorDialog(context, '没有可导入的内容');
      }
      return;
    }
    final presets = await ref.read(systemPromptPresetsProvider.future);
    if (presets.any((p) => p.name == companion.name.value)) {
      if (context.mounted) {
        await showErrorDialog(context, '已存在同名预设「${companion.name.value}」');
      }
      return;
    }
    await ref.read(dbProvider).insertSystemPromptPreset(companion);
    if (context.mounted) await showSuccessDialog(context, '已导入预设');
  }

  Future<void> _export(BuildContext context, SystemPromptPreset p) async {
    final json = exportSystemPromptPresetJson(p);
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      useRootNavigator: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('导出预设'),
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

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    SystemPromptPreset p,
  ) async {
    final ok = await showConfirmDialog(
      context,
      title: '删除预设',
      message: '确定删除「${p.name}」？绑定它的角色将不再注入此预设。',
      confirmLabel: '删除',
    );
    if (!ok) return;
    await ref.read(dbProvider).deleteSystemPromptPreset(p.id);
    if (context.mounted) await showSuccessDialog(context, '已删除');
  }
}

enum _ImportMode { file, paste }

enum _PresetAction { edit, export, delete }

class _PresetFormResult {
  const _PresetFormResult({required this.name, required this.content});

  final String name;
  final String content;
}

class _PresetFormDialog extends StatefulWidget {
  const _PresetFormDialog({this.existing});

  final SystemPromptPreset? existing;

  @override
  State<_PresetFormDialog> createState() => _PresetFormDialogState();
}

class _PresetFormDialogState extends State<_PresetFormDialog> {
  late final TextEditingController _name =
      TextEditingController(text: widget.existing?.name ?? '');
  late final TextEditingController _content =
      TextEditingController(text: widget.existing?.content ?? '');

  @override
  void dispose() {
    _name.dispose();
    _content.dispose();
    super.dispose();
  }

  void _submit() {
    if (_name.text.trim().isEmpty || _content.text.trim().isEmpty) return;
    Navigator.of(context).pop(_PresetFormResult(
      name: _name.text.trim(),
      content: _content.text.trim(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existing == null ? '添加预设' : '编辑预设'),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _name,
                decoration: const InputDecoration(labelText: '名称'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _content,
                maxLines: 12,
                decoration: const InputDecoration(
                  labelText: '提示词内容',
                  hintText: '要注入 system prompt 的提示词文本',
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消')),
        FilledButton(onPressed: _submit, child: const Text('保存')),
      ],
    );
  }
}
