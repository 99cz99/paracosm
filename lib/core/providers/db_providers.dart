import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/database.dart';
import '../storage/secure_storage.dart';

/// Single app-wide [AppDatabase].
final dbProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final secureKeyStoreProvider = Provider<SecureKeyStore>((ref) => SecureKeyStore());

/// Whether the realtime token display is enabled (stored in Settings).
final tokenDisplayEnabledProvider = StreamProvider<bool>((ref) {
  final db = ref.watch(dbProvider);
  return db.watchSetting('token_display_enabled').map((v) => v == 'true');
});
