import 'package:flutter_test/flutter_test.dart';
import 'package:paracosm/core/network/llm/llm_provider.dart';
import 'package:paracosm/core/network/llm/mock_stream_provider.dart';

void main() {
  test('mock provider streams a reply that echoes the input', () async {
    final provider = MockStreamProvider(chunkDelay: Duration.zero);
    final chunks = await provider
        .streamChat(ChatRequest(
          messages: const [ChatMessage(role: 'user', content: '你好')],
        ))
        .toList();

    final text = chunks.map((c) => c.textDelta ?? '').join();
    expect(text, contains('你好'));
    expect(chunks.last.finishReason, 'stop');
  });
}
