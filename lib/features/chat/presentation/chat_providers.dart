import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database.dart';
import '../../../core/providers/db_providers.dart';

final sessionsProvider = StreamProvider<List<SessionWithCharacter>>((ref) {
  return ref.watch(dbProvider).watchSessionsWithCharacter();
});

final messagesProvider = StreamProvider.family<List<Message>, String>(
  (ref, sessionId) => ref.watch(dbProvider).watchMessages(sessionId),
);

/// The character a chat session is bound to (title + message avatars).
/// Stream-based so avatar/name edits reflect immediately.
final chatCharacterProvider = StreamProvider.family<Character?, String>(
  (ref, sessionId) async* {
    final db = ref.watch(dbProvider);
    final session = await db.getSession(sessionId);
    if (session == null) {
      yield null;
      return;
    }
    yield* db.watchCharacter(session.characterId);
  },
);
