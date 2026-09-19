import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/db/database.dart';
import '../../../core/providers/db_providers.dart';
import '../../chat/data/session_repository.dart';
import '../data/assistant_seed.dart';

/// Seeds the built-in assistants (idempotent) and lists them.
final assistantsProvider = FutureProvider<List<Character>>((ref) async {
  final db = ref.watch(dbProvider);
  await seedAssistants(db);
  return db.getAssistants();
});

class AssistantsScreen extends ConsumerWidget {
  const AssistantsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assistants = ref.watch(assistantsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('助手')),
      body: assistants.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('加载失败：$e')),
        data: (list) => ListView(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text('选择一位助手开始对话。助手是内置 AI，帮你制作角色卡、世界、世界书，或解答使用问题。'),
            ),
            for (final a in list)
              ListTile(
                leading: const Icon(Icons.smart_toy_outlined),
                title: Text(a.name),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _open(context, ref, a),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _open(BuildContext context, WidgetRef ref, Character a) async {
    final db = ref.read(dbProvider);
    final sessionId = await SessionRepository(db).getOrCreateSession(a.id);
    // Assistants generate long JSON (角色卡/世界/世界书) — give a high output
    // budget so replies aren't silently truncated at the default 4096.
    await db.updateSession(
        sessionId, SessionsCompanion(maxTokens: Value<int?>(16384)));
    if (context.mounted) context.go('/chat/$sessionId');
  }
}
