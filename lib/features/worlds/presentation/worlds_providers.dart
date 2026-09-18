import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database.dart';
import '../../../core/providers/db_providers.dart';

final worldsProvider = StreamProvider<List<World>>((ref) {
  return ref.watch(dbProvider).watchWorlds();
});

final worldProvider = FutureProvider.family<World?, String>((ref, id) {
  return ref.watch(dbProvider).getWorld(id);
});

final worldbooksProvider = StreamProvider<List<Worldbook>>((ref) {
  return ref.watch(dbProvider).watchWorldbooks();
});

final worldbookProvider = FutureProvider.family<Worldbook?, String>((ref, id) {
  return ref.watch(dbProvider).getWorldbook(id);
});

final worldWorldbooksProvider =
    StreamProvider.family<List<Worldbook>, String>((ref, worldId) {
  return ref.watch(dbProvider).watchWorldbooksForWorld(worldId);
});
