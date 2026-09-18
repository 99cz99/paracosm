import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database.dart';
import '../../../core/providers/db_providers.dart';

final groupsProvider = StreamProvider<List<Group>>((ref) {
  return ref.watch(dbProvider).watchGroups();
});

final groupProvider = FutureProvider.family<Group?, String>((ref, id) {
  return ref.watch(dbProvider).getGroup(id);
});

final groupMembersProvider =
    StreamProvider.family<List<GroupMemberWithCharacter>, String>(
        (ref, groupId) => ref.watch(dbProvider).watchMembersFor(groupId));

final groupMessagesProvider =
    StreamProvider.family<List<GroupMessage>, String>(
        (ref, groupId) => ref.watch(dbProvider).watchGroupMessages(groupId));

final groupWorldsProvider =
    StreamProvider.family<List<World>, String>((ref, groupId) {
  return ref.watch(dbProvider).watchWorldsForGroup(groupId);
});

final groupWorldbooksProvider =
    StreamProvider.family<List<Worldbook>, String>((ref, groupId) {
  return ref.watch(dbProvider).watchWorldbooksForGroup(groupId);
});
