import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/db/database.dart';
import '../../../core/providers/db_providers.dart';
import '../../../core/utils/dialogs.dart';
import '../../../core/utils/pinyin.dart';
import '../../contacts/presentation/contacts_providers.dart';
import '../../contacts/presentation/widgets/character_avatar.dart';
import '../../group_chat/presentation/group_providers.dart';
import '../../group_chat/presentation/widgets/group_avatar.dart';
import '../data/session_repository.dart';
import 'chat_providers.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(sessionsProvider);
    final groupsAsync = ref.watch(groupsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('聊天'),
        actions: [
          IconButton(
            icon: const Icon(Icons.group_add_outlined),
            tooltip: '新群聊',
            onPressed: () => context.push('/chat/group/create'),
          ),
          IconButton(
            icon: const Icon(Icons.add_comment_outlined),
            tooltip: '新单聊',
            onPressed: () => _newChat(context, ref),
          ),
        ],
      ),
      body: _buildBody(context, ref, sessionsAsync, groupsAsync),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<SessionWithCharacter>> sessionsAsync,
    AsyncValue<List<Group>> groupsAsync,
  ) {
    if (sessionsAsync.isLoading || groupsAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    final sessions = sessionsAsync.value ?? [];
    final groups = groupsAsync.value ?? [];
    if (sessions.isEmpty && groups.isEmpty) return const _EmptySessions();

    return ListView(
      children: [
        if (groups.isNotEmpty) ...[
          const _SectionHeader('群聊'),
          for (final g in groups)
            ListTile(
              leading: GroupAvatar(
                members: ref.watch(groupMembersProvider(g.id)).value ?? const [],
                avatarPath: g.avatarPath,
                size: 40,
              ),
              title: Text(g.name),
              subtitle: _subtitleWithWorldTags(
                context,
                worldNames: [
                  for (final w in ref.watch(groupWorldsProvider(g.id)).value ??
                      const <World>[])
                    w.name,
                ],
                timeText: _formatTime(g.lastMessageAt),
              ),
              onTap: () => context.push('/chat/group/${g.id}'),
              onLongPress: () => _confirmDeleteGroup(context, ref, g),
            ),
        ],
        if (sessions.isNotEmpty) ...[
          const _SectionHeader('单聊'),
          for (final s in sessions)
            ListTile(
              leading: CharacterAvatar(
                name: s.characterName,
                avatarPath: s.avatarPath,
                radius: 20,
              ),
              title: Text(s.characterName.isEmpty ? '未命名' : s.characterName),
              subtitle: _subtitleWithWorldTags(
                context,
                worldNames: s.worldName == null ? const [] : [s.worldName!],
                timeText: _formatTime(s.session.lastMessageAt),
              ),
              onTap: () => context.push('/chat/${s.session.id}'),
              onLongPress: () => _confirmDeleteSession(context, ref, s),
            ),
        ],
      ],
    );
  }

  Future<void> _newChat(BuildContext context, WidgetRef ref) async {
    final characters = [...(ref.read(charactersProvider).value ?? [])]
      ..sort((a, b) {
        final la = pinyinInitial(a.name);
        final lb = pinyinInitial(b.name);
        if (la != lb) {
          if (la == '#') return 1;
          if (lb == '#') return -1;
          return la.compareTo(lb);
        }
        return a.name.compareTo(b.name);
      });
    if (characters.isEmpty) {
      await showErrorDialog(context, '请先在「联系人」导入角色');
      return;
    }
    final character = await showDialog<Character>(
      context: context,
      useRootNavigator: false,
      builder: (dialogContext) => SimpleDialog(
        title: const Text('选择角色'),
        children: [
          for (final c in characters)
            SimpleDialogOption(
              onPressed: () => Navigator.of(dialogContext).pop(c),
              child: ListTile(
                leading: CharacterAvatar(name: c.name, avatarPath: c.avatarPath, radius: 20),
                title: Text(c.name),
              ),
            ),
        ],
      ),
    );
    if (character == null) return;

    try {
      final db = ref.read(dbProvider);
      const worldKey = ''; // 新单聊 = 默认（无世界）
      final hasMemory = await db.hasCharacterMemory(character.id, worldKey);

      var freshStart = false;
      if (hasMemory) {
        if (!context.mounted) return;
        freshStart = await showFreshStartDialog(context, character.name) ?? false;
        if (!context.mounted) return;
      }

      final repo = SessionRepository(db);
      final String sessionId;
      if (freshStart) {
        await db.resetCharacterRelation(character.id, worldKey);
        await db.resetCharacterMemory(character.id, worldKey);
        await db.resetCharacterAffinity(character.id, worldKey);
        final existing = await db.getSessionForCharacter(character.id, null);
        if (existing != null) await db.deleteSession(existing.id);
        sessionId = await repo.createSession(character.id);
      } else {
        sessionId = await repo.getOrCreateSession(character.id);
      }
      if (context.mounted) context.push('/chat/$sessionId');
    } catch (e) {
      if (context.mounted) await showErrorDialog(context, '创建会话失败：$e');
    }
  }

  Future<void> _confirmDeleteSession(
    BuildContext context,
    WidgetRef ref,
    SessionWithCharacter s,
  ) async {
    final ok = await showConfirmDialog(
      context,
      title: '删除会话',
      message: '确定删除与「${s.characterName}」的会话？消息和记忆也会被删除。',
    );
    if (!ok) return;
    await ref.read(dbProvider).deleteSession(s.session.id);
    if (context.mounted) await showSuccessDialog(context, '已删除');
  }

  Future<void> _confirmDeleteGroup(
    BuildContext context,
    WidgetRef ref,
    Group g,
  ) async {
    final ok = await showConfirmDialog(
      context,
      title: '删除群聊',
      message: '确定删除群聊「${g.name}」？',
    );
    if (!ok) return;
    await ref.read(dbProvider).deleteGroup(g.id);
    if (context.mounted) await showSuccessDialog(context, '已删除');
  }

  String _formatTime(int ms) =>
      DateFormat('MM-dd HH:mm').format(DateTime.fromMillisecondsSinceEpoch(ms));

  Widget _subtitleWithWorldTags(
    BuildContext context, {
    required List<String> worldNames,
    required String timeText,
  }) {
    return Wrap(
      spacing: 6,
      runSpacing: 2,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final name in worldNames) _WorldTag(name),
        Text(timeText),
      ],
    );
  }
}

class _WorldTag extends StatelessWidget {
  const _WorldTag(this.name);

  final String name;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        name,
        style: TextStyle(fontSize: 11, color: scheme.onSecondaryContainer),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleSmall
            ?.copyWith(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}

class _EmptySessions extends StatelessWidget {
  const _EmptySessions();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
          SizedBox(height: 12),
          Text('还没有会话'),
          SizedBox(height: 8),
          Text('点右上角开始单聊或群聊'),
        ],
      ),
    );
  }
}
