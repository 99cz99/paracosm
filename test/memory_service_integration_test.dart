import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paracosm/core/db/database.dart';
import 'package:paracosm/core/network/llm/llm_provider.dart';
import 'package:paracosm/features/chat/data/memory_service.dart';

/// A deterministic fake LLM that returns valid JSON for extraction prompts and
/// a short text for summary prompts, keyed on the prompt content.
class _FakeMemoryProvider implements LlmProvider {
  @override
  String get id => 'fake-memory';

  @override
  ProviderType get type => ProviderType.openaiCompatible;

  @override
  Stream<ChatChunk> streamChat(ChatRequest request) async* {
    final prompt = request.messages.last.content;
    final String reply;
    if (prompt.contains('状态 JSON')) {
      reply = '{"scene":"图书馆","facts":["已聊多轮"],"items":["书签"]}';
    } else if (prompt.contains('关系 JSON')) {
      reply = '{"affection":50,"trust":40,"intimacy":30,"notes":"关系升温"}';
    } else {
      reply = '摘要：在图书馆聊天，关系逐渐升温。';
    }
    yield ChatChunk(textDelta: reply);
    yield ChatChunk(finishReason: 'stop');
  }

  @override
  Future<void> cancel() async {}
}

void main() {
  test('20+ turns update state, relation, and produce a rolling summary',
      () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());

    await db.insertCharacter(CharactersCompanion.insert(
      id: 'c1',
      name: '宁宁',
      corePersonaJson: '{}',
      sourceType: 'manual',
      createdAt: 1,
      updatedAt: 1,
    ));
    await db.insertSession(SessionsCompanion.insert(
      id: 's1',
      characterId: 'c1',
      createdAt: 1,
      updatedAt: 1,
      lastMessageAt: 1,
    ));

    // 24 messages (12 user/assistant pairs) → exceeds the 20-message window.
    for (var i = 0; i < 24; i++) {
      await db.insertMessage(MessagesCompanion.insert(
        id: 'm$i',
        sessionId: 's1',
        role: i.isEven ? 'user' : 'assistant',
        content: '消息 $i',
        orderIndex: i,
        timestamp: i,
      ));
    }

    await MemoryService(db).updateAfterTurn('s1', _FakeMemoryProvider());

    // State changed from the default '{}' (now world-scoped memory).
    final memory = await db.getCharacterMemory('c1', '');
    expect(memory, isNotNull);
    expect(memory!.stateJson, contains('图书馆'));

    // Relation changed from the default '{}'.
    final relation = await db.getCharacterRelation('c1', '');
    expect(relation, isNotNull);
    expect(relation!.relationJson, contains('affection'));

    // Rolling summary happened (world-scoped): text non-empty; summaryIndex
    // stays session-scoped and advances past the summarized messages.
    expect(memory.summaryText, isNotEmpty);
    final state = await db.getSessionState('s1');
    expect(state, isNotNull);
    expect(state!.summaryIndex, greaterThan(0));

    await db.close();
  });
}
