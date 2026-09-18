import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:uuid/uuid.dart';

import '../config/app_config.dart';
import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Characters,
    CharacterAdaptations,
    Worlds,
    Sessions,
    Messages,
    SessionStates,
    CharacterRelations,
    CharacterAffinities,
    CharacterMemories,
    ProviderConfigs,
    Presets,
    Settings,
    Groups,
    GroupMembers,
    GroupMessages,
    PairRelations,
    GroupMemories,
    Stories,
    StoryNodes,
    StorySaves,
    Worldbooks,
    CharacterWorldbooks,
    WorldWorldbooks,
    GroupWorldbooks,
    StoryWorldbooks,
    GroupWorlds,
    StoryWorlds,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// Production: sqlite file in the app's documents directory.
  AppDatabase() : super(driftDatabase(name: 'mj'));

  /// Tests: inject an in-memory / temp executor.
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => AppConfig.schemaVersion;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // character_relations gained a world_id column and a composite
            // (character_id, world_id) primary key. Recreate the table — the
            // relation memory is re-extractable, so dropping is acceptable.
            await m.deleteTable('character_relations');
            await m.createTable(characterRelations);
          }
          if (from < 3) {
            // Skill growth moved out of core['affinity'] into a per-world
            // table; the core value stays as the seed.
            await m.createTable(characterAffinities);
          }
          if (from < 4) {
            // World-scoped memory (state + rolling summary) so it survives
            // session deletion and is shared across sessions of a world.
            await m.createTable(characterMemories);
          }
          if (from < 5) {
            // Per-session API + sampling params; group memory toggle; presets.
            await m.addColumn(sessions, sessions.providerId);
            await m.addColumn(sessions, sessions.temperature);
            await m.addColumn(sessions, sessions.topP);
            await m.addColumn(sessions, sessions.maxTokens);
            await m.addColumn(sessions, sessions.presencePenalty);
            await m.addColumn(sessions, sessions.frequencyPenalty);
            await m.addColumn(groups, groups.memoryEnabled);
            await m.createTable(presets);
          }
          if (from < 6) {
            // Worldbooks become a first-class library; group/story gain
            // multi-world + worldbook bindings. Legacy embedded JSON is moved
            // verbatim into Worldbooks rows and bound back to its owner.
            await m.createTable(worldbooks);
            await m.createTable(characterWorldbooks);
            await m.createTable(worldWorldbooks);
            await m.createTable(groupWorldbooks);
            await m.createTable(storyWorldbooks);
            await m.createTable(groupWorlds);
            await m.createTable(storyWorlds);

            final db = m.database;
            final nonEmptyWorldbook = '''
worldbook_json IS NOT NULL AND worldbook_json != ''
  AND worldbook_json != '{}' AND worldbook_json != 'null' ''';

            // Worlds.worldbookJson -> Worldbooks + WorldWorldbooks (mostly '{}',
            // handled defensively in case future data lands here).
            await db.customStatement('''
              INSERT INTO worldbooks
                (id, name, description, book_json, source_type, source_path,
                 created_at, updated_at)
              SELECT 'wwb_' || id, name || ' 世界书', '',
                     worldbook_json, 'manual', NULL, created_at, updated_at
              FROM worlds WHERE $nonEmptyWorldbook
            ''');
            await db.customStatement('''
              INSERT INTO world_worldbooks (world_id, worldbook_id, created_at)
              SELECT id, 'wwb_' || id, created_at
              FROM worlds WHERE $nonEmptyWorldbook
            ''');

            // Groups.worldId -> GroupWorlds (keep the column as primary world).
            await db.customStatement('''
              INSERT INTO group_worlds (group_id, world_id, created_at)
              SELECT id, world_id, created_at FROM groups
              WHERE world_id IS NOT NULL AND world_id != ''
            ''');

            // Stories.worldId -> StoryWorlds.
            await db.customStatement('''
              INSERT INTO story_worlds (story_id, world_id, created_at)
              SELECT id, world_id, created_at FROM stories
              WHERE world_id IS NOT NULL AND world_id != ''
            ''');
          }
          if (from < 7) {
            // Undo the v6 auto-extraction of characters' built-in worldbooks:
            // move any `wb_<charId>` library rows back onto the character and
            // drop them from the shared library.
            final db = m.database;
            await db.customStatement('''
              UPDATE characters SET worldbook_json = (
                SELECT book_json FROM worldbooks
                WHERE worldbooks.id = 'wb_' || characters.id
              )
              WHERE EXISTS (
                SELECT 1 FROM worldbooks WHERE worldbooks.id = 'wb_' || characters.id
              )
            ''');
            await db.customStatement('''
              DELETE FROM character_worldbooks WHERE worldbook_id LIKE 'wb_%'
            ''');
            await db.customStatement('''
              DELETE FROM worldbooks WHERE id LIKE 'wb_%'
            ''');
          }
          if (from < 8) {
            // Character pin-to-top for the contacts list.
            await m.addColumn(characters, characters.pinnedAt);
          }
          if (from < 9) {
            // Group-scoped independent memory (state + rolling summary),
            // separate from single-chat memory.
            await m.createTable(groupMemories);
          }
          if (from < 10) {
            // Per-group API + sampling params (mirrors Sessions).
            await m.addColumn(groups, groups.providerId);
            await m.addColumn(groups, groups.temperature);
            await m.addColumn(groups, groups.topP);
            await m.addColumn(groups, groups.maxTokens);
            await m.addColumn(groups, groups.presencePenalty);
            await m.addColumn(groups, groups.frequencyPenalty);
          }
          if (from < 11) {
            // Slash-command messages: type tag + AI-visibility flag.
            await m.addColumn(messages, messages.type);
            await m.addColumn(messages, messages.visibleToAi);
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  // ---------------------------------------------------------------------
  // Characters
  // ---------------------------------------------------------------------
  Stream<List<Character>> watchCharacters() =>
      (select(characters)..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .watch();

  Future<Character?> getCharacter(String id) =>
      (select(characters)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<Character?> getCharacterByName(String name) =>
      (select(characters)..where((t) => t.name.equals(name))).getSingleOrNull();

  Stream<Character?> watchCharacter(String id) =>
      (select(characters)..where((t) => t.id.equals(id))).watchSingleOrNull();

  Future<void> insertCharacter(CharactersCompanion entry) =>
      into(characters).insert(entry);

  Future<void> deleteCharacter(String id) =>
      (delete(characters)..where((t) => t.id.equals(id))).go();

  Future<void> updateCharacter(String id, CharactersCompanion entry) =>
      (update(characters)..where((t) => t.id.equals(id))).write(entry);

  /// Pins a character to the top of the contacts list (or unpins when false).
  Future<void> setCharacterPinned(String id, bool pinned) =>
      (update(characters)..where((t) => t.id.equals(id))).write(
        CharactersCompanion(
          pinnedAt: Value(
            pinned ? DateTime.now().millisecondsSinceEpoch : null,
          ),
        ),
      );

  // ---------------------------------------------------------------------
  // Adaptations
  // ---------------------------------------------------------------------
  Future<CharacterAdaptation?> getAdaptation(
    String characterId,
    String worldId,
  ) =>
      (select(characterAdaptations)
            ..where((t) =>
                t.characterId.equals(characterId) & t.worldId.equals(worldId)))
          .getSingleOrNull();

  Future<void> insertAdaptation(CharacterAdaptationsCompanion entry) =>
      into(characterAdaptations).insert(entry);

  Future<void> upsertAdaptation(CharacterAdaptationsCompanion entry) =>
      into(characterAdaptations).insertOnConflictUpdate(entry);

  Future<void> deleteAdaptation(String id) =>
      (delete(characterAdaptations)..where((t) => t.id.equals(id))).go();

  Stream<List<AdaptationWithWorld>> watchAdaptationsFor(String characterId) {
    final query = select(characterAdaptations).join([
      leftOuterJoin(worlds, worlds.id.equalsExp(characterAdaptations.worldId)),
    ]);
    query.where(characterAdaptations.characterId.equals(characterId));
    return query.watch().map((rows) => rows.map((row) {
          final adaptation = row.readTable(characterAdaptations);
          final world = row.readTableOrNull(worlds);
          return AdaptationWithWorld(
            adaptation: adaptation,
            worldName: world?.name,
          );
        }).toList());
  }

  // ---------------------------------------------------------------------
  // Worlds
  // ---------------------------------------------------------------------
  Stream<List<World>> watchWorlds() =>
      (select(worlds)..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .watch();

  Future<World?> getWorld(String id) =>
      (select(worlds)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> insertWorld(WorldsCompanion entry) => into(worlds).insert(entry);

  Future<void> updateWorld(String id, WorldsCompanion entry) =>
      (update(worlds)..where((t) => t.id.equals(id))).write(entry);

  /// Deletes a world and every row bound to it (adaptations, sessions,
  /// relations, skill growth and world memory). Sessions cascade their own
  /// messages/state via FK.
  Future<void> deleteWorld(String id) async {
    await transaction(() async {
      await (delete(characterAdaptations)
            ..where((t) => t.worldId.equals(id)))
          .go();
      await (delete(sessions)..where((t) => t.worldId.equals(id))).go();
      await (delete(characterRelations)
            ..where((t) => t.worldId.equals(id)))
          .go();
      await (delete(characterAffinities)
            ..where((t) => t.worldId.equals(id)))
          .go();
      await (delete(characterMemories)
            ..where((t) => t.worldId.equals(id)))
          .go();
      await (delete(worlds)..where((t) => t.id.equals(id))).go();
    });
  }

  // ---------------------------------------------------------------------
  // Groups (group chat)
  // ---------------------------------------------------------------------
  Stream<List<Group>> watchGroups() =>
      (select(groups)..orderBy([(t) => OrderingTerm.desc(t.lastMessageAt)]))
          .watch();

  Future<Group?> getGroup(String id) =>
      (select(groups)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> insertGroup(GroupsCompanion entry) => into(groups).insert(entry);

  Future<void> updateGroup(String id, GroupsCompanion entry) =>
      (update(groups)..where((t) => t.id.equals(id))).write(entry);

  Future<void> deleteGroup(String id) =>
      (delete(groups)..where((t) => t.id.equals(id))).go();

  Future<void> touchGroup(String id, int ts) => (update(groups)
        ..where((t) => t.id.equals(id)))
      .write(GroupsCompanion(updatedAt: Value(ts), lastMessageAt: Value(ts)));

  Stream<List<GroupMemberWithCharacter>> watchMembersFor(String groupId) {
    final query = select(groupMembers).join([
      innerJoin(characters, characters.id.equalsExp(groupMembers.characterId)),
    ]);
    query.where(groupMembers.groupId.equals(groupId));
    query.orderBy([OrderingTerm.asc(groupMembers.joinOrder)]);
    return query.watch().map((rows) => rows.map((row) {
          final member = row.readTable(groupMembers);
          final character = row.readTable(characters);
          return GroupMemberWithCharacter(member: member, character: character);
        }).toList());
  }

  Future<List<GroupMember>> getMembers(String groupId) =>
      (select(groupMembers)
            ..where((t) => t.groupId.equals(groupId))
            ..orderBy([(t) => OrderingTerm.asc(t.joinOrder)]))
          .get();

  Future<void> insertMember(GroupMembersCompanion entry) =>
      into(groupMembers).insert(entry);

  Future<void> deleteMember(String groupId, String characterId) =>
      (delete(groupMembers)
            ..where((t) =>
                t.groupId.equals(groupId) & t.characterId.equals(characterId)))
          .go();

  Stream<List<GroupMessage>> watchGroupMessages(String groupId) =>
      (select(groupMessages)
            ..where((t) => t.groupId.equals(groupId))
            ..orderBy([(t) => OrderingTerm.asc(t.orderIndex)]))
          .watch();

  Future<List<GroupMessage>> getGroupMessages(String groupId) =>
      (select(groupMessages)
            ..where((t) => t.groupId.equals(groupId))
            ..orderBy([(t) => OrderingTerm.asc(t.orderIndex)]))
          .get();

  Future<int> nextGroupOrderIndex(String groupId) async {
    final countExpr = groupMessages.id.count();
    final query = selectOnly(groupMessages)
      ..addColumns([countExpr])
      ..where(groupMessages.groupId.equals(groupId));
    final row = await query.getSingle();
    return row.read(countExpr) ?? 0;
  }

  Future<void> insertGroupMessage(GroupMessagesCompanion entry) =>
      into(groupMessages).insert(entry);

  Future<PairRelation?> getPairRelation(String groupId, String a, String b) {
    final charA = a.compareTo(b) <= 0 ? a : b;
    final charB = a.compareTo(b) <= 0 ? b : a;
    return (select(pairRelations)
          ..where((t) =>
              t.groupId.equals(groupId) &
              t.charA.equals(charA) &
              t.charB.equals(charB)))
        .getSingleOrNull();
  }

  Future<void> upsertPairRelation(PairRelationsCompanion entry) =>
      into(pairRelations).insertOnConflictUpdate(entry);

  Future<List<PairRelation>> getPairRelations(String groupId) =>
      (select(pairRelations)..where((t) => t.groupId.equals(groupId))).get();

  // ---------------------------------------------------------------------
  // Group memory (group-scoped state + rolling summary, isolated from chat)
  // ---------------------------------------------------------------------
  Future<GroupMemory?> getGroupMemory(String groupId) =>
      (select(groupMemories)..where((t) => t.groupId.equals(groupId)))
          .getSingleOrNull();

  Future<void> upsertGroupMemory(GroupMemoriesCompanion entry) =>
      into(groupMemories).insertOnConflictUpdate(entry);

  // ---------------------------------------------------------------------
  // Stories (visual novel)
  // ---------------------------------------------------------------------
  Stream<List<Story>> watchStories() =>
      (select(stories)..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])).watch();

  Future<Story?> getStory(String id) =>
      (select(stories)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> insertStory(StoriesCompanion entry) => into(stories).insert(entry);

  Future<void> updateStory(String id, StoriesCompanion entry) =>
      (update(stories)..where((t) => t.id.equals(id))).write(entry);

  Future<void> deleteStory(String id) =>
      (delete(stories)..where((t) => t.id.equals(id))).go();

  Future<List<StoryNode>> getStoryNodes(String storyId) =>
      (select(storyNodes)
            ..where((t) => t.storyId.equals(storyId))
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .get();

  Future<StoryNode?> getStoryNode(String id) =>
      (select(storyNodes)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> insertStoryNode(StoryNodesCompanion entry) =>
      into(storyNodes).insert(entry);

  /// Path from root to [nodeId] (root-first).
  Future<List<StoryNode>> getStoryPath(String storyId, String? nodeId) async {
    final result = <StoryNode>[];
    var current = nodeId;
    while (current != null) {
      final node = await (select(storyNodes)..where((t) => t.id.equals(current!)))
          .getSingleOrNull();
      if (node == null || node.storyId != storyId) break;
      result.insert(0, node);
      current = node.parentId;
    }
    return result;
  }

  Future<List<StoryNode>> getChildren(String storyId, String? parentId) {
    final query = select(storyNodes)
      ..where((t) => t.storyId.equals(storyId));
    if (parentId == null) {
      query.where((t) => t.parentId.isNull());
    } else {
      query.where((t) => t.parentId.equals(parentId));
    }
    query.orderBy([(t) => OrderingTerm.asc(t.createdAt)]);
    return query.get();
  }

  /// The existing child produced by choosing [chosenIndex] on [parentId].
  Future<StoryNode?> getChildByChosenIndex(
    String storyId,
    String parentId,
    int chosenIndex,
  ) =>
      (select(storyNodes)
            ..where((t) =>
                t.storyId.equals(storyId) &
                t.parentId.equals(parentId) &
                t.chosenIndex.equals(chosenIndex)))
          .getSingleOrNull();

  Future<void> updateStoryNode(
    String id, {
    required String narrative,
    required String choicesJson,
  }) =>
      (update(storyNodes)..where((t) => t.id.equals(id))).write(
        StoryNodesCompanion(
          narrative: Value(narrative),
          choicesJson: Value(choicesJson),
        ),
      );

  /// Deletes a node and its entire subtree (recursive).
  Future<void> deleteStoryNodeSubtree(String id) async {
    final ids = <String>[id];
    final queue = <String>[id];
    while (queue.isNotEmpty) {
      final current = queue.removeLast();
      final children = await (select(storyNodes)
            ..where((t) => t.parentId.equals(current)))
          .get();
      for (final c in children) {
        ids.add(c.id);
        queue.add(c.id);
      }
    }
    await (delete(storyNodes)..where((t) => t.id.isIn(ids))).go();
  }

  Future<void> insertStorySave(StorySavesCompanion entry) =>
      into(storySaves).insert(entry);

  Future<void> deleteStorySave(String id) =>
      (delete(storySaves)..where((t) => t.id.equals(id))).go();

  Future<List<StorySave>> getStorySaves(String storyId) =>
      (select(storySaves)
            ..where((t) => t.storyId.equals(storyId))
            ..orderBy([(t) => OrderingTerm.desc(t.savedAt)]))
          .get();

  Future<StorySave?> getQuickSave(String storyId) =>
      (select(storySaves)
            ..where((t) => t.storyId.equals(storyId) & t.isQuick.equals(true)))
          .getSingleOrNull();

  // ---------------------------------------------------------------------
  // Worldbooks (independent library)
  // ---------------------------------------------------------------------
  Stream<List<Worldbook>> watchWorldbooks() =>
      (select(worldbooks)..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .watch();

  Future<Worldbook?> getWorldbook(String id) =>
      (select(worldbooks)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> insertWorldbook(WorldbooksCompanion entry) =>
      into(worldbooks).insert(entry);

  Future<void> updateWorldbook(String id, WorldbooksCompanion entry) =>
      (update(worldbooks)..where((t) => t.id.equals(id))).write(entry);

  /// Deletes a worldbook; its bindings are removed via FK cascade.
  Future<void> deleteWorldbook(String id) =>
      (delete(worldbooks)..where((t) => t.id.equals(id))).go();

  Future<List<Worldbook>> getWorldbooksByIds(Set<String> ids) => ids.isEmpty
      ? Future.value(const [])
      : (select(worldbooks)..where((t) => t.id.isIn(ids))).get();

  Future<List<World>> getWorldsByIds(Set<String> ids) => ids.isEmpty
      ? Future.value(const [])
      : (select(worlds)..where((t) => t.id.isIn(ids))).get();

  // --- CharacterWorldbooks -------------------------------------------------
  Stream<List<Worldbook>> watchWorldbooksForCharacter(String characterId) {
    final query = select(characterWorldbooks).join([
      innerJoin(worldbooks, worldbooks.id.equalsExp(characterWorldbooks.worldbookId)),
    ]);
    query.where(characterWorldbooks.characterId.equals(characterId));
    return query.watch().map(
        (rows) => rows.map((row) => row.readTable(worldbooks)).toList());
  }

  Future<List<String>> getCharacterWorldbookIds(String characterId) async {
    final rows = await (select(characterWorldbooks)
          ..where((t) => t.characterId.equals(characterId)))
        .get();
    return rows.map((r) => r.worldbookId).toList();
  }

  Future<void> bindCharacterWorldbook(
    String characterId,
    String worldbookId,
    int createdAt,
  ) =>
      into(characterWorldbooks).insert(
        CharacterWorldbooksCompanion.insert(
          characterId: characterId,
          worldbookId: worldbookId,
          createdAt: createdAt,
        ),
        mode: InsertMode.insertOrIgnore,
      );

  Future<void> unbindCharacterWorldbook(
    String characterId,
    String worldbookId,
  ) =>
      (delete(characterWorldbooks)
            ..where((t) =>
                t.characterId.equals(characterId) &
                t.worldbookId.equals(worldbookId)))
          .go();

  Future<void> setCharacterWorldbooks(
    String characterId,
    Set<String> worldbookIds,
    int createdAt,
  ) async {
    await transaction(() async {
      await (delete(characterWorldbooks)
            ..where((t) => t.characterId.equals(characterId)))
          .go();
      for (final wid in worldbookIds) {
        await into(characterWorldbooks).insert(
          CharacterWorldbooksCompanion.insert(
            characterId: characterId,
            worldbookId: wid,
            createdAt: createdAt,
          ),
          mode: InsertMode.insertOrIgnore,
        );
      }
    });
  }

  // --- WorldWorldbooks -----------------------------------------------------
  Stream<List<Worldbook>> watchWorldbooksForWorld(String worldId) {
    final query = select(worldWorldbooks).join([
      innerJoin(worldbooks, worldbooks.id.equalsExp(worldWorldbooks.worldbookId)),
    ]);
    query.where(worldWorldbooks.worldId.equals(worldId));
    return query.watch().map(
        (rows) => rows.map((row) => row.readTable(worldbooks)).toList());
  }

  Future<List<String>> getWorldWorldbookIds(String worldId) async {
    final rows = await (select(worldWorldbooks)
          ..where((t) => t.worldId.equals(worldId)))
        .get();
    return rows.map((r) => r.worldbookId).toList();
  }

  Future<void> bindWorldWorldbook(
    String worldId,
    String worldbookId,
    int createdAt,
  ) =>
      into(worldWorldbooks).insert(
        WorldWorldbooksCompanion.insert(
          worldId: worldId,
          worldbookId: worldbookId,
          createdAt: createdAt,
        ),
        mode: InsertMode.insertOrIgnore,
      );

  Future<void> unbindWorldWorldbook(String worldId, String worldbookId) =>
      (delete(worldWorldbooks)
            ..where((t) =>
                t.worldId.equals(worldId) & t.worldbookId.equals(worldbookId)))
          .go();

  Future<void> setWorldWorldbooks(
    String worldId,
    Set<String> worldbookIds,
    int createdAt,
  ) async {
    await transaction(() async {
      await (delete(worldWorldbooks)..where((t) => t.worldId.equals(worldId)))
          .go();
      for (final wid in worldbookIds) {
        await into(worldWorldbooks).insert(
          WorldWorldbooksCompanion.insert(
            worldId: worldId,
            worldbookId: wid,
            createdAt: createdAt,
          ),
          mode: InsertMode.insertOrIgnore,
        );
      }
    });
  }

  // --- GroupWorldbooks -----------------------------------------------------
  Stream<List<Worldbook>> watchWorldbooksForGroup(String groupId) {
    final query = select(groupWorldbooks).join([
      innerJoin(worldbooks, worldbooks.id.equalsExp(groupWorldbooks.worldbookId)),
    ]);
    query.where(groupWorldbooks.groupId.equals(groupId));
    return query.watch().map(
        (rows) => rows.map((row) => row.readTable(worldbooks)).toList());
  }

  Future<List<String>> getGroupWorldbookIds(String groupId) async {
    final rows = await (select(groupWorldbooks)
          ..where((t) => t.groupId.equals(groupId)))
        .get();
    return rows.map((r) => r.worldbookId).toList();
  }

  Future<void> bindGroupWorldbook(
    String groupId,
    String worldbookId,
    int createdAt,
  ) =>
      into(groupWorldbooks).insert(
        GroupWorldbooksCompanion.insert(
          groupId: groupId,
          worldbookId: worldbookId,
          createdAt: createdAt,
        ),
        mode: InsertMode.insertOrIgnore,
      );

  Future<void> unbindGroupWorldbook(String groupId, String worldbookId) =>
      (delete(groupWorldbooks)
            ..where((t) =>
                t.groupId.equals(groupId) & t.worldbookId.equals(worldbookId)))
          .go();

  Future<void> setGroupWorldbooks(
    String groupId,
    Set<String> worldbookIds,
    int createdAt,
  ) async {
    await transaction(() async {
      await (delete(groupWorldbooks)..where((t) => t.groupId.equals(groupId)))
          .go();
      for (final wid in worldbookIds) {
        await into(groupWorldbooks).insert(
          GroupWorldbooksCompanion.insert(
            groupId: groupId,
            worldbookId: wid,
            createdAt: createdAt,
          ),
          mode: InsertMode.insertOrIgnore,
        );
      }
    });
  }

  // --- StoryWorldbooks -----------------------------------------------------
  Stream<List<Worldbook>> watchWorldbooksForStory(String storyId) {
    final query = select(storyWorldbooks).join([
      innerJoin(worldbooks, worldbooks.id.equalsExp(storyWorldbooks.worldbookId)),
    ]);
    query.where(storyWorldbooks.storyId.equals(storyId));
    return query.watch().map(
        (rows) => rows.map((row) => row.readTable(worldbooks)).toList());
  }

  Future<List<String>> getStoryWorldbookIds(String storyId) async {
    final rows = await (select(storyWorldbooks)
          ..where((t) => t.storyId.equals(storyId)))
        .get();
    return rows.map((r) => r.worldbookId).toList();
  }

  Future<void> bindStoryWorldbook(
    String storyId,
    String worldbookId,
    int createdAt,
  ) =>
      into(storyWorldbooks).insert(
        StoryWorldbooksCompanion.insert(
          storyId: storyId,
          worldbookId: worldbookId,
          createdAt: createdAt,
        ),
        mode: InsertMode.insertOrIgnore,
      );

  Future<void> unbindStoryWorldbook(String storyId, String worldbookId) =>
      (delete(storyWorldbooks)
            ..where((t) =>
                t.storyId.equals(storyId) & t.worldbookId.equals(worldbookId)))
          .go();

  Future<void> setStoryWorldbooks(
    String storyId,
    Set<String> worldbookIds,
    int createdAt,
  ) async {
    await transaction(() async {
      await (delete(storyWorldbooks)..where((t) => t.storyId.equals(storyId)))
          .go();
      for (final wid in worldbookIds) {
        await into(storyWorldbooks).insert(
          StoryWorldbooksCompanion.insert(
            storyId: storyId,
            worldbookId: wid,
            createdAt: createdAt,
          ),
          mode: InsertMode.insertOrIgnore,
        );
      }
    });
  }

  // --- GroupWorlds (multi-world) -------------------------------------------
  Stream<List<World>> watchWorldsForGroup(String groupId) {
    final query = select(groupWorlds).join([
      innerJoin(worlds, worlds.id.equalsExp(groupWorlds.worldId)),
    ]);
    query.where(groupWorlds.groupId.equals(groupId));
    return query.watch()
        .map((rows) => rows.map((row) => row.readTable(worlds)).toList());
  }

  Future<List<String>> getGroupWorldIds(String groupId) async {
    final rows = await (select(groupWorlds)
          ..where((t) => t.groupId.equals(groupId)))
        .get();
    return rows.map((r) => r.worldId).toList();
  }

  Future<void> bindGroupWorld(
    String groupId,
    String worldId,
    int createdAt,
  ) =>
      into(groupWorlds).insert(
        GroupWorldsCompanion.insert(
          groupId: groupId,
          worldId: worldId,
          createdAt: createdAt,
        ),
        mode: InsertMode.insertOrIgnore,
      );

  Future<void> unbindGroupWorld(String groupId, String worldId) =>
      (delete(groupWorlds)
            ..where((t) => t.groupId.equals(groupId) & t.worldId.equals(worldId)))
          .go();

  Future<void> setGroupWorlds(
    String groupId,
    Set<String> worldIds,
    int createdAt,
  ) async {
    await transaction(() async {
      await (delete(groupWorlds)..where((t) => t.groupId.equals(groupId))).go();
      for (final wid in worldIds) {
        await into(groupWorlds).insert(
          GroupWorldsCompanion.insert(
            groupId: groupId,
            worldId: wid,
            createdAt: createdAt,
          ),
          mode: InsertMode.insertOrIgnore,
        );
      }
    });
  }

  // --- StoryWorlds (multi-world) -------------------------------------------
  Stream<List<World>> watchWorldsForStory(String storyId) {
    final query = select(storyWorlds).join([
      innerJoin(worlds, worlds.id.equalsExp(storyWorlds.worldId)),
    ]);
    query.where(storyWorlds.storyId.equals(storyId));
    return query.watch()
        .map((rows) => rows.map((row) => row.readTable(worlds)).toList());
  }

  Future<List<String>> getStoryWorldIds(String storyId) async {
    final rows = await (select(storyWorlds)
          ..where((t) => t.storyId.equals(storyId)))
        .get();
    return rows.map((r) => r.worldId).toList();
  }

  Future<void> bindStoryWorld(
    String storyId,
    String worldId,
    int createdAt,
  ) =>
      into(storyWorlds).insert(
        StoryWorldsCompanion.insert(
          storyId: storyId,
          worldId: worldId,
          createdAt: createdAt,
        ),
        mode: InsertMode.insertOrIgnore,
      );

  Future<void> unbindStoryWorld(String storyId, String worldId) =>
      (delete(storyWorlds)
            ..where((t) => t.storyId.equals(storyId) & t.worldId.equals(worldId)))
          .go();

  Future<void> setStoryWorlds(
    String storyId,
    Set<String> worldIds,
    int createdAt,
  ) async {
    await transaction(() async {
      await (delete(storyWorlds)..where((t) => t.storyId.equals(storyId))).go();
      for (final wid in worldIds) {
        await into(storyWorlds).insert(
          StoryWorldsCompanion.insert(
            storyId: storyId,
            worldId: wid,
            createdAt: createdAt,
          ),
          mode: InsertMode.insertOrIgnore,
        );
      }
    });
  }

  // ---------------------------------------------------------------------
  // Search (LIKE-based; FTS5 can be layered on for scale)
  // ---------------------------------------------------------------------
  Future<List<Character>> searchCharacters(String query) => (select(characters)
        ..where((t) => t.name.like('%$query%') | t.tags.like('%$query%')))
      .get();

  Future<List<Message>> searchMessages(String query) =>
      (select(messages)..where((t) => t.content.like('%$query%'))).get();

  // ---------------------------------------------------------------------
  // Sessions
  // ---------------------------------------------------------------------
  Stream<List<SessionWithCharacter>> watchSessionsWithCharacter() {
    final query = select(sessions).join([
      leftOuterJoin(characters, characters.id.equalsExp(sessions.characterId)),
      leftOuterJoin(worlds, worlds.id.equalsExp(sessions.worldId)),
    ]);
    query.orderBy([OrderingTerm.desc(sessions.lastMessageAt)]);
    return query.watch().map((rows) => rows.map((row) {
          final session = row.readTable(sessions);
          final character = row.readTableOrNull(characters);
          final world = row.readTableOrNull(worlds);
          return SessionWithCharacter(
            session: session,
            characterName: character?.name ?? '',
            avatarPath: character?.avatarPath,
            worldName: world?.name,
          );
        }).toList());
  }

  Future<Session?> getSession(String id) =>
      (select(sessions)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// Most recent session for a character in a world. `worldId` null/empty means
  /// the default (no-world) session — matches both NULL and '' rows so the
  /// two historical spellings of "default" never diverge.
  Future<Session?> getSessionForCharacter(String characterId, String? worldId) {
    final query = select(sessions)
      ..where((t) => t.characterId.equals(characterId));
    if (worldId == null || worldId.isEmpty) {
      query.where((t) => t.worldId.isNull() | t.worldId.equals(''));
    } else {
      query.where((t) => t.worldId.equals(worldId));
    }
    query
      ..orderBy([(t) => OrderingTerm.desc(t.lastMessageAt)])
      ..limit(1);
    return query.getSingleOrNull();
  }

  Future<void> insertSession(SessionsCompanion entry) =>
      into(sessions).insert(entry);

  Future<void> touchSession(String id, int ts) => (update(sessions)
        ..where((t) => t.id.equals(id)))
      .write(SessionsCompanion(updatedAt: Value(ts), lastMessageAt: Value(ts)));

  Future<void> updateSession(String id, SessionsCompanion entry) =>
      (update(sessions)..where((t) => t.id.equals(id))).write(entry);

  Future<void> deleteSession(String id) async {
    final session = await getSession(id);
    if (session == null) return;
    final characterId = session.characterId;
    final worldId = session.worldId ?? '';
    // Deleting a session also clears its world-scoped memory (state / summary /
    // relation / growth) — memory is tied to the session's lifetime.
    await transaction(() async {
      await (delete(sessions)..where((t) => t.id.equals(id))).go();
      await resetCharacterMemory(characterId, worldId);
      await resetCharacterRelation(characterId, worldId);
      await resetCharacterAffinity(characterId, worldId);
    });
  }

  // ---------------------------------------------------------------------
  // Messages
  // ---------------------------------------------------------------------
  Stream<List<Message>> watchMessages(String sessionId) =>
      (select(messages)
            ..where((t) => t.sessionId.equals(sessionId))
            ..orderBy([(t) => OrderingTerm.asc(t.orderIndex)]))
          .watch();

  Future<List<Message>> getMessages(String sessionId) =>
      (select(messages)
            ..where((t) => t.sessionId.equals(sessionId))
            ..orderBy([(t) => OrderingTerm.asc(t.orderIndex)]))
          .get();

  Future<int> nextOrderIndex(String sessionId) async {
    // Max+1 (not count) so a recalled message leaves no gap that would make the
    // next insert collide with an existing orderIndex.
    final maxExpr = messages.orderIndex.max();
    final query = selectOnly(messages)
      ..addColumns([maxExpr])
      ..where(messages.sessionId.equals(sessionId));
    final row = await query.getSingle();
    return (row.read(maxExpr) ?? -1) + 1;
  }

  Future<void> insertMessage(MessagesCompanion entry) =>
      into(messages).insert(entry);

  /// Recalls (deletes) a single message. Safe for messages mid-conversation
  /// thanks to [nextOrderIndex] using max+1 rather than count.
  Future<void> deleteMessage(String id) =>
      (delete(messages)..where((t) => t.id.equals(id))).go();

  /// Replaces the opening (orderIndex 0) assistant message, or inserts one when
  /// the session has no opening message yet.
  Future<void> replaceOpeningMessage(String sessionId, String content) async {
    final existing = await (select(messages)
          ..where((t) => t.sessionId.equals(sessionId) & t.orderIndex.equals(0)))
        .getSingleOrNull();
    if (existing != null) {
      await (update(messages)..where((t) => t.id.equals(existing.id)))
          .write(MessagesCompanion(content: Value(content)));
    } else {
      await insertMessage(MessagesCompanion.insert(
        id: const Uuid().v4(),
        sessionId: sessionId,
        role: 'assistant',
        content: content,
        orderIndex: 0,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ));
    }
  }

  // ---------------------------------------------------------------------
  // Memory: session state + character relation
  // ---------------------------------------------------------------------
  Future<SessionState?> getSessionState(String sessionId) =>
      (select(sessionStates)..where((t) => t.sessionId.equals(sessionId)))
          .getSingleOrNull();

  Future<void> upsertSessionState(SessionStatesCompanion entry) =>
      into(sessionStates).insertOnConflictUpdate(entry);

  Future<CharacterRelation?> getCharacterRelation(
    String characterId,
    String worldId,
  ) =>
      (select(characterRelations)
            ..where((t) =>
                t.characterId.equals(characterId) & t.worldId.equals(worldId)))
          .getSingleOrNull();

  Future<void> upsertCharacterRelation(CharacterRelationsCompanion entry) =>
      into(characterRelations).insertOnConflictUpdate(entry);

  /// Clears the relationship memory for a character in a world so a fresh
  /// session starts from the initial state again.
  Future<void> resetCharacterRelation(String characterId, String worldId) =>
      (delete(characterRelations)
            ..where((t) =>
                t.characterId.equals(characterId) & t.worldId.equals(worldId)))
          .go();

  // ---------------------------------------------------------------------
  // Skill growth (per character × world)
  // ---------------------------------------------------------------------
  Future<CharacterAffinity?> getCharacterAffinity(
    String characterId,
    String worldId,
  ) =>
      (select(characterAffinities)
            ..where((t) =>
                t.characterId.equals(characterId) & t.worldId.equals(worldId)))
          .getSingleOrNull();

  Future<void> upsertCharacterAffinity(CharacterAffinitiesCompanion entry) =>
      into(characterAffinities).insertOnConflictUpdate(entry);

  Future<void> resetCharacterAffinity(String characterId, String worldId) =>
      (delete(characterAffinities)
            ..where((t) =>
                t.characterId.equals(characterId) & t.worldId.equals(worldId)))
          .go();

  // ---------------------------------------------------------------------
  // World-scoped memory (state + rolling summary), keyed by character × world
  // ---------------------------------------------------------------------
  Future<CharacterMemory?> getCharacterMemory(
    String characterId,
    String worldId,
  ) =>
      (select(characterMemories)
            ..where((t) =>
                t.characterId.equals(characterId) & t.worldId.equals(worldId)))
          .getSingleOrNull();

  Future<void> upsertCharacterMemory(CharacterMemoriesCompanion entry) =>
      into(characterMemories).insertOnConflictUpdate(entry);

  Future<void> resetCharacterMemory(String characterId, String worldId) =>
      (delete(characterMemories)
            ..where((t) =>
                t.characterId.equals(characterId) & t.worldId.equals(worldId)))
          .go();

  /// True when any world-scoped memory exists for a character×world (relation,
  /// state/summary, or skill growth) — drives the "继续 / 全新开始" prompt.
  Future<bool> hasCharacterMemory(String characterId, String worldId) async {
    final relation = await getCharacterRelation(characterId, worldId);
    if (relation != null &&
        relation.relationJson.isNotEmpty &&
        relation.relationJson != '{}') {
      return true;
    }
    final memory = await getCharacterMemory(characterId, worldId);
    if (memory != null &&
        ((memory.stateJson.isNotEmpty && memory.stateJson != '{}') ||
            memory.summaryText.isNotEmpty)) {
      return true;
    }
    final affinity = await getCharacterAffinity(characterId, worldId);
    if (affinity != null &&
        affinity.affinityJson.isNotEmpty &&
        affinity.affinityJson != '{}') {
      return true;
    }
    return false;
  }

  // ---------------------------------------------------------------------
  // Provider configs
  // ---------------------------------------------------------------------
  Stream<List<ProviderConfig>> watchProviderConfigs() => select(providerConfigs).watch();

  Future<ProviderConfig?> getDefaultProviderConfig() =>
      (select(providerConfigs)..where((t) => t.isDefault.equals(true)))
          .getSingleOrNull();

  Future<ProviderConfig?> getProviderConfig(String id) =>
      (select(providerConfigs)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> insertProviderConfig(ProviderConfigsCompanion entry) =>
      into(providerConfigs).insert(entry);

  Future<void> updateProviderConfig(String id, ProviderConfigsCompanion entry) =>
      (update(providerConfigs)..where((t) => t.id.equals(id))).write(entry);

  Future<void> deleteProviderConfig(String id) =>
      (delete(providerConfigs)..where((t) => t.id.equals(id))).go();

  Future<void> clearDefaultProvider() => (update(providerConfigs)
        ..where((t) => t.isDefault.equals(true)))
      .write(const ProviderConfigsCompanion(isDefault: Value(false)));

  // ---------------------------------------------------------------------
  // Sampling presets
  // ---------------------------------------------------------------------
  Stream<List<Preset>> watchPresets() =>
      (select(presets)..orderBy([(t) => OrderingTerm.asc(t.name)])).watch();

  Future<Preset?> getPreset(String id) =>
      (select(presets)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> insertPreset(PresetsCompanion entry) =>
      into(presets).insert(entry);

  Future<void> updatePreset(String id, PresetsCompanion entry) =>
      (update(presets)..where((t) => t.id.equals(id))).write(entry);

  Future<void> deletePreset(String id) =>
      (delete(presets)..where((t) => t.id.equals(id))).go();

  // ---------------------------------------------------------------------
  // Settings
  // ---------------------------------------------------------------------
  Future<String?> getSetting(String key) async {
    final row = await (select(settings)..where((t) => t.key.equals(key)))
        .getSingleOrNull();
    return row?.value;
  }

  Future<void> setSetting(String key, String value) => into(settings)
      .insertOnConflictUpdate(SettingsCompanion.insert(key: key, value: value));
}

/// Session joined with its character name for list display.
class SessionWithCharacter {
  SessionWithCharacter({
    required this.session,
    required this.characterName,
    this.avatarPath,
    this.worldName,
  });

  final Session session;
  final String characterName;
  final String? avatarPath;
  final String? worldName;
}

/// Adaptation joined with its world name (null = the default adaptation).
class AdaptationWithWorld {
  AdaptationWithWorld({required this.adaptation, this.worldName});

  final CharacterAdaptation adaptation;
  final String? worldName;
}

/// Group member joined with its character.
class GroupMemberWithCharacter {
  GroupMemberWithCharacter({required this.member, required this.character});

  final GroupMember member;
  final Character character;
}
