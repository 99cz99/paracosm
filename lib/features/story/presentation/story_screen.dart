import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/db/database.dart';
import '../../../core/providers/db_providers.dart';
import '../../../core/utils/dialogs.dart';
import 'story_providers.dart';

class StoryScreen extends ConsumerWidget {
  const StoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storiesAsync = ref.watch(storiesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('剧情'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: '新建剧本',
            onPressed: () => context.push('/story/create'),
          ),
        ],
      ),
      body: storiesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('加载失败：$e')),
        data: (stories) {
          if (stories.isEmpty) return const _EmptyStories();
          return ListView.builder(
            itemCount: stories.length,
            itemBuilder: (context, index) {
              final s = stories[index];
              return ListTile(
                leading: const Icon(Icons.auto_stories),
                title: Text(s.name),
                subtitle: s.description.isEmpty
                    ? null
                    : Text(s.description,
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                onTap: () => context.push('/story/${s.id}'),
                onLongPress: () => _confirmDelete(context, ref, s),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Story s,
  ) async {
    final ok = await showConfirmDialog(
      context,
      title: '删除剧本',
      message: '确定删除「${s.name}」？',
    );
    if (!ok) return;
    try {
      await ref.read(dbProvider).deleteStory(s.id);
    } catch (e) {
      if (context.mounted) await showErrorDialog(context, '删除失败：$e');
      return;
    }
    if (context.mounted) await showSuccessDialog(context, '已删除');
  }
}

class _EmptyStories extends StatelessWidget {
  const _EmptyStories();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.auto_stories_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 12),
          const Text('还没有剧本'),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: () => context.push('/story/create'),
            child: const Text('新建剧本'),
          ),
        ],
      ),
    );
  }
}
