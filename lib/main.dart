import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/splash/splash_icon.dart';
import 'core/utils/avatar_image.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initBackgroundService();
  await _preloadSplashIcon();
  runApp(const ProviderScope(child: ParacosmApp()));
  // Shrink any oversized avatars (character-card PNGs, old full-res crops) in
  // the background so cold-start reads stay cheap.
  unawaited(migrateLargeAvatars());
}

/// Decodes the splash icon ahead of `runApp` so the splash screen's first frame
/// already has the bubble (no pop-in flash at the native→Flutter handoff).
Future<void> _preloadSplashIcon() async {
  try {
    final bytes = await rootBundle.load('assets/ic_splash.png');
    final codec = await ui.instantiateImageCodec(bytes.buffer.asUint8List());
    splashIconImage = (await codec.getNextFrame()).image;
  } catch (_) {
    // Best-effort: the splash screen falls back to Image.asset.
  }
}

Future<void> _initBackgroundService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onServiceStart,
      autoStart: false,
      isForegroundMode: true,
      initialNotificationTitle: '生成回复中',
      initialNotificationContent: '正在后台生成回复…',
      foregroundServiceNotificationId: 888,
      foregroundServiceTypes: [AndroidForegroundType.dataSync],
    ),
    iosConfiguration: IosConfiguration(
      autoStart: false,
      onForeground: onServiceStart,
      onBackground: onServiceBackground,
    ),
  );
}

@pragma('vm:entry-point')
void onServiceStart(ServiceInstance service) async {
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
  service.on('stopService').listen((event) {
    service.stopSelf();
  });
}

@pragma('vm:entry-point')
Future<bool> onServiceBackground(ServiceInstance service) async {
  return true;
}
