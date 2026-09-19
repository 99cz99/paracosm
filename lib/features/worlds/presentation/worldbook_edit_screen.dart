import 'dart:convert';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../core/db/database.dart';
import '../../../core/import/worldbook_exporter.dart';
import '../../../core/network/llm/provider_factory.dart';
import '../../../core/network/llm/translator.dart';
import '../../../core/providers/db_providers.dart';
import '../../../core/providers/llm_providers.dart';
import '../../../core/utils/dialogs.dart';

/// Manual worldbook editor: name/description + a list of keyword-triggered
/// entries. Existing `sources` (imported game text) are preserved on edit.
class WorldbookEditScreen extends ConsumerStatefulWidget {
  const WorldbookEditScreen({super.key, this.worldbookId});

  final String? worldbookId;

  @override
  ConsumerState<WorldbookEditScreen> createState() =>
      _WorldbookEditScreenState();
}

class _WorldbookEditScreenState extends ConsumerState<WorldbookEditScreen> {
  final _name = TextEditingController();
  final _description = TextEditingController();
  final List<_EntryController> _entries = [];
  List<dynamic> _sources = const [];
  bool _loading = false;
  bool _translating = false;
  final _testController = TextEditingController();
  String _testResult = '';

  @override
  void initState() {
    super.initState();
    if (widget.worldbookId != null) _load();
  }

  Future<void> _load() async {
    final book = await ref.read(dbProvider).getWorldbook(widget.worldbookId!);
    if (book == null) return;
    _name.text = book.name;
    _description.text = book.description;
    Map<String, dynamic> data;
    try {
      data = jsonDecode(book.bookJson) as Map<String, dynamic>;
    } catch (_) {
      data = const {};
    }
    final entries = data['entries'];
    if (entries is List) {
      for (final e in entries) {
        if (e is! Map) continue;
        final keys = e['keys'] is List
            ? (e['keys'] as List).map((k) => k.toString()).join(', ')
            : '';
        _entries.add(_EntryController(
          name: (e['comment'] ?? '').toString(),
          keys: keys,
          content: (e['content'] ?? '').toString(),
          original: Map<String, dynamic>.from(e),
        ));
      }
    }
    _sources = data['sources'] is List ? data['sources'] as List : const [];
    if (mounted) setState(() {});
  }

