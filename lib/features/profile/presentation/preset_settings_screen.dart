import 'dart:convert';

import 'package:drift/drift.dart' hide Column;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/db/database.dart';
import '../../../core/import/st_preset.dart';
import '../../../core/providers/db_providers.dart';
import '../../../core/providers/llm_providers.dart';
import '../../../core/utils/dialogs.dart';

final presetsProvider = StreamProvider<List<Preset>>((ref) {
  return ref.watch(dbProvider).watchPresets();
});

/// Manages named sampling presets (temperature / maxTokens / penalties /
/// optional API), which a chat session can apply.
class PresetSettingsScreen extends ConsumerWidget {
  const PresetSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final presetsAsync = ref.watch(presetsProvider);
    final configs = ref.watch(providerConfigsProvider).value ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('采样预设'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            tooltip: '导入酒馆预设',
            onPressed: () => _import(context, ref),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(context, ref, configs),
        child: const Icon(Icons.add),
      ),
      body: presetsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('加载失败：$e')),
        data: (presets) {
          if (presets.isEmpty) {
            return const Center(child: Text('还没有预设，点右下角添加'));
          }
          return ListView.builder(
            itemCount: presets.length,
            itemBuilder: (context, index) {
              final p = presets[index];
              return ListTile(
                leading: const Icon(Icons.tune),
                title: Text(p.name),
                subtitle: Text(_summary(p, configs)),
                trailing: IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: '编辑',
                  onPressed: () => _openForm(context, ref, configs, existing: p),
                ),
                onLongPress: () => _showActions(context, ref, p),
              );
            },
          );
        },
      ),
    );
  }

  String _summary(Preset p, List<ProviderConfig> configs) {
    final parts = <String>[];
    if (p.providerId != null && p.providerId!.isNotEmpty) {
      final name = configs
          .where((c) => c.id == p.providerId)
          .map((c) => c.name)
          .firstOrNull;
      parts.add('API：${name ?? p.providerId}');
    }
    if (p.temperature != null) parts.add('temperature ${p.temperature}');
    if (p.topP != null) parts.add('top_p ${p.topP}');
    if (p.maxTokens != null) parts.add('maxTokens ${p.maxTokens}');
    if (p.presencePenalty != null) parts.add('presence ${p.presencePenalty}');
    if (p.frequencyPenalty != null) parts.add('frequency ${p.frequencyPenalty}');
    return parts.isEmpty ? '（空预设）' : parts.join(' · ');
  }

  Future<void> _openForm(
    BuildContext context,
    WidgetRef ref,
    List<ProviderConfig> configs, {
    Preset? existing,
  }) async {
    final result = await showDialog<_PresetFormResult>(
      context: context,
      useRootNavigator: false,
      builder: (_) => _PresetFormDialog(configs: configs, existing: existing),
    );
    if (result == null) return;

    final db = ref.read(dbProvider);
    final now = DateTime.now().millisecondsSinceEpoch;
    if (existing == null) {
      await db.insertPreset(PresetsCompanion.insert(
        id: const Uuid().v4(),
        name: result.name,
        providerId: Value(result.providerId),
        temperature: Value(result.temperature),
        topP: Value(result.topP),
        maxTokens: Value(result.maxTokens),
        presencePenalty: Value(result.presencePenalty),
        frequencyPenalty: Value(result.frequencyPenalty),
        createdAt: now,
        updatedAt: now,
      ));
    } else {
      await db.updatePreset(existing.id, PresetsCompanion(
        name: Value(result.name),
        providerId: Value(result.providerId),
        temperature: Value(result.temperature),
        topP: Value(result.topP),
        maxTokens: Value(result.maxTokens),
        presencePenalty: Value(result.presencePenalty),
        frequencyPenalty: Value(result.frequencyPenalty),
        updatedAt: Value(now),
      ));
    }
    if (context.mounted) await showSuccessDialog(context, '已保存');
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, Preset p) async {
    final ok = await showConfirmDialog(
      context,
      title: '删除预设',
      message: '确定删除「${p.name}」？',
      confirmLabel: '删除',
    );
    if (!ok) return;
    await ref.read(dbProvider).deletePreset(p.id);
    if (context.mounted) await showSuccessDialog(context, '已删除');
  }

  Future<void> _showActions(BuildContext context, WidgetRef ref, Preset p) async {
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
        final configs = ref.read(providerConfigsProvider).value ?? [];
        await _openForm(context, ref, configs, existing: p);
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
          title: '粘贴酒馆预设 JSON', hint: '{...采样预设 JSON...}');
      if (raw == null || raw.trim().isEmpty) return;
    } else {
      final files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      if (files.isEmpty) return;
      raw = utf8.decode(await files.first.readAsBytes());
    }

    final companion = parseStPresetJson(raw);
    if (companion == null) {
      if (context.mounted) {
        await showErrorDialog(context, '不是有效的酒馆预设 JSON');
      }
      return;
    }
    final presets = await ref.read(presetsProvider.future);
    if (presets.any((p) => p.name == companion.name.value)) {
      if (context.mounted) {
        await showErrorDialog(context, '已存在同名预设「${companion.name.value}」');
      }
      return;
    }
    await ref.read(dbProvider).insertPreset(companion);
    if (context.mounted) await showSuccessDialog(context, '已导入预设');
  }

  Future<void> _export(BuildContext context, Preset p) async {
    final json = exportPresetJson(p);
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
}

