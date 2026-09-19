import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database.dart';
import '../../../core/providers/db_providers.dart';

final charactersProvider = StreamProvider<List<Character>>((ref) {
  // Built-in assistant characters (builtInKey != null) live in the 助手 tab,
  // not in the contacts list.
  return ref.watch(dbProvider).watchCharacters().map(
        (list) => list.where((c) => c.builtInKey == null).toList(),
      );
});

final characterProvider = FutureProvider.family<Character?, String>((ref, id) {
  return ref.watch(dbProvider).getCharacter(id);
});

final adaptationsProvider =
    StreamProvider.family<List<AdaptationWithWorld>, String>((ref, characterId) {
  return ref.watch(dbProvider).watchAdaptationsFor(characterId);
});

final characterWorldbooksProvider =
    StreamProvider.family<List<Worldbook>, String>((ref, characterId) {
  return ref.watch(dbProvider).watchWorldbooksForCharacter(characterId);
});
