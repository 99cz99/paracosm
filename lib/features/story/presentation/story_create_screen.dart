import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/db/database.dart';
import '../../../core/providers/db_providers.dart';
import '../../../core/utils/dialogs.dart';
import '../../../core/utils/multi_select_sheet.dart';
import '../../contacts/presentation/contacts_providers.dart';
import '../../worlds/presentation/worlds_providers.dart';
import '../data/story_repository.dart';

class StoryCreateScreen extends ConsumerStatefulWidget {
  const StoryCreateScreen({super.key});

  @override
  ConsumerState<StoryCreateScreen> createState() => _StoryCreateScreenState();
}

class _StoryCreateScreenState extends ConsumerState<StoryCreateScreen> {
  final _name = TextEditingController();
  final _description = TextEditingController();
  String? _characterId;
  final Set<String> _worldIds = {};
  final Set<String> _worldbookIds = {};
  bool _creating = false;

  Future<void> _create() async {
    final name = _name.text.trim();
    if (name.isEmpty) {
      await showErrorDialog(context, '请填写剧本名称');
      return;
    }
    setState(() => _creating = true);
    try {
      final storyId = await StoryRepository(ref.read(dbProvider)).createStory(
        name: name,
        description: _description.text.trim(),
        characterId: _characterId,
        worldIds: _worldIds.toList(),
        worldbookIds: _worldbookIds.toList(),
      );
      if (mounted) context.go('/story/$storyId');
    } catch (e) {
      if (mounted) await showErrorDialog(context, '创建失败：$e');
    } finally {
      if (mounted) setState(() => _creating = false);
    }
  }

  Future<void> _pickWorlds(List<World> worlds) async {
    final selected = await showMultiSelectSheet(
      context,
      title: '选择世界',
      options: [for (final w in worlds) MultiSelectOption(w.id, w.name)],
      initial: _worldIds,
    );
    if (selected == null) return;
    setState(() => _worldIds
      ..clear()
      ..addAll(selected));
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final characters = ref.watch(charactersProvider).value ?? [];
    final worlds = ref.watch(worldsProvider).value ?? [];
    final worldbooks = ref.watch(worldbooksProvider).value ?? [];
    final worldNames = [for (final w in worlds) if (_worldIds.contains(w.id)) w.name];
    final worldbookNames = [
      for (final b in worldbooks)
        if (_worldbookIds.contains(b.id)) b.name,
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('新建剧本')),
      body: _creating
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextField(
                  controller: _name,
                  decoration: const InputDecoration(labelText: '剧本名称'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _description,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: '剧本简介'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String?>(
                  initialValue: _characterId,
                  decoration: const InputDecoration(labelText: '角色（可选）'),
                  items: [
                    const DropdownMenuItem<String?>(value: null, child: Text('无角色')),
                    for (final c in characters)
                      DropdownMenuItem<String?>(value: c.id, child: Text(c.name)),
                  ],
                  onChanged: (v) => setState(() => _characterId = v),
                ),
                const SizedBox(height: 16),
                _multiSelectField(
                  context,
                  label: '世界（可选，可多选）',
                  selectedNames: worldNames,
                  onTap: () => _pickWorlds(worlds),
                ),
                const SizedBox(height: 12),
                _multiSelectField(
                  context,
                  label: '世界书（可选，可多选）',
                  selectedNames: worldbookNames,
                  onTap: () => _pickWorldbooks(worldbooks),
                ),
                const SizedBox(height: 24),
                FilledButton(onPressed: _create, child: const Text('创建')),
              ],
            ),
    );
  }
}
