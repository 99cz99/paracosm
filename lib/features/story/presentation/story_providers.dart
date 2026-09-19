import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database.dart';
import '../../../core/providers/db_providers.dart';

final storiesProvider = StreamProvider<List<Story>>((ref) {
  return ref.watch(dbProvider).watchStories();
});
