import 'package:flutter_test/flutter_test.dart';
import 'package:paracosm/core/network/sse/sse_parser.dart';

void main() {
  test('parses OpenAI-style data lines and [DONE]', () async {
    final events = await Stream.fromIterable(const [
      'data: {"choices":[{"delta":{"content":"你"}}]}',
      'data: [DONE]',
    ]).transform(SseParser()).toList();

    expect(events.length, 2);
    expect(events[0].event, isNull);
    expect(events[0].data, contains('choices'));
    expect(events[1].data, '[DONE]');
  });

  test('buffers Anthropic event line then data line', () async {
    final events = await Stream.fromIterable(const [
      'event: content_block_delta',
      'data: {"type":"content_block_delta","delta":{"type":"text_delta","text":"hi"}}',
    ]).transform(SseParser()).toList();

    expect(events.length, 1);
    expect(events[0].event, 'content_block_delta');
    expect(events[0].data, contains('text_delta'));
  });

  test('ignores comments and blank keepalive lines', () async {
    final events = await Stream.fromIterable(const [
      ': keepalive',
      '',
      'data: {}',
    ]).transform(SseParser()).toList();

    expect(events.length, 1);
    expect(events[0].data, '{}');
  });
}
