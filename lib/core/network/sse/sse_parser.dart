import 'dart:async';

/// One parsed Server-Sent-Events item.
///
/// OpenAI-compatible streams send `data: {...}` per line; Anthropic sends an
/// `event: <type>` line followed by a `data: {...}` line. This class carries
/// both so providers can dispatch on either.
class SseEvent {
  SseEvent({this.event, required this.data});

  final String? event;
  final String data;

  @override
  String toString() => 'SseEvent(event: $event, data: $data)';
}

/// Turns raw SSE text lines into [SseEvent]s, buffering the `event:` line so a
/// following `data:` line inherits it. Ignores comments (`:`) and blank lines.
class SseParser extends StreamTransformerBase<String, SseEvent> {
  @override
  Stream<SseEvent> bind(Stream<String> stream) async* {
    String? pendingEvent;
    await for (final raw in stream) {
      final line = raw.trimRight();
      if (line.isEmpty) continue;
      if (line.startsWith(':')) continue; // SSE comment / keepalive
      if (line.startsWith('event:')) {
        pendingEvent = line.substring(6).trim();
        continue;
      }
      if (line.startsWith('data:')) {
        final data = line.substring(5).trim();
        yield SseEvent(event: pendingEvent, data: data);
        pendingEvent = null;
      }
      // any other field (id:/retry:) is ignored for our providers
    }
  }
}
