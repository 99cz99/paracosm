import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database.dart';
import '../../../core/providers/db_providers.dart';
import '../../../core/providers/llm_providers.dart';
import '../../../core/widgets/color_field.dart';
import 'chat_controller.dart';

final sessionsProvider = StreamProvider<List<SessionWithCharacter>>((ref) {
  return ref.watch(dbProvider).watchSessionsWithCharacter();
});

/// Character → bound worldbook names, for showing worldbook tags in the chat list.
final characterWorldbookNamesProvider =
    StreamProvider<Map<String, List<String>>>((ref) {
  return ref.watch(dbProvider).watchCharacterWorldbookNames();
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

/// The session's cumulative token consumption (prompt/completion), refreshed as
/// messages are added (each assistant turn persists its API-reported usage).
final sessionTokensProvider = FutureProvider.family<
    ({int promptTokens, int completionTokens}), String>((
  ref,
  sessionId,
) async {
  ref.watch(messagesProvider(sessionId));
  final db = ref.watch(dbProvider);
  final session = await db.getSession(sessionId);
  if (session == null) return (promptTokens: 0, completionTokens: 0);
  return (
    promptTokens: session.totalPromptTokens ?? 0,
    completionTokens: session.totalCompletionTokens ?? 0,
  );
});

/// The raw [Session] row, watched so per-session color overrides reflect.
final sessionProvider = StreamProvider.family<Session?, String>(
  (ref, sessionId) => ref.watch(dbProvider).watchSession(sessionId),
);

/// Global appearance settings (Settings table keys).
final userBubbleColorSettingProvider = StreamProvider<String?>(
    (ref) => ref.watch(dbProvider).watchSetting('chat_user_bubble_color'));
final assistantBubbleColorSettingProvider = StreamProvider<String?>(
    (ref) => ref.watch(dbProvider).watchSetting('chat_assistant_bubble_color'));
final userTextColorSettingProvider = StreamProvider<String?>(
    (ref) => ref.watch(dbProvider).watchSetting('chat_user_text_color'));
final assistantTextColorSettingProvider = StreamProvider<String?>(
    (ref) => ref.watch(dbProvider).watchSetting('chat_assistant_text_color'));

/// Resolved bubble/text colors for a session: session override → global
/// setting → null (theme default).
class ChatColors {
  const ChatColors({
    this.userBubble,
    this.assistantBubble,
    this.userText,
    this.assistantText,
  });

  final Color? userBubble;
  final Color? assistantBubble;
  final Color? userText;
  final Color? assistantText;
}

final chatColorsProvider = Provider.family<ChatColors, String>((ref, sessionId) {
  final session = ref.watch(sessionProvider(sessionId)).value;
  final userBubble = session?.bubbleUserColor ??
      ref.watch(userBubbleColorSettingProvider).value;
  final assistantBubble = session?.bubbleAssistantColor ??
      ref.watch(assistantBubbleColorSettingProvider).value;
  final userText =
      session?.userTextColor ?? ref.watch(userTextColorSettingProvider).value;
  final assistantText = session?.assistantTextColor ??
      ref.watch(assistantTextColorSettingProvider).value;
  return ChatColors(
    userBubble: parseHexColor(userBubble),
    assistantBubble: parseHexColor(assistantBubble),
    userText: parseHexColor(userText),
    assistantText: parseHexColor(assistantText),
  );
});
