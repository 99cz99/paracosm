import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:uuid/uuid.dart';

import '../../../core/db/database.dart';

/// Exports a world to a shareable JSON document (rules + initial state + NPC
/// pool), round-trippable via `importWorld`.
String exportWorldJson(World world) => jsonEncode({
      'type': 'paracosm_world',
      'name': world.name,
      'description': world.description ?? '',
      'rulesJson': world.rulesJson,
      'initialStateJson': world.initialStateJson,
      'npcPoolJson': world.npcPoolJson,
    });

/// Parses a `paracosm_world` JSON document into a [WorldsCompanion] for import.
/// Returns null when the payload isn't a world export.
WorldsCompanion? parseWorldJson(String json) {
  try {
    final data = jsonDecode(json);
    if (data is! Map<String, dynamic>) return null;
    final name = (data['name'] ?? '').toString().trim();
    if (name.isEmpty) return null;
    final now = DateTime.now().millisecondsSinceEpoch;
    return WorldsCompanion.insert(
      id: const Uuid().v4(),
      name: name,
      description: Value((data['description'] as String?)?.trim()),
      rulesJson: Value((data['rulesJson'] ?? '{}').toString()),
      initialStateJson: Value((data['initialStateJson'] ?? '{}').toString()),
      npcPoolJson: Value((data['npcPoolJson'] ?? '{}').toString()),
      createdAt: now,
      updatedAt: now,
    );
  } catch (_) {
    return null;
  }
}
