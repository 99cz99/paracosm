import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database.dart';
import '../../../core/providers/db_providers.dart';
import '../../../core/providers/llm_providers.dart';
import 'chat_controller.dart';

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

/// Estimated token usage for the session's next would-be request (base, no
/// user input). Recomputes when messages change.
final tokenUsageProvider = FutureProvider.family<TokenUsage, String>(
  (ref, sessionId) async {
    final db = ref.watch(dbProvider);
    ref.watch(messagesProvider(sessionId));
    ref.watch(providerConfigsProvider); // recompute when a provider config changes
    final session = await db.getSession(sessionId);
    if (session == null) {
      return const TokenUsage(
        sections: [],
        historyTokens: 0,
        contextLimit: 32000,
        outputReserve: 4096,
      );
    }
    return ref
        .read(chatControllerProvider.notifier)
        .estimateTokenUsage(db, session, '');
  },
);
