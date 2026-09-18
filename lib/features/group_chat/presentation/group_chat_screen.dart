import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/db/database.dart';
import '../../../core/utils/app_exception.dart';
import '../../../core/utils/dialogs.dart';
import '../../contacts/presentation/widgets/character_avatar.dart';
import 'group_chat_controller.dart';
import 'group_providers.dart';

class GroupChatScreen extends ConsumerStatefulWidget {
  const GroupChatScreen({super.key, required this.groupId});

  final String groupId;

  @override
  ConsumerState<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends ConsumerState<GroupChatScreen> {
  final _inputController = TextEditingController();
  GroupChatController? _controller;

  @override
  void dispose() {
    // Stop any in-flight stream when leaving the group chat.
    // ref is unsafe inside dispose, so cancel via the notifier captured in build.
    _controller?.cancel();
    _inputController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _inputController.text;
    if (text.trim().isEmpty) return;
    _inputController.clear();
    try {
      await ref
          .read(groupChatControllerProvider.notifier)
          .sendMessage(widget.groupId, text);
    } catch (e) {
      if (mounted) {
        await showErrorDialog(
          context,
          e is AppException ? e.message : '发送失败：$e',
        );
      }
    }
  }

  void _cancel() => ref.read(groupChatControllerProvider.notifier).cancel();

  @override
  Widget build(BuildContext context) {
    _controller = ref.read(groupChatControllerProvider.notifier);
    final groupAsync = ref.watch(groupProvider(widget.groupId));
    final members = ref.watch(groupMembersProvider(widget.groupId)).value ?? [];
    final messagesAsync = ref.watch(groupMessagesProvider(widget.groupId));
    final chatState = ref.watch(groupChatControllerProvider);

    final memberById = {
      for (final m in members) m.member.characterId: m,
    };
    final title = groupAsync.value?.name ?? '群聊';
    final messages = messagesAsync.value ?? <GroupMessage>[];
    final reversed = messages.reversed.toList();
    final isStreaming = chatState.isGenerating &&
        chatState.streamingGroupId == widget.groupId;
    final segments = chatState.streamingSegments;

    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () => context.push('/chat/group/${widget.groupId}/info'),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(title),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz),
            tooltip: '群信息',
            onPressed: () => context.push('/chat/group/${widget.groupId}/info'),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('加载失败：$e')),
              data: (_) => ListView.builder(
                reverse: true,
                padding: const EdgeInsets.symmetric(vertical: 12),
                itemCount: reversed.length + (isStreaming ? segments.length : 0),
                itemBuilder: (context, index) {
                  if (isStreaming && index < segments.length) {
                    final seg = segments[segments.length - 1 - index];
                    final member = memberById[seg.speakerId];
                    return _bubble(
                      context,
                      member?.character.name ?? '',
                      seg.content,
                      isUser: false,
                      avatarName: member?.character.name,
                      avatarPath: member?.character.avatarPath,
                    );
                  }
                  final msg =
                      reversed[isStreaming ? index - segments.length : index];
                  if (msg.type == 'command_reply' || msg.role == 'system') {
                    return _systemBubble(context, msg.content);
                  }
                  final isUser = msg.role == 'user';
                  final member = memberById[msg.speakerCharacterId];
                  final speaker =
                      isUser ? '我' : (member?.character.name ?? '角色');
                  return _bubble(
                    context,
                    speaker,
                    msg.content,
                    isUser: isUser,
                    avatarName: member?.character.name,
                    avatarPath: member?.character.avatarPath,
                  );
                },
              ),
            ),
          ),
          _inputBar(),
        ],
      ),
    );
  }

  Widget _bubble(
    BuildContext context,
    String speaker,
    String content, {
    required bool isUser,
    String? avatarName,
    String? avatarPath,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final showTyping = content.isEmpty && !isUser;

    final bubble = Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      constraints: const BoxConstraints(maxWidth: 300),
      decoration: BoxDecoration(
        color: isUser ? scheme.primaryContainer : scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: showTyping
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(content),
    );

    final nameLabel = speaker.isEmpty
        ? null
        : Text(speaker, style: Theme.of(context).textTheme.labelSmall);

    if (isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ?nameLabel,
              bubble,
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: CharacterAvatar(
              name: avatarName ?? speaker,
              avatarPath: avatarPath,
              radius: 16,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ?nameLabel,
                bubble,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _systemBubble(BuildContext context, String content) {
    final scheme = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
        constraints: const BoxConstraints(maxWidth: 320),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          content,
          style: TextStyle(
            fontSize: 12,
            color: scheme.onSurfaceVariant,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _inputBar() {
    final isStreaming = ref.watch(groupChatControllerProvider).isGenerating;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _inputController,
                minLines: 1,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: '发消息（@角色 点名）…',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                onSubmitted: (_) => isStreaming ? null : _send(),
                onTapOutside: (_) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: isStreaming ? _cancel : _send,
              icon: Icon(isStreaming ? Icons.stop : Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}
