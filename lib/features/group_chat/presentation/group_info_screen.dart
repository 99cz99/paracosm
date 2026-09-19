import 'package:drift/drift.dart' hide Column;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/db/database.dart';
import '../../../core/providers/db_providers.dart';
import '../../../core/providers/llm_providers.dart';
import '../../../core/utils/dialogs.dart';
import '../../../core/utils/multi_select_sheet.dart';
import '../../contacts/presentation/contacts_providers.dart';
import '../../contacts/presentation/widgets/avatar_crop_screen.dart';
import '../../contacts/presentation/widgets/character_avatar.dart';
import '../../worlds/presentation/worlds_providers.dart';
import '../data/group_repository.dart';
import 'group_providers.dart';
import 'widgets/group_avatar.dart';

class GroupInfoScreen extends ConsumerStatefulWidget {
  const GroupInfoScreen({super.key, required this.groupId});

  final String groupId;

  @override
  ConsumerState<GroupInfoScreen> createState() => _GroupInfoScreenState();
}

class _GroupInfoScreenState extends ConsumerState<GroupInfoScreen> {
  @override
  Widget build(BuildContext context) {
    final groupAsync = ref.watch(groupProvider(widget.groupId));
    final members = ref.watch(groupMembersProvider(widget.groupId)).value ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('群信息')),
      body: groupAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('加载失败：$e')),
        data: (group) {
          if (group == null) return const Center(child: Text('群不存在'));
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _header(context, group, members),
              const SizedBox(height: 24),
              Text('成员（${members.length}）',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  for (final m in members)
                    _memberTile(m, () => _removeMember(group, m)),
                  _addTile(context, () => _addMembers(group, members)),
                ],
              ),
              const SizedBox(height: 24),
              _bindingsSection(context, group),
              const SizedBox(height: 24),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.tune),
                title: const Text('采样设置'),
                subtitle: Text(_samplingSummary(group)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _openSamplingSettings(group),
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () => _changeAvatar(group),
                icon: const Icon(Icons.image),
                label: const Text('更换群头像'),
              ),
              const SizedBox(height: 12),
              FilledButton.tonalIcon(
                onPressed: () => _disband(group),
                icon: const Icon(Icons.exit_to_app),
                label: const Text('退出 / 解散群聊'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _header(
    BuildContext context,
    Group group,
    List<GroupMemberWithCharacter> members,
  ) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _changeAvatar(group),
          child: GroupAvatar(
            members: members,
            avatarPath: group.avatarPath,
            size: 72,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _rename(group),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    group.name,
                    style: Theme.of(context).textTheme.titleLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.edit, size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _memberTile(GroupMemberWithCharacter m, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CharacterAvatar(
              name: m.character.name,
              avatarPath: m.character.avatarPath,
              radius: 24,
            ),
            const SizedBox(height: 4),
            Text(
              m.character.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _addTile(BuildContext context, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerHighest,
              child: const Icon(Icons.person_add),
            ),
            const SizedBox(height: 4),
            const Text('邀请', style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Future<void> _rename(Group group) async {
    final controller = TextEditingController(text: group.name);
    final ok = await showDialog<bool>(
      context: context,
      useRootNavigator: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('修改群名称'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: '群名称'),
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
    final name = controller.text.trim();
    if (name.isEmpty) return;
    await GroupRepository(ref.read(dbProvider)).renameGroup(widget.groupId, name);
    ref.invalidate(groupProvider(widget.groupId));
  }

  Widget _bindingsSection(BuildContext context, Group group) {
    final worlds = ref.watch(groupWorldsProvider(widget.groupId)).value ?? [];
    final worldbooks =
        ref.watch(groupWorldbooksProvider(widget.groupId)).value ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('世界与世界书', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.public),
          title: Text(worlds.isEmpty ? '未绑定世界' : worlds.map((w) => w.name).join('、')),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _editWorlds(group),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.menu_book),
          title: Text(worldbooks.isEmpty
              ? '未绑定世界书'
              : worldbooks.map((b) => b.name).join('、')),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _editWorldbooks(group),
        ),
      ],
    );
  }

  Future<void> _editWorlds(Group group) async {
    final db = ref.read(dbProvider);
    final worlds = ref.read(worldsProvider).value ?? [];
    final currentIds = await db.getGroupWorldIds(widget.groupId);
    if (!mounted) return;
    final selected = await showMultiSelectSheet(
      context,
      title: '选择世界',
      options: [for (final w in worlds) MultiSelectOption(w.id, w.name)],
      initial: currentIds.toSet(),
    );
    if (selected == null) return;
    final worldbookIds = await db.getGroupWorldbookIds(widget.groupId);
    await GroupRepository(db).updateGroupWorlds(
      groupId: widget.groupId,
      worldIds: selected,
      worldbookIds: worldbookIds,
    );
  }

  Future<void> _editWorldbooks(Group group) async {
    final db = ref.read(dbProvider);
    final worldbooks = ref.read(worldbooksProvider).value ?? [];
    final currentIds = await db.getGroupWorldbookIds(widget.groupId);
    if (!mounted) return;
    final selected = await showMultiSelectSheet(
      context,
      title: '选择世界书',
      options: [for (final b in worldbooks) MultiSelectOption(b.id, b.name)],
      initial: currentIds.toSet(),
    );
    if (selected == null) return;
    final worldIds = await db.getGroupWorldIds(widget.groupId);
    await GroupRepository(db).updateGroupWorlds(
      groupId: widget.groupId,
      worldIds: worldIds,
      worldbookIds: selected,
    );
  }

  String _samplingSummary(Group group) {
    final parts = <String>[];
    if (group.providerId != null && group.providerId!.isNotEmpty) {
      parts.add('API');
    }
    if (group.temperature != null) parts.add('temperature ${group.temperature}');
    if (group.maxTokens != null) parts.add('maxTokens ${group.maxTokens}');
    return parts.isEmpty ? '默认参数' : parts.join(' · ');
  }

  Future<void> _openSamplingSettings(Group group) async {
    final configs = ref.read(providerConfigsProvider).value ?? [];
    final presets = await ref.read(dbProvider).watchPresets().first;
    if (!mounted) return;
    final result = await showDialog<_GroupSamplingResult>(
      context: context,
      useRootNavigator: false,
      builder: (_) => _GroupSamplingDialog(
        group: group,
        configs: configs,
        presets: presets,
      ),
    );
    if (result == null) return;
    await ref.read(dbProvider).updateGroup(widget.groupId, GroupsCompanion(
      providerId: Value(result.providerId),
      temperature: Value(result.temperature),
      topP: Value(result.topP),
      maxTokens: Value(result.maxTokens),
      presencePenalty: Value(result.presencePenalty),
      frequencyPenalty: Value(result.frequencyPenalty),
    ));
    ref.invalidate(groupProvider(widget.groupId));
  }

  Future<void> _removeMember(
    Group group,
    GroupMemberWithCharacter m,
  ) async {
    final ok = await showConfirmDialog(
      context,
      title: '移除成员',
      message: '确定把「${m.character.name}」移出群聊？',
    );
    if (!ok) return;
    await GroupRepository(ref.read(dbProvider))
        .removeMember(widget.groupId, m.member.characterId);
  }

  Future<void> _addMembers(
    Group group,
    List<GroupMemberWithCharacter> members,
  ) async {
    final characters = ref.read(charactersProvider).value ?? [];
    final existingIds = members.map((m) => m.member.characterId).toSet();
    final candidates =
        characters.where((c) => !existingIds.contains(c.id)).toList();
    if (candidates.isEmpty) {
      await showErrorDialog(context, '没有可添加的角色');
      return;
    }
    final selected = await showModalBottomSheet<List<String>>(
      context: context,
      builder: (_) => _AddMembersSheet(candidates: candidates),
    );
    if (selected == null || selected.isEmpty) return;
    await GroupRepository(ref.read(dbProvider))
        .addMembers(widget.groupId, selected);
  }

  Future<void> _changeAvatar(Group group) async {
    final files = await FilePicker.pickFiles(type: FileType.image);
    if (files.isEmpty) return;
    final file = files.first;
    final bytes = await file.readAsBytes();
    if (!mounted) return;
    final cropped = await Navigator.of(context).push<Uint8List>(
      MaterialPageRoute(
        builder: (_) => AvatarCropScreen(imageBytes: bytes),
      ),
    );
    if (cropped == null || cropped.isEmpty) return;
    final repo = GroupRepository(ref.read(dbProvider));
    final path = await repo.saveGroupAvatar(cropped, oldPath: group.avatarPath);
    await repo.setGroupAvatar(widget.groupId, path);
    ref.invalidate(groupProvider(widget.groupId));
  }

  Future<void> _disband(Group group) async {
    final ok = await showConfirmDialog(
      context,
      title: '解散群聊',
      message: '确定解散「${group.name}」？群聊消息和成员关系都会被删除。',
    );
    if (!ok) return;
    await GroupRepository(ref.read(dbProvider)).deleteGroup(widget.groupId);
    if (mounted) context.go('/chat');
  }
}

class _AddMembersSheet extends StatefulWidget {
  const _AddMembersSheet({required this.candidates});

  final List<Character> candidates;

  @override
  State<_AddMembersSheet> createState() => _AddMembersSheetState();
}

class _AddMembersSheetState extends State<_AddMembersSheet> {
  final Set<String> _selected = {};

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('添加成员',
                style: Theme.of(context).textTheme.titleMedium),
          ),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final c in widget.candidates)
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
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton(
              onPressed: () => Navigator.of(context).pop(_selected.toList()),
              child: const Text('确定'),
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupSamplingResult {
  const _GroupSamplingResult({
    this.providerId,
    this.temperature,
    this.topP,
    this.maxTokens,
    this.presencePenalty,
    this.frequencyPenalty,
  });

  final String? providerId;
  final double? temperature;
  final double? topP;
  final int? maxTokens;
  final double? presencePenalty;
  final double? frequencyPenalty;
}

class _GroupSamplingDialog extends StatefulWidget {
  const _GroupSamplingDialog({
    required this.group,
    required this.configs,
    required this.presets,
  });

  final Group group;
  final List<ProviderConfig> configs;
  final List<Preset> presets;

  @override
  State<_GroupSamplingDialog> createState() => _GroupSamplingDialogState();
}

class _GroupSamplingDialogState extends State<_GroupSamplingDialog> {
  String? _providerId;
  late final TextEditingController _temperature = TextEditingController(
      text: widget.group.temperature?.toString() ?? '');
  late final TextEditingController _topP =
      TextEditingController(text: widget.group.topP?.toString() ?? '');
  late final TextEditingController _maxTokens = TextEditingController(
      text: widget.group.maxTokens?.toString() ?? '');
  late final TextEditingController _presence = TextEditingController(
      text: widget.group.presencePenalty?.toString() ?? '');
  late final TextEditingController _frequency = TextEditingController(
      text: widget.group.frequencyPenalty?.toString() ?? '');

  @override
  void initState() {
    super.initState();
    _providerId = widget.group.providerId;
  }

  @override
  void dispose() {
    _temperature.dispose();
    _topP.dispose();
    _maxTokens.dispose();
    _presence.dispose();
    _frequency.dispose();
    super.dispose();
  }

  void _applyPreset(Preset p) {
    setState(() {
      _providerId = p.providerId;
      _temperature.text = p.temperature?.toString() ?? '';
      _topP.text = p.topP?.toString() ?? '';
      _maxTokens.text = p.maxTokens?.toString() ?? '';
      _presence.text = p.presencePenalty?.toString() ?? '';
      _frequency.text = p.frequencyPenalty?.toString() ?? '';
    });
  }

  static double? _d(String s) =>
      s.trim().isEmpty ? null : double.tryParse(s.trim());
  static int? _i(String s) => s.trim().isEmpty ? null : int.tryParse(s.trim());

  void _submit() {
    Navigator.of(context).pop(_GroupSamplingResult(
      providerId: _providerId,
      temperature: _d(_temperature.text),
      topP: _d(_topP.text),
      maxTokens: _i(_maxTokens.text),
      presencePenalty: _d(_presence.text),
      frequencyPenalty: _d(_frequency.text),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('采样设置'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.presets.isNotEmpty) ...[
              Text('套用预设', style: Theme.of(context).textTheme.labelMedium),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                children: [
                  for (final p in widget.presets)
                    ActionChip(
                      label: Text(p.name),
                      onPressed: () => _applyPreset(p),
                    ),
                ],
              ),
              const SizedBox(height: 12),
            ],
            DropdownButtonFormField<String?>(
              initialValue: _providerId,
              decoration: const InputDecoration(labelText: 'API Provider'),
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
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'temperature',
                helperText: '越高越发散、随机，越低越确定、保守（常用 0.6–1.2）',
                helperMaxLines: 3,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _topP,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
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
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Presence Penalty',
                helperText: '惩罚已出现过的词，鼓励聊新话题（-2–2）',
                helperMaxLines: 3,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _frequency,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
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
        TextButton(
            onPressed: () => Navigator.of(context).pop(), child: const Text('取消')),
        FilledButton(onPressed: _submit, child: const Text('保存')),
      ],
    );
  }
}