enum _ImportMode { file, paste }

enum _PresetAction { edit, export, delete }

class _PresetFormResult {
  const _PresetFormResult({
    required this.name,
    this.providerId,
    this.temperature,
    this.topP,
    this.maxTokens,
    this.presencePenalty,
    this.frequencyPenalty,
  });

  final String name;
  final String? providerId;
  final double? temperature;
  final double? topP;
  final int? maxTokens;
  final double? presencePenalty;
  final double? frequencyPenalty;
}

class _PresetFormDialog extends StatefulWidget {
  const _PresetFormDialog({required this.configs, this.existing});

  final List<ProviderConfig> configs;
  final Preset? existing;

  @override
  State<_PresetFormDialog> createState() => _PresetFormDialogState();
}

class _PresetFormDialogState extends State<_PresetFormDialog> {
  late final TextEditingController _name =
      TextEditingController(text: widget.existing?.name ?? '');
  late final TextEditingController _temperature =
      TextEditingController(text: widget.existing?.temperature?.toString() ?? '');
  late final TextEditingController _topP =
      TextEditingController(text: widget.existing?.topP?.toString() ?? '');
  late final TextEditingController _maxTokens =
      TextEditingController(text: widget.existing?.maxTokens?.toString() ?? '');
  late final TextEditingController _presence =
      TextEditingController(text: widget.existing?.presencePenalty?.toString() ?? '');
  late final TextEditingController _frequency =
      TextEditingController(text: widget.existing?.frequencyPenalty?.toString() ?? '');
  late String? _providerId;

  @override
  void initState() {
    super.initState();
    _providerId = widget.existing?.providerId;
  }

  @override
  void dispose() {
    _name.dispose();
    _temperature.dispose();
    _topP.dispose();
    _maxTokens.dispose();
    _presence.dispose();
    _frequency.dispose();
    super.dispose();
  }

  static double? _parseDouble(String s) =>
      s.trim().isEmpty ? null : double.tryParse(s.trim());
  static int? _parseInt(String s) =>
      s.trim().isEmpty ? null : int.tryParse(s.trim());

  void _submit() {
    if (_name.text.trim().isEmpty) return;
    Navigator.of(context).pop(_PresetFormResult(
      name: _name.text.trim(),
      providerId: _providerId,
      temperature: _parseDouble(_temperature.text),
      topP: _parseDouble(_topP.text),
      maxTokens: _parseInt(_maxTokens.text),
      presencePenalty: _parseDouble(_presence.text),
      frequencyPenalty: _parseDouble(_frequency.text),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existing == null ? '添加预设' : '编辑预设'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _name, decoration: const InputDecoration(labelText: '名称')),
            const SizedBox(height: 8),
            DropdownButtonFormField<String?>(
              initialValue: _providerId,
              decoration: const InputDecoration(labelText: 'API（可选，留空用默认）'),
              items: [
                const DropdownMenuItem<String?>(value: null, child: Text('默认')),
                for (final c in widget.configs)
                  DropdownMenuItem<String?>(value: c.id, child: Text(c.name)),
              ],
              onChanged: (v) => setState(() => _providerId = v),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _temperature,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'temperature',
                helperText: '越高越发散、随机，越低越确定、保守（常用 0.6–1.2）',
                helperMaxLines: 3,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _topP,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'top_p',
                helperText: '核采样，只从累积概率前 top_p 的候选里抽样（0–1）',
                helperMaxLines: 3,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _maxTokens,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'maxTokens',
                helperText: '单次回复最多生成的 token 数',
                helperMaxLines: 3,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _presence,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Presence Penalty',
                helperText: '惩罚已出现过的词，鼓励聊新话题（-2–2）',
                helperMaxLines: 3,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _frequency,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Frequency Penalty',
                helperText: '惩罚高频重复词，降低啰嗦/重复（-2–2）',
                helperMaxLines: 3,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('取消')),
        FilledButton(onPressed: _submit, child: const Text('保存')),
      ],
    );
  }
}
