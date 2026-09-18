import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/db/database.dart';
import '../../../core/utils/prompt_template.dart';

class SessionRepository {
  SessionRepository(this._db);

  final AppDatabase _db;
  static final _uuid = const Uuid();

  /// Creates a session bound to a character's adaptation for [worldId]
  /// (default adaptation when null/empty). [openingMessage] overrides the
  /// character's `first_mes` as the first assistant message.
  Future<String> createSession(
    String characterId, {
    String? worldId,
    String? openingMessage,
    List<String>? worldbookIds,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    // Normalize the default world to '' (not NULL), matching relations /
    // affinities / memories, so the "default" spelling is uniform.
    final normalizedWorldId = (worldId == null || worldId.isEmpty) ? '' : worldId;
    final adaptation = await _db.getAdaptation(characterId, normalizedWorldId);
    final id = _uuid.v4();

    await _db.insertSession(SessionsCompanion.insert(
      id: id,
      characterId: characterId,
      worldId: Value(normalizedWorldId),
      adaptationId: Value(adaptation?.id),
      worldbookIdsJson:
          Value(worldbookIds == null ? null : jsonEncode(worldbookIds)),
      createdAt: now,
      updatedAt: now,
      lastMessageAt: now,
    ));

    // Empty session state so the memory system can update in place.
    await _db.upsertSessionState(SessionStatesCompanion.insert(
      sessionId: id,
      updatedAt: now,
    ));

    final opening = (openingMessage?.trim() ?? '').isNotEmpty
        ? openingMessage!.trim()
        : await _firstMessage(characterId);
    if (opening.isNotEmpty) {
      await _db.insertMessage(MessagesCompanion.insert(
        id: _uuid.v4(),
        sessionId: id,
        role: 'assistant',
        content: opening,
        orderIndex: 0,
        timestamp: now,
      ));
    }

    return id;
  }

  /// Opening greetings for the character: `first_mes` first, then unique
  /// `alternate_greetings`. Empty when the character has none.
  Future<List<String>> getGreetings(String characterId) async {
    final character = await _db.getCharacter(characterId);
    if (character == null) return const [];
    final userName = await _db.getSetting('user_name') ?? '我';
    try {
      final core = jsonDecode(character.corePersonaJson) as Map<String, dynamic>;
      final List<String> greetings;
      // Prefer the cached Chinese translations when they exist.
      final zh = core['greetings_zh'];
      if (zh is List && zh.isNotEmpty) {
        greetings = List<String>.from(zh.map((e) => e.toString().trim()))
            .where((s) => s.isNotEmpty)
            .toList();
      } else {
        greetings = [];
        final first = (core['first_mes'] ?? '').toString().trim();
        if (first.isNotEmpty) greetings.add(first);
        final alts = core['alternate_greetings'];
        if (alts is List) {
          for (final a in alts) {
            final s = a.toString().trim();
            if (s.isNotEmpty && !greetings.contains(s)) greetings.add(s);
          }
        }
      }
      return [
        for (final g in greetings)
          applyPlaceholders(g, character.name, userName),
      ];
    } catch (_) {
      return const [];
    }
  }

  /// Returns the existing session for [characterId]/[worldId], or creates one.
  Future<String> getOrCreateSession(
    String characterId, {
    String? worldId,
    String? openingMessage,
    List<String>? worldbookIds,
  }) async {
    final existing = await _db.getSessionForCharacter(characterId, worldId);
    if (existing != null) {
      if (worldbookIds != null) {
        await _db.updateSession(existing.id, SessionsCompanion(
          worldbookIdsJson: Value(jsonEncode(worldbookIds)),
        ));
      }
      return existing.id;
    }
    return createSession(
      characterId,
      worldId: worldId,
      openingMessage: openingMessage,
      worldbookIds: worldbookIds,
    );
  }

  Future<void> deleteSession(String id) => _db.deleteSession(id);

  Future<String> _firstMessage(String characterId) async {
    final character = await _db.getCharacter(characterId);
    if (character == null) return '';
    final userName = await _db.getSetting('user_name') ?? '我';
    try {
      final core = jsonDecode(character.corePersonaJson) as Map<String, dynamic>;
      final zh = core['greetings_zh'];
      final text = (zh is List && zh.isNotEmpty)
          ? zh.first.toString().trim()
          : (core['first_mes'] ?? '').toString().trim();
      return applyPlaceholders(text, character.name, userName);
    } catch (_) {
      return '';
    }
  }
}
