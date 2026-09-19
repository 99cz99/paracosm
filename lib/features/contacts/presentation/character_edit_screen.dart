import 'dart:convert';

import 'package:drift/drift.dart' hide Column;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/db/database.dart';
import '../../../core/providers/db_providers.dart';
import '../../../core/utils/dialogs.dart';
import '../data/character_repository.dart';
import 'contacts_providers.dart';
import 'widgets/avatar_crop_screen.dart';
import 'widgets/character_avatar.dart';

/// Edits an existing character, or creates a new one when [characterId] is null
/// (reuses the same full persona form).
class CharacterEditScreen extends ConsumerStatefulWidget {
  const CharacterEditScreen({super.key, this.characterId});

  final String? characterId;

  @override
  ConsumerState<CharacterEditScreen> createState() =>
      _CharacterEditScreenState();
}

class _CharacterEditScreenState extends ConsumerState<CharacterEditScreen> {
  final _name = TextEditingController();
  final _description = TextEditingController();
  final _personality = TextEditingController();
  final _scenario = TextEditingController();
  final _firstMes = TextEditingController();
  final _systemPrompt = TextEditingController();
  final _mesExample = TextEditingController();
  final _creatorNotes = TextEditingController();
  final _nickname = TextEditingController();
  final _postHistoryInstructions = TextEditingController();
  final _stateSchema = TextEditingController();
  final _tagController = TextEditingController();
  final _virtualAge = TextEditingController();
  final _realAge = TextEditingController();

  Map<String, dynamic> _core = {};
  List<String> _tags = [];
  String? _avatarPath;
  bool _loading = false;

  bool get _isCreate => widget.characterId == null;

  @override
  void initState() {
    super.initState();
    if (!_isCreate) _load();
  }

  Future<void> _load() async {
    final character =
        await ref.read(dbProvider).getCharacter(widget.characterId!);
    if (character == null) return;
    _name.text = character.name;
    _avatarPath = character.avatarPath;
    _core = _decode(character.corePersonaJson);
    _description.text = (_core['description'] ?? '').toString();
    _personality.text = (_core['personality'] ?? '').toString();
    _scenario.text = (_core['scenario'] ?? '').toString();
    _firstMes.text = (_core['first_mes'] ?? '').toString();
    _systemPrompt.text = (_core['system_prompt'] ?? '').toString();
    _mesExample.text = (_core['mes_example'] ?? '').toString();
    _creatorNotes.text = (_core['creator_notes'] ?? '').toString();
    _nickname.text = (_core['nickname'] ?? '').toString();
    _postHistoryInstructions.text =
        (_core['post_history_instructions'] ?? '').toString();
    _stateSchema.text = _encodeStateSchema(_core['state_schema']);
    _tags = _decodeTags(character.tags);
    _virtualAge.text = character.virtualAge ?? '';
    _realAge.text = character.realAge ?? '';
    if (mounted) setState(() {});
  }

