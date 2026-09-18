import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../config/app_config.dart';

/// Result of an update check. [hasUpdate] is false on network errors or when
/// there's no newer release, so callers can quietly show "up to date".
typedef UpdateCheckResult = ({
  bool hasUpdate,
  String? latestVersion,
  String? htmlUrl,
});

/// Checks GitHub Releases for a version newer than the installed one.
Future<UpdateCheckResult> checkForUpdate() async {
  try {
    final info = await PackageInfo.fromPlatform();
    final response = await Dio().get<Map<String, dynamic>>(
      'https://api.github.com/repos/${AppConfig.githubRepo}/releases/latest',
      options: Options(
        headers: {
          // GitHub API rejects requests without a User-Agent.
          'User-Agent': AppConfig.appName,
          'Accept': 'application/vnd.github+json',
        },
      ),
    );
    final data = response.data;
    if (data == null) {
      return (hasUpdate: false, latestVersion: null, htmlUrl: null);
    }

    final tag = (data['tag_name'] ?? '').toString();
    final latest =
        (tag.startsWith('v') || tag.startsWith('V')) ? tag.substring(1) : tag;
    final url = (data['html_url'] ?? '').toString();

    return (
      hasUpdate: _compareVersions(latest, info.version) > 0,
      latestVersion: latest,
      htmlUrl: url,
    );
  } catch (_) {
    return (hasUpdate: false, latestVersion: null, htmlUrl: null);
  }
}

/// Compares two dotted semantic versions (major.minor.patch). Returns >0 when
/// [a] is newer, <0 when older, 0 when equal. Non-numeric segments count as 0.
int _compareVersions(String a, String b) {
  final pa = _parseVersion(a);
  final pb = _parseVersion(b);
  for (var i = 0; i < 3; i++) {
    final d = pa[i] - pb[i];
    if (d != 0) return d;
  }
  return 0;
}

List<int> _parseVersion(String v) {
  final parts = v.split('.');
  final out = [0, 0, 0];
  for (var i = 0; i < 3 && i < parts.length; i++) {
    out[i] = int.tryParse(parts[i].trim()) ?? 0;
  }
  return out;
}
