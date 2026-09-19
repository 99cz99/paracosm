import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/db/database.dart';

class StoryRepository {
  StoryRepository(this._db);

  final AppDatabase _db;
  static final _uuid = const Uuid();

  Future<String> createStory({
    required String name,
    required String description,
    String? characterId,
    List<String> worldIds = const [],
    List<String> worldbookIds = const [],
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final id = _uuid.v4();
    // `worldId` stays the primary world; the full set lives in StoryWorlds.
    await _db.insertStory(StoriesCompanion.insert(
      id: id,
      name: name,
      description: Value(description),
      characterId: Value(characterId),
      worldId: Value(worldIds.isEmpty ? null : worldIds.first),
      createdAt: now,
      updatedAt: now,
    ));
    for (final wid in worldIds) {
      await _db.bindStoryWorld(id, wid, now);
    }
    for (final wbId in worldbookIds) {
      await _db.bindStoryWorldbook(id, wbId, now);
    }
    return id;
  }

  /// Updates story metadata (name/description/character) and its world +
  /// worldbook bindings.
  Future<void> updateStoryMeta({
    required String storyId,
    required String name,
    required String description,
    String? characterId,
    required List<String> worldIds,
    required List<String> worldbookIds,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await _db.updateStory(storyId, StoriesCompanion(
      name: Value(name),
      description: Value(description),
      characterId: Value(characterId),
      worldId: Value(worldIds.isEmpty ? null : worldIds.first),
      updatedAt: Value(now),
    ));
    await _db.setStoryWorlds(storyId, worldIds.toSet(), now);
    await _db.setStoryWorldbooks(storyId, worldbookIds.toSet(), now);
  }

  /// Adds a node and advances the story's current node to it.
  Future<String> addNode({
    required String storyId,
    String? parentId,
    required String narrative,
    required List<String> choices,
    int? chosenIndex,
    required int depth,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final id = _uuid.v4();
    await _db.insertStoryNode(StoryNodesCompanion.insert(
      id: id,
      storyId: storyId,
      parentId: Value(parentId),
      narrative: narrative,
      choicesJson: Value(jsonEncode(choices)),
      chosenIndex: Value(chosenIndex),
      depth: Value(depth),
      createdAt: now,
    ));
    await _db.updateStory(storyId, StoriesCompanion(
      currentNodeId: Value(id),
      updatedAt: Value(now),
    ));
    return id;
  }

  /// Moves the story's current position (backtrack / load).
  Future<void> setCurrentNode(String storyId, String? nodeId) async {
    await _db.updateStory(storyId, StoriesCompanion(
      currentNodeId: Value(nodeId),
      updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
    ));
  }

  Future<String> save({
    required String storyId,
    required String label,
    String? currentNodeId,
    bool isQuick = false,
  }) async {
    final id = _uuid.v4();
    await _db.insertStorySave(StorySavesCompanion.insert(
      id: id,
      storyId: storyId,
      label: label,
      currentNodeId: Value(currentNodeId),
      isQuick: Value(isQuick),
      savedAt: DateTime.now().millisecondsSinceEpoch,
    ));
    return id;
  }

  Future<void> deleteSave(String id) => _db.deleteStorySave(id);

  Future<void> renameSave(String id, String label) =>
      _db.renameStorySave(id, label);

  /// Overwrites a node's narrative + choices in place (regenerate).
  Future<void> editNode(String nodeId, String narrative, List<String> choices) =>
      _db.updateStoryNode(nodeId,
          narrative: narrative, choicesJson: jsonEncode(choices));

  /// Regenerates a node: overwrite its narrative/choices and drop its now-stale
  /// children.
  Future<void> regenerateNode(
    String storyId,
    String nodeId,
    String narrative,
    List<String> choices,
  ) async {
    final children = await _db.getChildren(storyId, nodeId);
    for (final c in children) {
      await _db.deleteStoryNodeSubtree(c.id);
    }
    await editNode(nodeId, narrative, choices);
  }

  /// Deletes a node and its subtree; clears the story's current node if it was
  /// inside the deleted subtree.
  Future<void> deleteSubtree(String storyId, String nodeId) async {
    await _db.deleteStoryNodeSubtree(nodeId);
    final story = await _db.getStory(storyId);
    if (story != null && story.currentNodeId != null) {
      final still = await _db.getStoryNode(story.currentNodeId!);
      if (still == null) {
        await setCurrentNode(storyId, null);
      }
    }
  }
}
