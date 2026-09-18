import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paracosm/core/db/database.dart';
import 'package:paracosm/core/network/llm/llm_provider.dart';
import 'package:paracosm/features/story/data/story_repository.dart';
import 'package:paracosm/features/story/data/story_service.dart';

class _FakeStoryProvider implements LlmProvider {
  @override
  String get id => 'fake-story';

  @override
  ProviderType get type => ProviderType.openaiCompatible;

  @override
  Stream<ChatChunk> streamChat(ChatRequest request) async* {
    yield ChatChunk(
      textDelta: '{"narrative":"你走进了一间教室。","choices":["坐下","离开"]}',
    );
    yield ChatChunk(finishReason: 'stop');
  }

  @override
  Future<void> cancel() async {}
}

Future<AppDatabase> _db() async {
  final db = AppDatabase.forTesting(NativeDatabase.memory());
  await db.insertStory(StoriesCompanion.insert(
    id: 's1',
    name: '测试剧本',
    createdAt: 1,
    updatedAt: 1,
  ));
  return db;
}

void main() {
  test('generateNode parses narrative + choices', () async {
    final db = await _db();
    final result =
        await StoryService(db).generateNode(storyId: 's1', provider: _FakeStoryProvider());
    expect(result.narrative, '你走进了一间教室。');
    expect(result.choices, ['坐下', '离开']);
    await db.close();
  });

  test('addNode builds a tree and backtracks via setCurrentNode', () async {
    final db = await _db();
    final repo = StoryRepository(db);

    final root = await repo.addNode(
      storyId: 's1',
      narrative: '开场',
      choices: ['A', 'B'],
      depth: 0,
    );
    final child = await repo.addNode(
      storyId: 's1',
      parentId: root,
      narrative: '选了A',
      choices: ['C'],
      chosenIndex: 0,
      depth: 1,
    );

    final path = await db.getStoryPath('s1', child);
    expect(path.length, 2);
    expect(path.first.id, root);
    expect(path.last.id, child);

    await repo.setCurrentNode('s1', root); // backtrack
    final story = await db.getStory('s1');
    expect(story!.currentNodeId, root);

    await db.close();
  });

  test('save and load restore the current node', () async {
    final db = await _db();
    final repo = StoryRepository(db);
    final node = await repo.addNode(
      storyId: 's1',
      narrative: '开场',
      choices: ['A'],
      depth: 0,
    );

    await repo.save(storyId: 's1', label: '存档1', currentNodeId: node);
    await repo.setCurrentNode('s1', null);

    final saves = await db.getStorySaves('s1');
    expect(saves.length, 1);
    expect(saves.first.label, '存档1');
    expect(saves.first.currentNodeId, node);

    await repo.setCurrentNode('s1', saves.first.currentNodeId);
    final story = await db.getStory('s1');
    expect(story!.currentNodeId, node);

    await db.close();
  });
}
