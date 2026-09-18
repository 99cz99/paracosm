import 'package:flutter_background_service/flutter_background_service.dart';

/// Starts the foreground service so the process isn't killed while a reply
/// streams (e.g. app backgrounded / screen locked). The actual streaming still
/// runs on the main isolate; the foreground notification just keeps Android
/// from reclaiming the process.
Future<void> startReplyForeground() async {
  try {
    final service = FlutterBackgroundService();
    final running = await service.isRunning();
    if (running) {
      service.invoke('setAsForeground');
    } else {
      await service.startService();
    }
  } catch (_) {
    // Best-effort: a foreground-service failure must never break the reply.
  }
}

/// Stops the foreground service once the reply is done/cancelled/failed.
Future<void> stopReplyForeground() async {
  try {
    FlutterBackgroundService().invoke('stopService');
  } catch (_) {
    // Best-effort.
  }
}