  Future<void> _pickAvatar() async {
    final files = await FilePicker.pickFiles(type: FileType.image);
    if (files.isEmpty) return;
    final file = files.first;
    final bytes = await file.readAsBytes();
    if (!mounted) return;
    final cropped = await Navigator.of(context).push<Uint8List>(
      MaterialPageRoute(
        builder: (_) => AvatarCropScreen(imageBytes: Uint8List.fromList(bytes)),
      ),
    );
    if (cropped == null || cropped.isEmpty) return;
    final path = await CharacterRepository(ref.read(dbProvider))
        .saveAvatar(cropped, oldPath: _avatarPath);
    if (!mounted) return;
    setState(() => _avatarPath = path);
  }

  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isEmpty || _tags.contains(tag)) return;
    setState(() => _tags.add(tag));
    _tagController.clear();
  }

  void _removeTag(String tag) => setState(() => _tags.remove(tag));

  Future<void> _save() async {
    final name = _name.text.trim();
    if (name.isEmpty) {
      await showErrorDialog(context, '请填写名称');
      return;
    }
    setState(() => _loading = true);
    final core = Map<String, dynamic>.from(_core);
    core['description'] = _description.text.trim();
    core['personality'] = _personality.text.trim();
    core['scenario'] = _scenario.text.trim();
    core['first_mes'] = _firstMes.text.trim();
    core['system_prompt'] = _systemPrompt.text.trim();
    core['mes_example'] = _mesExample.text.trim();
    core['creator_notes'] = _creatorNotes.text.trim();
    core['nickname'] = _nickname.text.trim();
    core['post_history_instructions'] = _postHistoryInstructions.text.trim();
    final stateSchemaText = _stateSchema.text.trim();
    if (stateSchemaText.isNotEmpty) {
      try {
        final decoded = jsonDecode(stateSchemaText);
        if (decoded is! Map<String, dynamic>) throw const FormatException();
        core['state_schema'] = decoded;
      } catch (_) {
        if (mounted) {
          await showErrorDialog(
            context,
            '状态字段命名需为合法 JSON 对象，如 {"scene":"场景"}',
          );
          setState(() => _loading = false);
        }
        return;
      }
    } else {
      core.remove('state_schema');
    }
    final now = DateTime.now().millisecondsSinceEpoch;

    try {
      if (_isCreate) {
        await CharacterRepository(ref.read(dbProvider)).createCharacter(
          name: name,
          core: core,
          tags: _tags,
          avatarPath: _avatarPath,
          virtualAge: _virtualAge.text.trim(),
          realAge: _realAge.text.trim(),
        );
      } else {
        await ref.read(dbProvider).updateCharacter(
              widget.characterId!,
              CharactersCompanion(
                name: Value(name),
                corePersonaJson: Value(jsonEncode(core)),
                tags: Value(jsonEncode(_tags)),
                avatarPath: Value(_avatarPath),
                virtualAge: Value(_virtualAge.text.trim()),
                realAge: Value(_realAge.text.trim()),
                updatedAt: Value(now),
              ),
            );
        ref.invalidate(characterProvider(widget.characterId!));
      }
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

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _personality.dispose();
    _scenario.dispose();
    _firstMes.dispose();
    _systemPrompt.dispose();
    _mesExample.dispose();
    _creatorNotes.dispose();
    _nickname.dispose();
    _postHistoryInstructions.dispose();
    _stateSchema.dispose();
    _tagController.dispose();
    _virtualAge.dispose();
    _realAge.dispose();
    super.dispose();
  }

  Map<String, dynamic> _decode(String s) {
    try {
      return jsonDecode(s) as Map<String, dynamic>;
    } catch (_) {
      return <String, dynamic>{};
    }
  }

  String _encodeStateSchema(dynamic schema) {
    if (schema is Map && schema.isNotEmpty) {
      return const JsonEncoder.withIndent('  ').convert(schema);
    }
    return '';
  }

  List<String> _decodeTags(String s) {
    try {
      return List<String>.from(jsonDecode(s) as List<dynamic>);
    } catch (_) {
      return <String>[];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isCreate ? '新建角色' : '编辑角色')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Center(
                  child: Column(
                    children: [
                      CharacterAvatar(
                        name: _name.text,
                        avatarPath: _avatarPath,
                        radius: 40,
                      ),
                      TextButton.icon(
                        onPressed: _pickAvatar,
                        icon: const Icon(Icons.image),
                        label: const Text('更换头像'),
                      ),
                    ],
                  ),
                ),
                TextField(
                  controller: _name,
                  decoration: const InputDecoration(labelText: '名称'),
                ),
                const SizedBox(height: 12),
                InputDecorator(
                  decoration: const InputDecoration(labelText: '标签'),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      for (final tag in _tags)
                        Chip(
                          label: Text(tag),
                          onDeleted: () => _removeTag(tag),
                        ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 140,
                            child: TextField(
                              controller: _tagController,
                              decoration: const InputDecoration(
                                hintText: '添加标签',
                                isDense: true,
                                border: InputBorder.none,
                              ),
                              textInputAction: TextInputAction.done,
                              onSubmitted: (_) => _addTag(),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            tooltip: '添加标签',
                            onPressed: _addTag,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _virtualAge,
                  decoration: const InputDecoration(
                    labelText: '虚拟年龄',
                    helperText: '角色的设定/外表年龄，如「外表16岁」',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _realAge,
                  decoration: const InputDecoration(
                    labelText: '真实年龄',
                    helperText: '设定内实际年龄，用于声明成年，如「实际500岁」',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _description,
                  maxLines: 4,
                  decoration: const InputDecoration(labelText: '角色设定'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _personality,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: '性格'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _scenario,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: '场景'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _firstMes,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: '开场白'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _systemPrompt,
                  maxLines: 8,
                  decoration: const InputDecoration(
                    labelText: '系统提示',
                    helperText: '角色的核心行为规则 / 指令（Skill 角色即其 SKILL.md 正文）',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _mesExample,
                  maxLines: 4,
                  decoration: const InputDecoration(labelText: '对话示例'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _creatorNotes,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: '备注'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _nickname,
                  decoration: const InputDecoration(labelText: '昵称'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _postHistoryInstructions,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: '后置指令'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _stateSchema,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: '状态字段命名 (state_schema)',
                    helperText: 'JSON 对象，/status 用它给状态字段命名',
                    hintText: '{"scene":"场景","facts":"已知事实","items":"物品","npcs":"人物"}',
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton(onPressed: _save, child: const Text('保存')),
              ],
            ),
    );
  }
}
