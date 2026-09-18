import 'package:flutter_test/flutter_test.dart';
import 'package:paracosm/core/network/llm/llm_provider.dart';
import 'package:paracosm/core/network/llm/translator.dart';
import 'package:paracosm/core/utils/app_exception.dart';

/// A fake provider that replays a queue of canned replies (one per call),
/// letting tests exercise `translateKeys` without a network/API key.
class _FakeProvider implements LlmProvider {
  _FakeProvider(this.replies);

  final List<String> replies;
  int _i = 0;

  @override
  String get id => 'fake';

  @override
  ProviderType get type => ProviderType.openaiCompatible;

  @override
  Stream<ChatChunk> streamChat(ChatRequest request) async* {
    final text = _i < replies.length ? replies[_i++] : '';
    yield ChatChunk(textDelta: text);
    yield ChatChunk(finishReason: 'stop');
  }

  @override
  Future<void> cancel() async {}
}

class _ThrowingProvider extends _FakeProvider {
  _ThrowingProvider() : super(const []);

  @override
  Stream<ChatChunk> streamChat(ChatRequest request) async* {
    throw Exception('boom');
  }
}

void main() {
  test('parses a plain JSON object', () async {
    final p = _FakeProvider(['{"library":"图书馆","forest":"森林"}']);
    expect(await translateKeys(p, ['library', 'forest']),
        {'library': '图书馆', 'forest': '森林'});
  });

  test('strips markdown code fences', () async {
    final p = _FakeProvider(['```json\n{"library":"图书馆"}\n```']);
    expect(await translateKeys(p, ['library']), {'library': '图书馆'});
  });

  test('maps a JSON array output back to the key order', () async {
    final p = _FakeProvider(['["图书馆","森林"]']);
    expect(await translateKeys(p, ['library', 'forest']),
        {'library': '图书馆', 'forest': '森林'});
  });

  test('tolerates trailing commas', () async {
    final p = _FakeProvider(['{"library":"图书馆",}']);
    expect(await translateKeys(p, ['library']), {'library': '图书馆'});
  });

  test('matches keys the model echoes with different casing', () async {
    final p = _FakeProvider(['{"HelloWorld":"你好世界"}']);
    expect(await translateKeys(p, ['HelloWorld']), {'HelloWorld': '你好世界'});
  });

  test('extracts JSON from prose around it', () async {
    final p = _FakeProvider(
        ['好的，以下是翻译：\n```json\n{"library":"图书馆"}\n```\n希望有帮助']);
    expect(await translateKeys(p, ['library']), {'library': '图书馆'});
  });

  test('skips CJK keys and only translates the English ones', () async {
    final p = _FakeProvider(['{"forest":"森林"}']);
    expect(await translateKeys(p, ['图书馆', 'forest']), {'forest': '森林'});
  });

  test('retries with a stricter prompt when the first pass is unusable',
      () async {
    final p = _FakeProvider(['我不会翻译', '{"library":"图书馆"}']);
    expect(await translateKeys(p, ['library']), {'library': '图书馆'});
  });

  test('throws LlmException with raw output when nothing is parseable',
      () async {
    final p = _FakeProvider(['这是图书馆的意思', '这是图书馆的意思']);
    await expectLater(
      translateKeys(p, ['library']),
      throwsA(isA<LlmException>()
          .having((e) => e.message, 'message', contains('原始返回'))),
    );
  });

  test('returns an empty map on stream/network errors', () async {
    expect(await translateKeys(_ThrowingProvider(), ['library']), isEmpty);
  });

  test('returns an empty map when there is nothing to translate', () async {
    expect(await translateKeys(_FakeProvider(const []), ['图书馆']), isEmpty);
  });
}
