import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/backup/backup_service.dart';
import '../../../core/network/update_checker.dart';
import '../../../core/providers/db_providers.dart';
import '../../../core/utils/app_exception.dart';
import '../../../core/utils/dialogs.dart';

/// 应用版本信息（versionName + build number），供「关于」展示。
final packageInfoProvider = FutureProvider<PackageInfo>(
  (ref) => PackageInfo.fromPlatform(),
);

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final info = ref.watch(packageInfoProvider).value;
    return Scaffold(
      appBar: AppBar(title: const Text('我')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.api),
            title: const Text('API Provider'),
            subtitle: const Text('配置你的大模型 API'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/profile/providers'),
          ),
          ListTile(
            leading: const Icon(Icons.tune),
            title: const Text('采样预设'),
            subtitle: const Text('temperature / maxTokens / penalty parameters'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/profile/presets'),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.speed),
            title: const Text('实时 Token 显示'),
            subtitle: const Text('聊天顶部显示当前输入占用的 token 数'),
            value: ref.watch(tokenDisplayEnabledProvider).value ?? false,
            onChanged: (v) => ref
                .read(dbProvider)
                .setSetting('token_display_enabled', v.toString()),
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text('搜索'),
            subtitle: const Text('搜索角色和消息'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/search'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.backup_outlined),
            title: const Text('备份数据'),
            subtitle: const Text('导出全部数据到 JSON'),
            onTap: () => _backup(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.restore),
            title: const Text('恢复数据'),
            subtitle: const Text('从 JSON 备份恢复（覆盖当前数据）'),
            onTap: () => _restore(context, ref),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.badge_outlined),
            title: const Text('我的名字'),
            subtitle: const Text('角色卡里 {{user}} 会替换成这个名字'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _editUserName(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.system_update),
            title: const Text('检查更新'),
            subtitle: const Text('检查 GitHub Releases 是否有新版本'),
            onTap: () => _checkUpdate(context),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('关于'),
            subtitle: Text(
              info == null
                  ? 'Paracosm · 纯客户端 AI 角色扮演'
                  : 'Paracosm · 纯客户端 AI 角色扮演\nv${info.version} (build ${info.buildNumber})',
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _backup(BuildContext context, WidgetRef ref) async {
    try {
      final json = await BackupService(ref.read(dbProvider)).exportAll();
      final dir = await getApplicationDocumentsDirectory();
      final backupDir = Directory(p.join(dir.path, 'backups'));
      await backupDir.create(recursive: true);
      final file = File(p.join(
        backupDir.path,
        'backup_${DateTime.now().millisecondsSinceEpoch}.json',
      ));
      await file.writeAsString(json);
      if (context.mounted) {
        await showSuccessDialog(context, '已备份到：\n${file.path}');
      }
    } catch (e) {
      if (context.mounted) await showErrorDialog(context, '备份失败：$e');
    }
  }

  Future<void> _restore(BuildContext context, WidgetRef ref) async {
    final files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (files.isEmpty) return;
    final bytes = await files.first.readAsBytes();
    final json = utf8.decode(bytes);

    if (!context.mounted) return;
    final ok = await showConfirmDialog(
      context,
      title: '恢复数据',
      message: '恢复将覆盖当前全部数据，确定继续？',
      confirmLabel: '恢复',
    );
    if (!ok) return;

    try {
      await BackupService(ref.read(dbProvider)).importAll(json);
      if (context.mounted) await showSuccessDialog(context, '已恢复');
    } catch (e) {
      if (context.mounted) {
        await showErrorDialog(context, e is AppException ? e.message : '恢复失败：$e');
      }
    }
  }

  Future<void> _editUserName(BuildContext context, WidgetRef ref) async {
    final db = ref.read(dbProvider);
    final current = await db.getSetting('user_name') ?? '我';
    final controller = TextEditingController(text: current);
    if (!context.mounted) return;
    final result = await showDialog<String>(
      context: context,
      useRootNavigator: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('我的名字'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: '在剧情里的名字'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.of(dialogContext).pop(controller.text.trim()),
            child: const Text('保存'),
          ),
        ],
      ),
    );
    // Don't dispose the controller here: the dialog is still playing its exit
    // animation when showDialog's future resolves, and disposing it now makes
    // the still-mounted TextField hit `_dependents.isEmpty` on the next frame.
    if (result != null && result.isNotEmpty) {
      await db.setSetting('user_name', result);
      if (context.mounted) await showSuccessDialog(context, '已保存');
    }
  }

  Future<void> _checkUpdate(BuildContext context) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final result = await checkForUpdate();

    if (!context.mounted) return;
    Navigator.of(context).pop(); // 关闭 loading

    if (!result.hasUpdate) {
      await showSuccessDialog(context, '已是最新版本');
      return;
    }

    final url = result.htmlUrl;
    final go = await showConfirmDialog(
      context,
      title: '发现新版本',
      message: '新版本 v${result.latestVersion} 已发布。\n前往 GitHub 下载页手动更新？',
      confirmLabel: '前往下载',
    );
    if (go && url != null && url.isNotEmpty) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }
}
