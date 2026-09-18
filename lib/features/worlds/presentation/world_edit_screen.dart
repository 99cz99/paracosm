import 'dart:convert';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../core/db/database.dart';
import '../../../core/providers/db_providers.dart';
import '../../../core/utils/dialogs.dart';
import '../../../core/utils/multi_select_sheet.dart';
import 'worlds_providers.dart';

class WorldEditScreen extends ConsumerStatefulWidget {
  const WorldEditScreen({super.key, this.worldId});

  final String? worldId;

  @override
  ConsumerState<WorldEditScreen> createState() => _WorldEditScreenState();
}

class _WorldEditScreenState extends ConsumerState<WorldEditScreen> {
  final _name = TextEditingController();
  final _description = TextEditingController();
  final _rules = TextEditingController();
  final _initialState = TextEditingController();
  final Set<String> _worldbookIds = {};
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.worldId != null) _load();
  }

  Future<void> _load() async {
    final world = await ref.read(dbProvider).getWorld(widget.worldId!);
    if (world == null) return;
    _name.text = world.name;
    _description.text = world.description ?? '';
    _rules.text = _field(world.rulesJson);
    _initialState.text = _field(world.initialStateJson);
    final bookIds =
        await ref.read(dbProvider).getWorldWorldbookIds(widget.worldId!);
    _worldbookIds
      ..clear()
      ..addAll(bookIds);
    if (mounted) setState(() {});
  }

  String _field(String json) {
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return (map['text'] ?? '').toString();
    } catch (_) {
      return '';
    }
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    if (name.isEmpty) {
      await showErrorDialog(context, '请填写世界名称');
      return;
    }
    setState(() => _loading = true);
    final db = ref.read(dbProvider);
    final now = DateTime.now().millisecondsSinceEpoch;
    final description = _description.text.trim();
    final rulesJson = jsonEncode({'text': _rules.text.trim()});
    final initialStateJson = jsonEncode({'text': _initialState.text.trim()});

    try {
      final String worldId;
      if (widget.worldId == null) {
        worldId = const Uuid().v4();
        await db.insertWorld(WorldsCompanion.insert(
          id: worldId,
          name: name,
          description: Value(description.isEmpty ? null : description),
          rulesJson: Value(rulesJson),
          initialStateJson: Value(initialStateJson),
          createdAt: now,
          updatedAt: now,
        ));
      } else {
        worldId = widget.worldId!;
        await db.updateWorld(worldId, WorldsCompanion(
          name: Value(name),
          description: Value(description.isEmpty ? null : description),
          rulesJson: Value(rulesJson),
          initialStateJson: Value(initialStateJson),
          updatedAt: Value(now),
        ));
      }
      await db.setWorldWorldbooks(worldId, _worldbookIds, now);
      ref.invalidate(worldProvider(worldId));
      if (mounted) {
        await showSuccessDialog(context, '已保存');
        if (mounted) context.pop();
      }
    } catch (e) {
      if (mounted) await showErrorDialog(context, '保存失败：$e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _pickWorldbooks(List<Worldbook> books) async {
    final selected = await showMultiSelectSheet(
      context,
      title: '选择世界书',
      options: [for (final b in books) MultiSelectOption(b.id, b.name)],
      initial: _worldbookIds,
    );
    if (selected == null) return;
    setState(() => _worldbookIds
      ..clear()
      ..addAll(selected));
  }

  Widget _multiSelectField(
    BuildContext context, {
    required String label,
    required List<String> selectedNames,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 4),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            if (selectedNames.isEmpty)
              const Chip(label: Text('未选择'), visualDensity: VisualDensity.compact)
            else
              for (final n in selectedNames)
                Chip(label: Text(n), visualDensity: VisualDensity.compact),
          ],
        ),
        TextButton.icon(
          onPressed: onTap,
          icon: const Icon(Icons.add),
          label: const Text('选择'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _rules.dispose();
    _initialState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final worldbooks = ref.watch(worldbooksProvider).value ?? [];
    final worldbookNames = [
      for (final b in worldbooks)
        if (_worldbookIds.contains(b.id)) b.name,
    ];

    return Scaffold(
      appBar: AppBar(title: Text(widget.worldId == null ? '新建世界' : '编辑世界')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextField(
                  controller: _name,
                  decoration: const InputDecoration(labelText: '名称'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _description,
                  decoration: const InputDecoration(
                    labelText: '描述',
                    helperText: '这个世界的背景介绍（对所有角色共享）',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _rules,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: '规则',
                    helperText: '世界的规则/约束，所有角色共享',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _initialState,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: '初始状态',
                    helperText: '故事开局时的静态场景（区别于随对话演变的记忆状态）',
                  ),
                ),
                const SizedBox(height: 16),
                _multiSelectField(
                  context,
                  label: '世界书（可选，可多选）',
                  selectedNames: worldbookNames,
                  onTap: () => _pickWorldbooks(worldbooks),
                ),
                const SizedBox(height: 24),
                FilledButton(onPressed: _save, child: const Text('保存')),
              ],
            ),
    );
  }
}
