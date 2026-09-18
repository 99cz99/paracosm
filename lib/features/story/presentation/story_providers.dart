import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database.dart';
import '../../../core/providers/db_providers.dart';

final storiesProvider = StreamProvider<List<Story>>((ref) {
  return ref.watch(dbProvider).watchStories();
});

final storyProvider = FutureProvider.family<Story?, String>((ref, id) {
  return ref.watch(dbProvider).getStory(id);
});

final storyNodesProvider =
    FutureProvider.family<List<StoryNode>, String>((ref, storyId) {
  return ref.watch(dbProvider).getStoryNodes(storyId);
});

final storySavesProvider =
    FutureProvider.family<List<StorySave>, String>((ref, storyId) {
  return ref.watch(dbProvider).getStorySaves(storyId);
});

final storyWorldsProvider =
    StreamProvider.family<List<World>, String>((ref, storyId) {
  return ref.watch(dbProvider).watchWorldsForStory(storyId);
});

final storyWorldbooksProvider =
    StreamProvider.family<List<Worldbook>, String>((ref, storyId) {
  return ref.watch(dbProvider).watchWorldbooksForStory(storyId);
});
