import 'llm_provider.dart';

/// A keyless fake provider that echoes the last message word-by-word.
///
/// Lets the full "send → stream → persist" path run without any API key,
/// for tests and manual UI checks.
class MockStreamProvider implements LlmProvider {
  MockStreamProvider({
    this.id = 'mock',
    this.chunkDelay = const Duration(milliseconds: 20),
  });

  @override
  final String id;
  final Duration chunkDelay;

  @override
  ProviderType get type => ProviderType.openaiCompatible;

  @override
  Stream<ChatChunk> streamChat(ChatRequest request) async* {
    final last = request.messages.isEmpty ? '' : request.messages.last.content;
    final reply = '（模拟回复）$last';
    for (final ch in reply.runes) {
      await Future<void>.delayed(chunkDelay);
      yield ChatChunk(textDelta: String.fromCharCode(ch));
    }
    yield ChatChunk(finishReason: 'stop', completionTokens: reply.length);
  }

  @override
  Future<void> cancel() async {}
}
