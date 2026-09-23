import 'package:flutter_test/flutter_test.dart';
import 'package:paracosm/core/network/llm/llm_provider.dart';

void main() {
  test('ChatMessage.toJson stays text-only without images', () {
    const m = ChatMessage(role: 'user', content: 'hi');
    expect(m.toJson(), {'role': 'user', 'content': 'hi'});
  });

  test('ChatMessage.toJson emits multimodal content with images', () {
    const m = ChatMessage(
      role: 'user',
      content: '看这张图',
      images: ['data:image/png;base64,AAAA'],
    );
    final json = m.toJson();
    expect(json['role'], 'user');
    final content = json['content'] as List;
    expect(content[0], {'type': 'text', 'text': '看这张图'});
    expect(content[1], {
      'type': 'image_url',
      'image_url': {'url': 'data:image/png;base64,AAAA'},
    });
  });
}
