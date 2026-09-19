import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../../core/db/database.dart';
import '../../../core/utils/avatar_image.dart';

class GroupRepository {
  GroupRepository(this._db);

  final AppDatabase _db;
  static final _uuid = const Uuid();

  Future<String> createGroup({
    required String name,
    required List<String> characterIds,
    List<String> worldIds = const [],
    List<String> worldbookIds = const [],
    String speakMode = 'auto',
  }) async {
    // Dedupe: reuse an existing group whose members / worlds / worldbooks are
    // the exact same set, rather than creating a duplicate.
    final existingId =
        await _findExistingGroup(characterIds, worldIds, worldbookIds);
    if (existingId != null) return existingId;

    final now = DateTime.now().millisecondsSinceEpoch;
    final id = _uuid.v4();
    // `worldId` stays the primary world (memory scoping / list display); the
    // full set lives in GroupWorlds.
    await _db.insertGroup(GroupsCompanion.insert(
      id: id,
      name: name,
      worldId: Value(worldIds.isEmpty ? null : worldIds.first),
      speakMode: Value(speakMode),
      createdAt: now,
      updatedAt: now,
      lastMessageAt: now,
    ));
    for (final wid in worldIds) {
      await _db.bindGroupWorld(id, wid, now);
    }
    for (final wbId in worldbookIds) {
      await _db.bindGroupWorldbook(id, wbId, now);
    }
    for (var i = 0; i < characterIds.length; i++) {
      await _db.insertMember(GroupMembersCompanion.insert(
        id: _uuid.v4(),
        groupId: id,
        characterId: characterIds[i],
        joinOrder: i,
      ));
    }
    return id;
  }

  Future<String?> _findExistingGroup(
    List<String> characterIds,
    List<String> worldIds,
    List<String> worldbookIds,
  ) async {
    final targetMembers = characterIds.toSet();
    final targetWorlds = worldIds.toSet();
    final targetBooks = worldbookIds.toSet();

    // Load everything in three aggregate queries (not per-group) and compare
    // in memory to avoid N+1 on group creation.
    final groups = await _db.watchGroups().first;
    final allMembers = await _db.getAllGroupMembers();
    final allWorlds = await _db.getAllGroupWorlds();
    final allBooks = await _db.getAllGroupWorldbooks();

    final membersByGroup = <String, Set<String>>{};
    for (final m in allMembers) {
      membersByGroup.putIfAbsent(m.groupId, () => <String>{}).add(m.characterId);
    }
    final worldsByGroup = <String, Set<String>>{};
    for (final w in allWorlds) {
      worldsByGroup.putIfAbsent(w.groupId, () => <String>{}).add(w.worldId);
    }
    final booksByGroup = <String, Set<String>>{};
    for (final b in allBooks) {
      booksByGroup.putIfAbsent(b.groupId, () => <String>{}).add(b.worldbookId);
    }

    for (final g in groups) {
      if (!_setEquals(membersByGroup[g.id] ?? const {}, targetMembers)) {
        continue;
      }
      if (!_setEquals(worldsByGroup[g.id] ?? const {}, targetWorlds)) continue;
      if (_setEquals(booksByGroup[g.id] ?? const {}, targetBooks)) return g.id;
    }
    return null;
  }

  static bool _setEquals(Set<String> a, Set<String> b) =>
      a.length == b.length && a.containsAll(b);

  Future<void> deleteGroup(String id) => _db.deleteGroup(id);

  /// Updates the group's world + worldbook bindings (and its primary world).
  Future<void> updateGroupWorlds({
    required String groupId,
    required List<String> worldIds,
    required List<String> worldbookIds,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await _db.updateGroup(groupId, GroupsCompanion(
      worldId: Value(worldIds.isEmpty ? null : worldIds.first),
      updatedAt: Value(now),
    ));
    await _db.setGroupWorlds(groupId, worldIds.toSet(), now);
    await _db.setGroupWorldbooks(groupId, worldbookIds.toSet(), now);
  }

  Future<void> addMembers(String groupId, List<String> characterIds) async {
    final existing = await _db.getMembers(groupId);
    var next = existing.isEmpty
        ? 0
        : existing.map((m) => m.joinOrder).reduce((a, b) => a > b ? a : b) + 1;
    for (final characterId in characterIds) {
      await _db.insertMember(GroupMembersCompanion.insert(
        id: _uuid.v4(),
        groupId: groupId,
        characterId: characterId,
        joinOrder: next++,
      ));
    }
  }

  Future<void> removeMember(String groupId, String characterId) =>
      _db.deleteMember(groupId, characterId);

  Future<void> renameGroup(String groupId, String name) => _db.updateGroup(
        groupId,
        GroupsCompanion(
          name: Value(name),
          updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
        ),
      );

  Future<void> setGroupAvatar(String groupId, String? avatarPath) =>
      _db.updateGroup(
        groupId,
        GroupsCompanion(
          avatarPath: Value(avatarPath),
          updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
        ),
      );

  Future<String> saveGroupAvatar(List<int> bytes, {String? oldPath}) async {
    final dir = await getApplicationDocumentsDirectory();
    final avatarDir = Directory(p.join(dir.path, 'avatars'));
    await avatarDir.create(recursive: true);
    final file = File(p.join(avatarDir.path, '${_uuid.v4()}.png'));
    await file.writeAsBytes(resizeAvatarPng(bytes));
    if (oldPath != null && oldPath.isNotEmpty) {
      try {
        await File(oldPath).delete();
      } catch (_) {
        // Best-effort: a missing/held old file shouldn't fail the save.
      }
    }
    return file.path;
  }
}
