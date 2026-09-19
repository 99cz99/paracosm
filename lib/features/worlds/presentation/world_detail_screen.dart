import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/db/database.dart';
import '../data/world_exporter.dart';
import 'worlds_providers.dart';

class WorldDetailScreen extends ConsumerWidget {
  const WorldDetailScreen({super.key, required this.worldId});

  final String worldId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final worldAsync = ref.watch(worldProvider(worldId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('世界详情'),
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share),
            tooltip: '导出世界',
            onPressed: () => _exportWorld(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: '编辑',
            onPressed: () => context.push('/worlds/$worldId/edit'),
          ),
        ],
      ),
      body: worldAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('加载失败：$e')),
        data: (world) {
          if (world == null) return const Center(child: Text('世界不存在'));
          return _build(context, world);
        },
      ),
    );
  }

  Widget _build(BuildContext context, World w) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(w.name, style: Theme.of(context).textTheme.headlineSmall),
        if ((w.description ?? '').isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(w.description!),
        ],
        ..._section(context, '规则', _field(w.rulesJson)),
        ..._section(context, '初始状态', _field(w.initialStateJson)),
      ],
    );
  }

  List<Widget> _section(BuildContext context, String title, String text) {
    if (text.isEmpty) return const [];
    return [
      const SizedBox(height: 16),
      Text(title, style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: 4),
      Text(text),
    ];
  }

  String _field(String json) {
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return (map['text'] ?? '').toString();
    } catch (_) {
      return '';
    }
  }

  Future<void> _exportWorld(BuildContext context, WidgetRef ref) async {
    final world = await ref.read(worldProvider(worldId).future);
    if (world == null) return;
    final json = exportWorldJson(world);
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      useRootNavigator: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('导出世界'),
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
