import 'package:flutter/material.dart';

/// Product constraint: every success/failure notice is a dialog, never a chat
/// bubble or snackbar. All screens route their notices through here.
Future<void> showErrorDialog(BuildContext context, String message) async {
  await showDialog<void>(
    context: context,
    useRootNavigator: false,
    builder: (dialogContext) => AlertDialog(
      title: const Text('出错了'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('确定'),
        ),
      ],
    ),
  );
}

Future<void> showSuccessDialog(BuildContext context, String message) async {
  await showDialog<void>(
    context: context,
    useRootNavigator: false,
    builder: (dialogContext) => AlertDialog(
      title: const Text('成功'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('确定'),
        ),
      ],
    ),
  );
}

/// A confirm dialog returning true when the user picks the destructive action.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = '删除',
}) async {
  final result = await showDialog<bool>(
    context: context,
    useRootNavigator: false,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result ?? false;
}

/// A text-input dialog for pasting importable JSON. Returns the entered text
/// (possibly empty) or null when cancelled.
Future<String?> showPasteTextDialog(
  BuildContext context, {
  required String title,
  String hint = '{...}',
}) async {
  final controller = TextEditingController();
  final ok = await showDialog<bool>(
    context: context,
    useRootNavigator: false,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: SizedBox(
        width: 400,
        child: TextField(
          controller: controller,
          maxLines: 12,
          decoration: InputDecoration(hintText: hint),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: const Text('导入'),
        ),
      ],
    ),
  );
  if (ok != true) return null;
  return controller.text;
}

/// Asks whether to start a fresh conversation, resetting the character's
/// relationship memory. Returns true for "全新开始", false for "继续", and
/// null when dismissed (treated as "继续").
Future<bool?> showFreshStartDialog(
  BuildContext context,
  String characterName,
) async {
  return showDialog<bool>(
    context: context,
    useRootNavigator: false,
    builder: (dialogContext) => AlertDialog(
      title: const Text('开始聊天'),
      content: Text('要全新开始吗？全新开始会清空与「$characterName」的关系记忆，角色将不记得你。'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text('继续'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: const Text('全新开始'),
        ),
      ],
    ),
  );
}
