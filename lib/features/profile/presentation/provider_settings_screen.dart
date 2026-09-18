import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/db/database.dart';
import '../../../core/network/llm/llm_provider.dart';
import '../../../core/network/llm/provider_config.dart';
import '../../../core/network/llm/provider_factory.dart';
import '../../../core/providers/db_providers.dart';
import '../../../core/providers/llm_providers.dart';
import '../../../core/storage/secure_storage.dart';
import '../../../core/utils/app_exception.dart';
import '../../../core/utils/dialogs.dart';

class ProviderSettingsScreen extends ConsumerWidget {
  const ProviderSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configsAsync = ref.watch(providerConfigsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('API Provider')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(context, ref),
        child: const Icon(Icons.add),
      ),
      body: configsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('加载失败：$e')),
        data: (configs) {
          if (configs.isEmpty) {
            return const Center(child: Text('还没有配置，点右下角添加'));
          }
          return ListView.builder(
            itemCount: configs.length,
            itemBuilder: (context, index) {
              final c = configs[index];
              return ListTile(
                leading: Icon(
                  c.type == 'anthropic' ? Icons.smart_toy : Icons.hub_outlined,
                ),
                title: Text(c.name),
                subtitle: Text('${c.type} · ${c.model}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      c.isDefault
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: c.isDefault
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      tooltip: '编辑',
                      onPressed: () => _openForm(context, ref, existing: c),
                    ),
                  ],
                ),
                onTap: () => _selectProvider(ref, c),
                onLongPress: () => _showMenu(context, ref, c),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _openForm(
    BuildContext context,
    WidgetRef ref, {
    ProviderConfig? existing,
  }) async {
    String? existingKey;
    if (existing != null) {
      existingKey =
          await ref.read(secureKeyStoreProvider).read(SecureKeyStore.keyForProvider(existing.id)) ?? '';
    }

    if (!context.mounted) return;
    final result = await showDialog<_ProviderFormResult>(
      context: context,
      useRootNavigator: false,
      builder: (_) => _ProviderFormDialog(existing: existing, existingKey: existingKey),
    );
    if (result == null) return;

    final db = ref.read(dbProvider);
    final store = ref.read(secureKeyStoreProvider);
    final now = DateTime.now().millisecondsSinceEpoch;

    if (existing == null) {
      final id = const Uuid().v4();
      await db.insertProviderConfig(ProviderConfigsCompanion.insert(
        id: id,
        name: result.name,
        type: result.type.name,
        baseUrl: result.baseUrl,
        model: result.model,
        apiKeyRef: Value(SecureKeyStore.keyForProvider(id)),
        isDefault: Value(result.isDefault),
        memoryModel: Value(result.memoryModel),
        contextWindowLimit: Value(result.contextWindowLimit),
        createdAt: now,
        updatedAt: now,
      ));
      await store.write(SecureKeyStore.keyForProvider(id), result.apiKey);
      if (result.isDefault) await _clearOtherDefaults(db, id);
    } else {
      await db.updateProviderConfig(existing.id, ProviderConfigsCompanion(
        name: Value(result.name),
        type: Value(result.type.name),
        baseUrl: Value(result.baseUrl),
        model: Value(result.model),
        isDefault: Value(result.isDefault),
        memoryModel: Value(result.memoryModel),
        contextWindowLimit: Value(result.contextWindowLimit),
        updatedAt: Value(now),
      ));
      await store.write(SecureKeyStore.keyForProvider(existing.id), result.apiKey);
      if (result.isDefault) await _clearOtherDefaults(db, existing.id);
    }

    if (context.mounted) await showSuccessDialog(context, '已保存');
  }

  /// 点一下即切换当前使用的 API（不再走「设为默认」）。
  Future<void> _selectProvider(WidgetRef ref, ProviderConfig c) async {
    if (c.isDefault) return; // 已经是当前使用
    final db = ref.read(dbProvider);
    await _clearOtherDefaults(db, c.id);
    await db.updateProviderConfig(
      c.id,
      const ProviderConfigsCompanion(isDefault: Value(true)),
    );
  }

  Future<void> _showMenu(
    BuildContext context,
    WidgetRef ref,
    ProviderConfig c,
  ) async {
    final db = ref.read(dbProvider);
    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('编辑'),
              onTap: () => Navigator.of(context).pop('edit'),
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('删除', style: TextStyle(color: Colors.red)),
              onTap: () => Navigator.of(context).pop('delete'),
            ),
          ],
        ),
      ),
    );

    if (action == 'edit') {
      if (context.mounted) await _openForm(context, ref, existing: c);
    } else if (action == 'delete') {
      if (!context.mounted) return;
      final ok = await showConfirmDialog(context, title: '删除配置', message: '确定删除「${c.name}」？');
      if (!ok) return;
      await db.deleteProviderConfig(c.id);
      await ref.read(secureKeyStoreProvider).delete(SecureKeyStore.keyForProvider(c.id));
    }
  }

  Future<void> _clearOtherDefaults(AppDatabase db, String keepId) async {
    final rows = await db.watchProviderConfigs().first;
    for (final row in rows) {
      if (row.id != keepId && row.isDefault) {
        await db.updateProviderConfig(row.id, const ProviderConfigsCompanion(isDefault: Value(false)));
      }
    }
  }
}