  Future<void> _export() async {
    final id = widget.worldbookId;
    if (id == null) return;
    final book = await ref.read(dbProvider).getWorldbook(id);
    if (book == null) return;
    final json = exportWorldbookJson(
      name: book.name,
      description: book.description,
      bookJson: book.bookJson,
    );
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      useRootNavigator: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('导出世界书'),
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

  Future<void> _save() async {
    final name = _name.text.trim();
    if (name.isEmpty) {
      await showErrorDialog(context, '请填写世界书名称');
      return;
    }
    final entries = <Map<String, dynamic>>[];
    for (final e in _entries) {
      final keys = e.keys.text
          .split(RegExp(r'[,，、]'))
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
      final content = e.content.text.trim();
      if (keys.isEmpty && content.isEmpty) continue;
      entries.add({
        ...e.original,
        'comment': e.name.text.trim(),
        'keys': keys,
        'content': content,
        'enabled': true,
        'constant': false,
      });
    }
    final bookJson = <String, dynamic>{
      'name': name,
      'description': _description.text.trim(),
      'entries': entries,
      if (_sources.isNotEmpty) 'sources': _sources,
    };

    setState(() => _loading = true);
    final db = ref.read(dbProvider);
    final now = DateTime.now().millisecondsSinceEpoch;
    try {
      if (widget.worldbookId == null) {
        await db.insertWorldbook(WorldbooksCompanion.insert(
          id: const Uuid().v4(),
          name: name,
          description: Value(_description.text.trim()),
          bookJson: Value(jsonEncode(bookJson)),
          sourceType: const Value('manual'),
          createdAt: now,
          updatedAt: now,
        ));
      } else {
        await db.updateWorldbook(widget.worldbookId!, WorldbooksCompanion(
          name: Value(name),
          description: Value(_description.text.trim()),
          bookJson: Value(jsonEncode(bookJson)),
          updatedAt: Value(now),
        ));
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

  void _addEntry() => setState(() => _entries.add(_EntryController()));

  /// Tests which entries' keywords match a sample text, so users can verify
  /// triggering before saving. Mirrors `WorldbookMatcher._containsAny`.
  void _testTrigger() {
    final input = _testController.text.trim();
    if (input.isEmpty) {
      setState(() => _testResult = '请输入一段文字');
      return;
    }
    final matched = <String>[];
    for (final e in _entries) {
      final name = e.name.text.trim();
      final keys = e.keys.text
          .split(RegExp(r'[,，、]'))
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
      final hits = keys.where((k) => input.contains(k)).toList();
      if (hits.isNotEmpty) {
        matched.add('· ${name.isEmpty ? '（无名称条目）' : name}：'
            '命中 ${hits.map((h) => '「$h」').join('、')}');
      }
    }
    setState(() {
      _testResult = matched.isEmpty
          ? '没有命中任何条目，请检查并修改词条的关键词'
          : '命中 ${matched.length} 条：\n${matched.join('\n')}';
    });
  }

  /// Translates all English entry keys to Chinese and appends them, so the
  /// worldbook triggers on Chinese messages too.
  Future<void> _translateKeys() async {
    setState(() => _translating = true);
    try {
      final db = ref.read(dbProvider);
      final store = ref.read(secureKeyStoreProvider);
      final config = await resolveActiveProvider(db, store);
      if (config == null) {
        if (mounted) {
          await showErrorDialog(context, '请先在「我」中配置 API Provider');
        }
        return;
      }

      final allKeys = <String>[];
      for (final e in _entries) {
        final keys = e.keys.text
            .split(RegExp(r'[,，、]'))
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty);
        allKeys.addAll(keys.where(needsTranslation));
      }
      if (allKeys.isEmpty) {
        if (mounted) await showSuccessDialog(context, '没有需要翻译的英文关键词');
        return;
      }

      final translated = await translateKeys(buildLlmProvider(config), allKeys);
      if (translated.isEmpty) {
        if (mounted) {
          await showErrorDialog(context, '翻译失败，请检查 API Provider 或重试');
        }
        return;
      }

      for (final e in _entries) {
        final keys = e.keys.text
            .split(RegExp(r'[,，、]'))
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList();
        final newKeys = <String>[];
        for (final k in keys) {
          newKeys.add(k);
          final zh = translated[k];
          if (zh != null && zh.isNotEmpty && zh != k) newKeys.add(zh);
        }
        e.keys.text = newKeys.join(', ');
      }
      if (mounted) await showSuccessDialog(context, '已翻译关键词，请检查并保存');
    } catch (e) {
      if (mounted) await showErrorDialog(context, '翻译失败：$e');
    } finally {
      if (mounted) setState(() => _translating = false);
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _testController.dispose();
    for (final e in _entries) {
      e.name.dispose();
      e.keys.dispose();
      e.content.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.worldbookId == null ? '新建世界书' : '编辑世界书'),
        actions: [
          if (widget.worldbookId != null)
            IconButton(
              icon: const Icon(Icons.ios_share),
              tooltip: '导出世界书',
              onPressed: _export,
            ),
        ],
      ),
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
                  decoration: const InputDecoration(labelText: '描述'),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: _translating ? null : _translateKeys,
                  icon: _translating
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.translate),
                  label: Text(_translating ? '翻译中…' : '翻译关键词（英→中）'),
                ),
                const SizedBox(height: 16),
                Text('测试触发', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                TextField(
                  controller: _testController,
                  decoration: const InputDecoration(
                    labelText: '输入一段文字',
                    hintText: '模拟最近消息，测试哪些条目会被触发',
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: _testTrigger,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('测试'),
                ),
                if (_testResult.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(_testResult),
                ],
                const SizedBox(height: 16),
                Text('条目', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                for (var i = 0; i < _entries.length; i++) _entryCard(i),
                TextButton.icon(
                  onPressed: _addEntry,
                  icon: const Icon(Icons.add),
                  label: const Text('添加条目'),
                ),
                const SizedBox(height: 24),
                FilledButton(onPressed: _save, child: const Text('保存')),
              ],
            ),
    );
  }

  Widget _entryCard(int index) {
    final e = _entries[index];
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: e.name,
              decoration: const InputDecoration(labelText: '名称'),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: e.keys,
                    decoration: const InputDecoration(labelText: '关键词（逗号分隔）'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: '删除条目',
                  onPressed: () => setState(() {
                    _entries.removeAt(index);
                    e.name.dispose();
                    e.keys.dispose();
                    e.content.dispose();
                  }),
                ),
              ],
            ),
            TextField(
              controller: e.content,
              maxLines: 4,
              decoration: const InputDecoration(labelText: '内容'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EntryController {
  _EntryController({
    String name = '',
    String keys = '',
    String content = '',
    Map<String, dynamic>? original,
  })  : name = TextEditingController(text: name),
        keys = TextEditingController(text: keys),
        content = TextEditingController(text: content),
        original = original ?? const {};

  final TextEditingController name;
  final TextEditingController keys;
  final TextEditingController content;

  /// The original entry map, kept so extra fields (priority/position/…) survive
  /// an edit round-trip.
  final Map<String, dynamic> original;
}
