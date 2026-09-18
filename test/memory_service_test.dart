import 'package:flutter_test/flutter_test.dart';
import 'package:paracosm/core/db/database.dart';
import 'package:paracosm/features/chat/data/memory_service.dart';

Message _msg(String content) => Message(
      id: '1',
      sessionId: 's1',
      role: 'user',
      content: content,
      orderIndex: 0,
      timestamp: 1,
      metadata: '{}',
      visibleToAi: true,
    );

void main() {
  test('worldbook triggers on keyword match only', () {
    const book = '{"entries":['
        '{"keys":["图书馆"],"content":"图书馆在三楼","enabled":true},'
        '{"keys":["操场"],"content":"操场很大","enabled":true}'
        ']}';
    final triggered =
        MemoryService.triggeredWorldbook(book, [_msg('我们今天去了图书馆')]);
    expect(triggered, ['图书馆在三楼']);
  });

  test('constant worldbook entries always trigger', () {
    const book = '{"entries":['
        '{"keys":[],"content":"永远生效","enabled":true,"constant":true}'
        ']}';
    final triggered = MemoryService.triggeredWorldbook(book, [_msg('无关内容')]);
    expect(triggered, ['永远生效']);
  });

  test('disabled entries do not trigger', () {
    const book = '{"entries":['
        '{"keys":["测试"],"content":"不该出现","enabled":false}'
        ']}';
    final triggered = MemoryService.triggeredWorldbook(book, [_msg('测试')]);
    expect(triggered, isEmpty);
  });

  test('malformed worldbook returns empty', () {
    expect(MemoryService.triggeredWorldbook('not json', [_msg('x')]), isEmpty);
    expect(MemoryService.triggeredWorldbook(null, [_msg('x')]), isEmpty);
  });
}
