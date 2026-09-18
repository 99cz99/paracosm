import 'dart:convert';

import '../../../core/db/database.dart';

/// Exports a session's chat transcript as a shareable JSON document
/// (`type: paracosm_session`), round-trippable via `importSession`.
String exportSessionJson(Session session, List<Message> messages) =>
    jsonEncode({
      'type': 'paracosm_session',
      'title': session.title ?? '',
      'characterId': session.characterId,
      'worldId': session.worldId ?? '',
      'messages': [
        for (final m in messages)
          {'role': m.role, 'content': m.content, 'timestamp': m.timestamp},
      ],
    });
