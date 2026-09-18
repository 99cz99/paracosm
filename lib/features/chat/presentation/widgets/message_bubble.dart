import 'package:flutter/material.dart';

import '../../../contacts/presentation/widgets/character_avatar.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.role,
    required this.content,
    this.type,
    this.isStreaming = false,
    this.avatarName,
    this.avatarPath,
    this.onAvatarTap,
    this.onRecall,
  });

  final String role;
  final String content;
  final String? type;
  final bool isStreaming;
  final String? avatarName;
  final String? avatarPath;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onRecall;

  @override
  Widget build(BuildContext context) {
    // Command replies (and any system message) render as a centered, muted
    // bubble — no avatar, distinct from assistant bubbles.
    if (type == 'command_reply' || role == 'system') {
      return _buildSystem(context);
    }

    final isUser = role == 'user';
    final scheme = Theme.of(context).colorScheme;

    final bubble = Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      constraints: const BoxConstraints(maxWidth: 320),
      decoration: BoxDecoration(
        color: isUser
            ? scheme.primaryContainer
            : scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: (isStreaming && content.isEmpty)
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : SelectableText(
              content,
              // Append a "撤回" item to the native selection toolbar, keeping
              // the default copy/select-all actions intact.
              contextMenuBuilder: onRecall == null
                  ? null
                  : (context, editableTextState) {
                      final items = editableTextState.contextMenuButtonItems;
                      items.add(ContextMenuButtonItem(
                        label: '撤回',
                        onPressed: () {
                          ContextMenuController.removeAny();
                          onRecall!();
                        },
                      ));
                      return AdaptiveTextSelectionToolbar.buttonItems(
                        anchors: editableTextState.contextMenuAnchors,
                        buttonItems: items,
                      );
                    },
            ),
    );

    if (isUser) {
      return Align(alignment: Alignment.centerRight, child: bubble);
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 4),
            child: GestureDetector(
              onTap: onAvatarTap,
              child: CharacterAvatar(
                name: avatarName ?? '',
                avatarPath: avatarPath,
                radius: 16,
              ),
            ),
          ),
          Flexible(child: bubble),
        ],
      ),
    );
  }

  Widget _buildSystem(BuildContext context) {
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
        child: SelectableText(
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
}
