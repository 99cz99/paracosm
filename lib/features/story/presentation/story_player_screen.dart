import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/db/database.dart';
import '../../../core/network/llm/llm_provider.dart';
import '../../../core/network/llm/provider_factory.dart';
import '../../../core/providers/db_providers.dart';
import '../../../core/providers/llm_providers.dart';
import '../../../core/utils/app_exception.dart';
import '../../../core/utils/dialogs.dart';
import '../data/story_repository.dart';
import '../data/story_service.dart';

class StoryPlayerScreen extends ConsumerStatefulWidget {
  const StoryPlayerScreen({super.key, required this.storyId});

  final String storyId;

  @override
  ConsumerState<StoryPlayerScreen> createState() => _StoryPlayerScreenState();
}

class _StoryPlayerScreenState extends ConsumerState<StoryPlayerScreen> {
  Story? _story;
  StoryNode? _currentNode;
  bool _generating = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _refresh();
    if (_currentNode == null && _story != null && !_generating) {
      await _generateRoot();
    }
  }

  Future<void> _refresh() async {
    final db = ref.read(dbProvider);
    final story = await db.getStory(widget.storyId);
    if (story == null) return;
    final node = story.currentNodeId == null
        ? null
        : await db.getStoryNode(story.currentNodeId!);
    if (!mounted) return;
    setState(() {
      _story = story;
      _currentNode = node;
    });
  }

  Future<LlmProvider?> _resolveProvider() async {
    final db = ref.read(dbProvider);
    final config =
        await resolveActiveProvider(db, ref.read(secureKeyStoreProvider));
    return config == null ? null : buildLlmProvider(config);
  }

  Future<void> _generateRoot() async {
    final provider = await _resolveProvider();
    if (!mounted) return;
    if (provider == null) {
      await showErrorDialog(context, '请先在「我」中配置 API Provider');
      return;
    }
    setState(() => _generating = true);
    try {
      final result = await StoryService(ref.read(dbProvider))
          .generateNode(storyId: widget.storyId, provider: provider);
      await StoryRepository(ref.read(dbProvider)).addNode(
        storyId: widget.storyId,
        narrative: result.narrative,
        choices: result.choices,
        depth: 0,
      );
      await _refresh();
    } catch (e) {
      if (mounted) {
        await showErrorDialog(context, e is AppException ? e.message : '生成失败：$e');
      }
    } finally {
      if (mounted) setState(() => _generating = false);
    }
  }

  Future<void> _choose(int index) async {
    if (_generating || _currentNode == null) return;
    final parent = _currentNode!;

    // Reuse an already-generated child for this choice instead of stacking a
    // duplicate branch.
    final existing = await ref
        .read(dbProvider)
        .getChildByChosenIndex(widget.storyId, parent.id, index);
    if (existing != null) {
      await StoryRepository(ref.read(dbProvider))
          .setCurrentNode(widget.storyId, existing.id);
      await _refresh();
      return;
    }

    final provider = await _resolveProvider();
    if (!mounted) return;
    if (provider == null) {
      await showErrorDialog(context, '请先在「我」中配置 API Provider');
      return;
    }
    setState(() => _generating = true);
    try {
      final result = await StoryService(ref.read(dbProvider))
          .generateNode(storyId: widget.storyId, provider: provider);
      await StoryRepository(ref.read(dbProvider)).addNode(
        storyId: widget.storyId,
        parentId: parent.id,
        narrative: result.narrative,
        choices: result.choices,
        chosenIndex: index,
        depth: parent.depth + 1,
      );
      await _refresh();
    } catch (e) {
      if (mounted) {
        await showErrorDialog(context, e is AppException ? e.message : '生成失败：$e');
      }
    } finally {
      if (mounted) setState(() => _generating = false);
    }
  }

  Future<void> _backtrack() async {
    final current = _currentNode;
    if (current == null || current.parentId == null) {
      await showErrorDialog(context, '已经是开头了');
      return;
    }
    await StoryRepository(ref.read(dbProvider))
        .setCurrentNode(widget.storyId, current.parentId);
    await _refresh();
  }

  /// Regenerates the current node's narrative/choices in place.
  Future<void> _regenerate() async {
    final current = _currentNode;
    if (_generating || current == null) return;
    final provider = await _resolveProvider();
    if (!mounted) return;
    if (provider == null) {
      await showErrorDialog(context, '请先在「我」中配置 API Provider');
      return;
    }
    setState(() => _generating = true);
    try {
      final result = await StoryService(ref.read(dbProvider)).generateNode(
        storyId: widget.storyId,
        provider: provider,
        parentNodeId: current.parentId,
      );
      await StoryRepository(ref.read(dbProvider)).regenerateNode(
        widget.storyId,
        current.id,
        result.narrative,
        result.choices,
      );
      await _refresh();
    } catch (e) {
      if (mounted) {
        await showErrorDialog(context, e is AppException ? e.message : '生成失败：$e');
      }
    } finally {
      if (mounted) setState(() => _generating = false);
    }
  }

  Future<void> _jumpTo(String nodeId) async {
    await StoryRepository(ref.read(dbProvider))
        .setCurrentNode(widget.storyId, nodeId);
    await _refresh();
  }

  Future<void> _restart() async {
    final db = ref.read(dbProvider);
    final nodes = await db.getStoryNodes(widget.storyId);
    final root = nodes.where((n) => n.parentId == null).firstOrNull;
    await StoryRepository(db).setCurrentNode(widget.storyId, root?.id);
    await _refresh();
  }

  Future<void> _editNode(StoryNode node) async {
    final narrativeController = TextEditingController(text: node.narrative);
    final choicesController =
        TextEditingController(text: _choices(node).join('\n'));
    final ok = await showDialog<bool>(
      context: context,
      useRootNavigator: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('编辑节点'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: narrativeController,
                maxLines: 6,
                decoration: const InputDecoration(labelText: '叙述'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: choicesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: '选项（每行一个，留空 = 结局）',
                ),
              ),
            ],
          ),
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
    final choices = choicesController.text
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    await StoryRepository(ref.read(dbProvider))
        .editNode(node.id, narrativeController.text.trim(), choices);
    await _refresh();
  }

  Future<void> _deleteNode(StoryNode node) async {
    final ok = await showConfirmDialog(
      context,
      title: '删除分支',
      message: '确定删除该节点及其所有后续分支？',
      confirmLabel: '删除',
    );
    if (!ok) return;
    await StoryRepository(ref.read(dbProvider))
        .deleteSubtree(widget.storyId, node.id);
    await _refresh();
  }

  Future<void> _save() async {
    final controller = TextEditingController();
    final label = await showDialog<String>(
      context: context,
      useRootNavigator: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('存档'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: '存档名称'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(controller.text.trim()),
            child: const Text('保存'),
          ),
        ],
      ),
    );
    if (label == null || label.isEmpty) return;
    await StoryRepository(ref.read(dbProvider)).save(
      storyId: widget.storyId,
      label: label,
      currentNodeId: _currentNode?.id,
    );
    if (mounted) await showSuccessDialog(context, '已存档');
  }

  Future<void> _quicksave() async {
    final db = ref.read(dbProvider);
    final existing = await db.getQuickSave(widget.storyId);
    if (existing != null) await db.deleteStorySave(existing.id);
    await StoryRepository(db).save(
      storyId: widget.storyId,
      label: '快速存档',
      currentNodeId: _currentNode?.id,
      isQuick: true,
    );
    if (mounted) await showSuccessDialog(context, '已快速存档');
  }

  Future<void> _load() async {
    if (_generating) {
      await showErrorDialog(context, '剧情正在生成中，请稍后再读档');
      return;
    }
    final saves = await ref.read(dbProvider).getStorySaves(widget.storyId);
    if (!mounted) return;
    if (saves.isEmpty) {
      await showErrorDialog(context, '还没有存档');
      return;
    }
    final save = await showModalBottomSheet<StorySave>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text('读档',
                  style: Theme.of(sheetContext).textTheme.titleMedium),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final s in saves)
                    ListTile(
                      title: Text(s.label),
                      subtitle: Text(
                        '${s.isQuick ? '快速存档 · ' : ''}${_formatTime(s.savedAt)}',
                      ),
                      leading: Icon(s.isQuick ? Icons.bolt : Icons.save),
                      onTap: () => Navigator.of(sheetContext).pop(s),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    if (save == null) return;
    if (!mounted) return;
    if (save.currentNodeId == null) {
      await showErrorDialog(context, '该存档没有记录剧情进度');
      return;
    }
    try {
      await StoryRepository(ref.read(dbProvider))
          .setCurrentNode(widget.storyId, save.currentNodeId);
      await _refresh();
    } catch (e) {
      if (mounted) await showErrorDialog(context, '读档失败：$e');
      return;
    }
    if (mounted) await showSuccessDialog(context, '已读档');
  }

  Future<void> _showBranchTree() async {
    final nodes = await ref.read(dbProvider).getStoryNodes(widget.storyId);
    if (!mounted) return;
    if (nodes.isEmpty) return;
    final flattened = _flattenTree(nodes);
    await showDialog<void>(
      context: context,
      useRootNavigator: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('分支树（点按跳转，长按编辑/删除）'),
        content: SizedBox(
          width: 400,
          height: 480,
          child: _StoryTreeView(
            flattened: flattened,
            currentNodeId: _currentNode?.id,
            onJump: (node) {
              Navigator.of(dialogContext).pop();
              _jumpTo(node.id);
            },
            onEdit: (node) {
              Navigator.of(dialogContext).pop();
              _editNode(node);
            },
            onDelete: (node) {
              Navigator.of(dialogContext).pop();
              _deleteNode(node);
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  List<(StoryNode, int)> _flattenTree(List<StoryNode> nodes) {
    final byParent = <String?, List<StoryNode>>{};
    for (final n in nodes) {
      byParent.putIfAbsent(n.parentId, () => []).add(n);
    }
    final result = <(StoryNode, int)>[];
    void visit(String? parentId, int depth) {
      final children = byParent[parentId] ?? [];
      children.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      for (final c in children) {
        result.add((c, depth));
        visit(c.id, depth + 1);
      }
    }

    visit(null, 0);
    return result;
  }

  List<String> _choices(StoryNode node) {
    try {
      return List<String>.from(jsonDecode(node.choicesJson) as List<dynamic>);
    } catch (_) {
      return const <String>[];
    }
  }

  String _formatTime(int ms) =>
      DateFormat('MM-dd HH:mm').format(DateTime.fromMillisecondsSinceEpoch(ms));

  @override
  Widget build(BuildContext context) {
    final node = _currentNode;
    final choices = node == null ? const <String>[] : _choices(node);

    return Scaffold(
      appBar: AppBar(
        title: Text(_story?.name ?? '剧情'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: '剧本信息',
            onPressed: () async {
              await context.push('/story/${widget.storyId}/edit');
              if (mounted) await _refresh();
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_tree_outlined),
            tooltip: '分支树',
            onPressed: _showBranchTree,
          ),
          IconButton(
            icon: const Icon(Icons.save_outlined),
            tooltip: '存档',
            onPressed: _save,
          ),
          IconButton(
            icon: const Icon(Icons.folder_open),
            tooltip: '读档',
            onPressed: _load,
          ),
          IconButton(
            icon: const Icon(Icons.bolt),
            tooltip: '快速存档',
            onPressed: _quicksave,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2B2440), Color(0xFF1A1528)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: _generating
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white70),
                      )
                    : node == null
                        ? Center(
                            child: FilledButton.tonal(
                              onPressed: _generateRoot,
                              child: const Text('重新生成'),
                            ),
                          )
                        : SingleChildScrollView(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              choices.isEmpty
                                  ? '${node.narrative}\n\n—— 已结局 ——'
                                  : node.narrative,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                height: 1.8,
                              ),
                            ),
                          ),
              ),
              _bottomPanel(context, choices),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomPanel(BuildContext context, List<String> choices) {
    final ended = _currentNode != null && choices.isEmpty;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!_generating && choices.isNotEmpty)
            for (var i = 0; i < choices.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton.tonal(
                    onPressed: () => _choose(i),
                    child: Text(choices[i]),
                  ),
                ),
              ),
          if (ended)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _restart,
                  child: const Text('回到开头'),
                ),
              ),
            ),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 4,
            children: [
              TextButton.icon(
                onPressed: _backtrack,
                icon: const Icon(Icons.undo),
                label: const Text('回退'),
              ),
              TextButton.icon(
                onPressed: _regenerate,
                icon: const Icon(Icons.refresh),
                label: const Text('重来'),
              ),
              TextButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save_outlined),
                label: const Text('存档'),
              ),
              TextButton.icon(
                onPressed: _load,
                icon: const Icon(Icons.folder_open),
                label: const Text('读档'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StoryTreeView extends StatelessWidget {
  const _StoryTreeView({
    required this.flattened,
    required this.currentNodeId,
    required this.onJump,
    required this.onEdit,
    required this.onDelete,
  });

  final List<(StoryNode, int)> flattened;
  final String? currentNodeId;
  final ValueChanged<StoryNode> onJump;
  final ValueChanged<StoryNode> onEdit;
  final ValueChanged<StoryNode> onDelete;

  String _summary(StoryNode node) {
    final text = node.narrative.length > 20
        ? '${node.narrative.substring(0, 20)}…'
        : node.narrative;
    final choices = _decodeChoices(node.choicesJson);
    if (node.chosenIndex != null && node.chosenIndex! < choices.length) {
      return '$text（选：${choices[node.chosenIndex!]}）';
    }
    return text;
  }

  List<String> _decodeChoices(String json) {
    try {
      return List<String>.from(jsonDecode(json) as List<dynamic>);
    } catch (_) {
      return const <String>[];
    }
  }

  Future<void> _showMenu(BuildContext context, StoryNode node) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.play_arrow),
              title: const Text('跳转到这里'),
              onTap: () => Navigator.of(sheetContext).pop('jump'),
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('编辑'),
              onTap: () => Navigator.of(sheetContext).pop('edit'),
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('删除此分支', style: TextStyle(color: Colors.red)),
              onTap: () => Navigator.of(sheetContext).pop('delete'),
            ),
          ],
        ),
      ),
    );
    if (action == 'jump') onJump(node);
    if (action == 'edit') onEdit(node);
    if (action == 'delete') onDelete(node);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final (node, depth) in flattened)
            InkWell(
              onTap: () => onJump(node),
              onLongPress: () => _showMenu(context, node),
              child: Padding(
                padding: EdgeInsets.only(left: depth * 20.0, top: 4, bottom: 4),
                child: Row(
                  children: [
                    Text(
                      depth == 0 ? '● ' : '└─ ',
                      style: const TextStyle(fontSize: 12),
                    ),
                    Expanded(
                      child: Text(
                        _summary(node),
                        style: TextStyle(
                          fontWeight: node.id == currentNodeId
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: node.id == currentNodeId
                              ? Theme.of(context).colorScheme.primary
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
