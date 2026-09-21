import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paracosm/features/chat/presentation/widgets/message_bubble.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        home: Scaffold(body: SingleChildScrollView(child: child)),
      );

  // Mirrors a regex_scripts forum/status panel: fixed dims + flex + gap that
  // previously overflowed the 320px bubble (right + bottom).
  const panel = '正文叙事文字。\n'
      '<details><summary>**[漫研社区]**</summary>\n'
      '><body>\n'
      '<div style="max-width:800px;margin:20px auto;background:#fff;">\n'
      '  <div style="display:flex;justify-content:center;gap:40px;">\n'
      '    <span>转发 10</span><span>喜欢 20</span><span>热度 30</span>\n'
      '  </div>\n'
      '  <div style="height:600px;overflow-y:scroll;">\n'
      '    <img src="https://files.catbox.moe/abc.png" style="width:100%;">\n'
      '    <div>帖子标题：这是标题</div>\n'
      '    <div>帖子正文内容在这里</div>\n'
      '  </div>\n'
      '</div>\n'
      '></body>\n'
      '</details>';

  testWidgets('panel text renders alongside narrative', (tester) async {
    await tester.pumpWidget(wrap(const MessageBubble(
      role: 'assistant',
      content: panel,
    )));
    expect(find.textContaining('正文叙事文字', findRichText: true), findsWidgets);
    expect(find.textContaining('帖子标题', findRichText: true), findsWidgets);
    expect(find.textContaining('帖子正文', findRichText: true), findsWidgets);
  });

  testWidgets('overflow-causing CSS is neutralized (no RenderFlex overflow)',
      (tester) async {
    await tester.pumpWidget(wrap(const MessageBubble(
      role: 'assistant',
      content: panel,
    )));
    expect(tester.takeException(), isNull);
  });
}
