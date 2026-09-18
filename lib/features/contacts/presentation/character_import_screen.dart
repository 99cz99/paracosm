import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/db_providers.dart';
import '../../../core/utils/app_exception.dart';
import '../../../core/utils/dialogs.dart';
import '../data/character_repository.dart';

class CharacterImportScreen extends ConsumerStatefulWidget {
  const CharacterImportScreen({super.key});

  @override
  ConsumerState<CharacterImportScreen> createState() =>
      _CharacterImportScreenState();
}

class _CharacterImportScreenState extends ConsumerState<CharacterImportScreen> {
  bool _importing = false;

  Future<void> _pickFile() async {
    // file_picker 13: pickFiles returns List<PlatformFile> (multi-select).
    final files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'json', 'zip', 'md'],
    );
    if (files.isEmpty) return;
    setState(() => _importing = true);

    final repo = CharacterRepository(ref.read(dbProvider));
    var ok = 0;
    final failures = <String>[];
    for (final file in files) {
      try {
        final bytes = await file.readAsBytes();
        await repo.importFromBytes(
          bytes,
          sourcePath: file.path ?? file.name,
          filename: file.name,
        );
        ok++;
      } catch (e) {
        failures.add('${file.name}：${e is AppException ? e.message : e}');
      }
    }

    if (!mounted) return;
    setState(() => _importing = false);
    if (failures.isEmpty) {
      await showSuccessDialog(context, '导入成功 $ok 个');
      if (mounted) context.pop();
    } else {
      await showErrorDialog(
        context,
        '成功 $ok 个，失败 ${failures.length} 个\n${failures.take(5).join('\n')}',
      );
    }
  }

  Future<void> _pasteJson() async {
    final controller = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      useRootNavigator: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('粘贴角色卡 JSON'),
        content: SizedBox(
          width: 400,
          child: TextField(
            controller: controller,
            maxLines: 12,
            decoration: const InputDecoration(hintText: '{...角色卡 JSON...}'),
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
    if (ok != true) return;
    final text = controller.text;
    if (text.trim().isEmpty) return;

    setState(() => _importing = true);
    try {
      await CharacterRepository(ref.read(dbProvider))
          .importFromBytes(utf8.encode(text));
      if (!mounted) return;
      await showSuccessDialog(context, '导入成功');
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        await showErrorDialog(
          context,
          e is AppException ? e.message : '导入失败：$e',
        );
      }
    } finally {
      if (mounted) setState(() => _importing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('导入角色')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _importing
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('支持酒馆角色卡（PNG / JSON）和 Skill（ZIP / Markdown），可多选批量导入。'),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _pickFile,
                    icon: const Icon(Icons.folder_open),
                    label: const Text('选择文件（可多选）'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _pasteJson,
                    icon: const Icon(Icons.paste),
                    label: const Text('粘贴 JSON'),
                  ),
                ],
              ),
      ),
    );
  }
}
