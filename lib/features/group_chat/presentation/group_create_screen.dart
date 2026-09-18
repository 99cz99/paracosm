import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/db/database.dart';
import '../../../core/providers/db_providers.dart';
import '../../../core/utils/dialogs.dart';
import '../../../core/utils/multi_select_sheet.dart';
import '../../contacts/presentation/contacts_providers.dart';
import '../../contacts/presentation/widgets/character_avatar.dart';
import '../../worlds/presentation/worlds_providers.dart';
import '../data/group_repository.dart';

class GroupCreateScreen extends ConsumerStatefulWidget {
  const GroupCreateScreen({super.key});

  @override
  ConsumerState<GroupCreateScreen> createState() => _GroupCreateScreenState();
}

class _GroupCreateScreenState extends ConsumerState<GroupCreateScreen> {
  final _name = TextEditingController();
  final Set<String> _worldIds = {};
  final Set<String> _worldbookIds = {};
  String _speakMode = 'auto';
  final Set<String> _selected = {};
  bool _creating = false;

  Future<void> _create() async {
    final name = _name.text.trim();
    if (name.isEmpty) {
      await showErrorDialog(context, '请填写群名称');
      return;
    }
    if (_selected.length < 2) {
      await showErrorDialog(context, '群聊至少需要两个角色');
      return;
    }
    setState(() => _creating = true);
    try {
      final groupId = await GroupRepository(ref.read(dbProvider)).createGroup(
        name: name,
        characterIds: _selected.toList(),
        worldIds: _worldIds.toList(),
        worldbookIds: _worldbookIds.toList(),
        speakMode: _speakMode,
      );
      if (mounted) context.go('/chat/group/$groupId');
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
      appBar: AppBar(title: const Text('创建群聊')),
      body: _creating
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextField(
                  controller: _name,
                  decoration: const InputDecoration(labelText: '群名称'),
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
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _speakMode,
                  decoration: const InputDecoration(labelText: '发言模式'),
                  items: const [
                    DropdownMenuItem(value: 'auto', child: Text('自动（AI 决定）')),
                    DropdownMenuItem(value: 'turn', child: Text('轮流')),
                    DropdownMenuItem(value: 'call', child: Text('点名（@角色）')),
                  ],
                  onChanged: (v) => setState(() => _speakMode = v ?? 'auto'),
                ),
                const SizedBox(height: 16),
                Text('选择角色（至少 2 个）',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                for (final c in characters)
                  CheckboxListTile(
                    value: _selected.contains(c.id),
                    onChanged: (v) => setState(() {
                      if (v == true) {
                        _selected.add(c.id);
                      } else {
                        _selected.remove(c.id);
                      }
                    }),
                    secondary: CharacterAvatar(
                      name: c.name,
                      avatarPath: c.avatarPath,
                      radius: 16,
                    ),
                    title: Text(c.name),
                  ),
                const SizedBox(height: 24),
                FilledButton(onPressed: _create, child: const Text('创建')),
              ],
            ),
    );
  }
}