class _ProviderFormResult {
  const _ProviderFormResult({
    required this.name,
    required this.type,
    required this.baseUrl,
    required this.model,
    required this.apiKey,
    required this.isDefault,
    this.memoryModel,
    this.contextWindowLimit,
  });

  final String name;
  final ProviderType type;
  final String baseUrl;
  final String model;
  final String apiKey;
  final bool isDefault;
  final String? memoryModel;
  final int? contextWindowLimit;
}

class _ProviderFormDialog extends StatefulWidget {
  const _ProviderFormDialog({this.existing, this.existingKey});

  final ProviderConfig? existing;
  final String? existingKey;

  @override
  State<_ProviderFormDialog> createState() => _ProviderFormDialogState();
}

class _ProviderFormDialogState extends State<_ProviderFormDialog> {
  late final TextEditingController _name = TextEditingController(text: widget.existing?.name ?? '');
  late final TextEditingController _baseUrl = TextEditingController(text: widget.existing?.baseUrl ?? '');
  late final TextEditingController _model = TextEditingController(text: widget.existing?.model ?? '');
  late final TextEditingController _memoryModel = TextEditingController(text: widget.existing?.memoryModel ?? '');
  late final TextEditingController _contextWindowLimit = TextEditingController(text: widget.existing?.contextWindowLimit?.toString() ?? '');
  late final TextEditingController _apiKey = TextEditingController(text: widget.existingKey ?? '');
  late ProviderType _type = widget.existing?.type == 'anthropic' ? ProviderType.anthropic : ProviderType.openaiCompatible;
  late bool _isDefault = widget.existing?.isDefault ?? false;
  bool _testing = false;

  @override
  void dispose() {
    _name.dispose();
    _baseUrl.dispose();
    _model.dispose();
    _memoryModel.dispose();
    _contextWindowLimit.dispose();
    _apiKey.dispose();
    super.dispose();
  }

  Future<void> _test() async {
    setState(() => _testing = true);
    final config = LlmProviderConfig(
      id: 'test',
      name: 'test',
      type: _type,
      baseUrl: _baseUrl.text.trim(),
      model: _model.text.trim(),
      apiKey: _apiKey.text.trim(),
    );
    try {
      final provider = buildLlmProvider(config);
      await for (final chunk in provider.streamChat(ChatRequest(
        messages: const [ChatMessage(role: 'user', content: 'ping')],
        maxTokens: 8,
      ))) {
        if (chunk.textDelta != null && chunk.textDelta!.isNotEmpty) break;
      }
      if (mounted) await showSuccessDialog(context, '连接成功');
    } catch (e) {
      if (mounted) {
        await showErrorDialog(context, e is AppException ? e.message : '连接失败：$e');
      }
    } finally {
      if (mounted) setState(() => _testing = false);
    }
  }

  void _submit() {
    if (_name.text.trim().isEmpty || _baseUrl.text.trim().isEmpty || _model.text.trim().isEmpty) {
      return;
    }
    Navigator.of(context).pop(_ProviderFormResult(
      name: _name.text.trim(),
      type: _type,
      baseUrl: _baseUrl.text.trim(),
      model: _model.text.trim(),
      apiKey: _apiKey.text.trim(),
      isDefault: _isDefault,
      memoryModel: _memoryModel.text.trim().isEmpty ? null : _memoryModel.text.trim(),
      contextWindowLimit: int.tryParse(_contextWindowLimit.text.trim()),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existing == null ? '添加 Provider' : '编辑 Provider'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<ProviderType>(
              initialValue: _type,
              decoration: const InputDecoration(labelText: '类型'),
              items: const [
                DropdownMenuItem(value: ProviderType.openaiCompatible, child: Text('OpenAI 兼容')),
                DropdownMenuItem(value: ProviderType.anthropic, child: Text('Anthropic')),
              ],
              onChanged: (v) => setState(() => _type = v ?? _type),
            ),
            const SizedBox(height: 8),
            TextField(controller: _name, decoration: const InputDecoration(labelText: '名称')),
            const SizedBox(height: 8),
            TextField(controller: _baseUrl, decoration: const InputDecoration(labelText: 'Base URL')),
            const SizedBox(height: 8),
            TextField(controller: _model, decoration: const InputDecoration(labelText: '模型')),
            const SizedBox(height: 8),
            TextField(
              controller: _memoryModel,
              decoration: const InputDecoration(labelText: '记忆模型（可选，用于状态/摘要抽取）'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _contextWindowLimit,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '上下文窗口（token 数）',
                helperText: '模型上下文上限，用于实时 token 显示；留空默认 32000',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _apiKey,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'API Key'),
            ),
            const SizedBox(height: 8),
            CheckboxListTile(
              value: _isDefault,
              onChanged: (v) => setState(() => _isDefault = v ?? false),
              title: const Text('设为默认'),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('取消')),
        TextButton(
          onPressed: _testing ? null : _test,
          child: _testing ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('测试连接'),
        ),
        FilledButton(onPressed: _submit, child: const Text('保存')),
      ],
    );
  }
}
