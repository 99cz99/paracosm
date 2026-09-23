import 'package:flutter_test/flutter_test.dart';
import 'package:paracosm/core/utils/html_sanitize.dart';

void main() {
  test('inlines <style> class CSS onto class elements', () {
    const html = '<style>\n'
        '.gal-container {\n'
        '  background: linear-gradient(135deg, #fff0f3 0%, #ffe5e5 100%);\n'
        '  border: 3px solid #FF69B4;\n'
        '  border-radius: 8px;\n'
        '  padding: 20px;\n'
        '  position: relative;\n'
        '}\n'
        '.gal-content { color: #000000; font-size: 16px; }\n'
        '</style>\n'
        '<div class="gal-container"><div class="gal-content">正文</div></div>';
    final out = sanitizeHtml(html);
    expect(out, isNot(contains('<style')));
    // Gradient degraded to a solid colour fallback (its last #hex).
    expect(out, contains('background-color: #ffe5e5'));
    expect(out, isNot(contains('linear-gradient')));
    expect(out, contains('border: 3px solid #FF69B4'));
    expect(out, contains('padding: 20px'));
    expect(out, contains('color: #000000'));
    // position:relative is neutralized, not left to overflow.
    expect(out, isNot(contains('position: relative')));
  });

  test('display:flex in class CSS becomes block', () {
    const html = '<style>.row { display: flex; }</style>'
        '<div class="row">x</div>';
    final out = sanitizeHtml(html);
    expect(out, contains('display: block'));
    expect(out, isNot(contains('display: flex')));
  });

  test('existing inline style wins over class CSS, class fills the gaps', () {
    const html = '<style>.box { color: #ff0000; padding: 10px; }</style>'
        '<div class="box" style="color: #00ff00;">x</div>';
    final out = sanitizeHtml(html);
    expect(out, contains('color: #00ff00'));
    expect(out, isNot(contains('color: #ff0000')));
    expect(out, contains('padding: 10px'));
  });

  test('drops overflow-causing class props (width/height/gap/box-shadow)', () {
    const html = '<style>.panel { width: 800px; height: 600px; gap: 40px; '
        'box-shadow: 0 4px 12px rgba(0,0,0,0.1); color: #000; }</style>'
        '<div class="panel">x</div>';
    final out = sanitizeHtml(html);
    expect(out, contains('color: #000'));
    expect(out, isNot(contains('width: 800px')));
    expect(out, isNot(contains('height: 600px')));
    expect(out, isNot(contains('gap: 40px')));
    expect(out, isNot(contains('box-shadow')));
  });

  test('keeps <details>/<summary> for native collapsible rendering', () {
    const html = '<details><summary>**标题**</summary><div>正文</div></details>';
    final out = sanitizeHtml(html);
    expect(out, contains('<details>'));
    expect(out, contains('<summary>'));
    expect(out, contains('</details>'));
    // **bold** inside the summary still becomes <b> (markdown step).
    expect(out, contains('<b>标题</b>'));
  });
}
