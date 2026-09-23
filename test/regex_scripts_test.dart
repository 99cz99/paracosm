import 'package:flutter_test/flutter_test.dart';
import 'package:paracosm/core/utils/regex_scripts.dart';

void main() {
  test('applies a JS regex script with \$1 backreference', () {
    final scripts = [
      {
        'findRegex': r'/<CG([\s\S]*?)>/gs',
        'replaceString': '<img src="https://x.test/\$1.png">',
      },
    ];
    final out = applyRegexScripts(scripts, 'text <CGabc123> end');
    expect(out, 'text <img src="https://x.test/abc123.png"> end');
  });

  test('skips an invalid regex', () {
    final scripts = [
      {'findRegex': '/[/g', 'replaceString': 'X'},
    ];
    expect(applyRegexScripts(scripts, 'abc'), 'abc');
  });

  test('treats a bare value as a regex pattern', () {
    final scripts = [
      {'findRegex': r'\[QQ\]', 'replaceString': '微信'},
    ];
    expect(applyRegexScripts(scripts, 'a[QQ]b'), 'a微信b');
  });

  test('handles a bare value with no metacharacters', () {
    final scripts = [
      {'findRegex': '<Gal>', 'replaceString': 'START'},
    ];
    expect(applyRegexScripts(scripts, 'a<Gal>b'), 'aSTARTb');
  });

  test('skips a promptOnly script (must not delete display content)', () {
    final scripts = [
      {
        'findRegex': r'/<TTL>[\s\S]*?<\/TTL>/gm',
        'replaceString': '',
        'promptOnly': true,
      },
      {'findRegex': r'\[QQ\]', 'replaceString': '微信面板'},
    ];
    // The <TTL> block must survive (its wrapped panels are for display), and
    // the [QQ] inside it must still be replaced.
    expect(
      applyRegexScripts(scripts, '<TTL>\n[QQ]\n</TTL>'),
      '<TTL>\n微信面板\n</TTL>',
    );
  });

  test('skips a disabled script', () {
    final scripts = [
      {'findRegex': r'\[QQ\]', 'replaceString': 'X', 'disabled': true},
    ];
    expect(applyRegexScripts(scripts, 'a[QQ]b'), 'a[QQ]b');
  });

  test('prompt-side script strips <TTL> only at/after minDepth', () {
    final scripts = [
      {
        'findRegex': r'/<TTL>[\s\S]*?<\/TTL>/gm',
        'replaceString': '',
        'promptOnly': true,
        'placement': [2],
        'minDepth': 4,
      },
    ];
    expect(
      applyPromptRegexScripts(scripts, '<TTL>panel</TTL>',
          role: 'assistant', depth: 3),
      '<TTL>panel</TTL>',
    );
    expect(
      applyPromptRegexScripts(scripts, '<TTL>panel</TTL>',
          role: 'assistant', depth: 4),
      '',
    );
  });

  test('prompt-side script honors placement (AI-only skips user)', () {
    final scripts = [
      {
        'findRegex': r'/<TTL>[\s\S]*?<\/TTL>/gm',
        'replaceString': '',
        'promptOnly': true,
        'placement': [2],
      },
    ];
    expect(applyPromptRegexScripts(scripts, '<TTL>x</TTL>', role: 'user'),
        '<TTL>x</TTL>');
  });

  test('display-side script honors placement (AI-only skips user)', () {
    final scripts = [
      {
        'findRegex': r'/<WX>[\s\S]*?<\/WX>/gm',
        'replaceString': '',
        'placement': [2],
      },
    ];
    expect(applyRegexScripts(scripts, '<WX>hi</WX>', role: 'assistant'), '');
    expect(
        applyRegexScripts(scripts, '<WX>hi</WX>', role: 'user'), '<WX>hi</WX>');
  });

  test('display-side script honors minDepth (only clears old messages)', () {
    final scripts = [
      {
        'findRegex': r'/<WX>[\s\S]*?<\/WX>/gm',
        'replaceString': '',
        'placement': [2],
        'minDepth': 4,
      },
    ];
    // Recent messages (depth < 4) keep their WeChat text; older ones are cut.
    expect(
      applyRegexScripts(scripts, '<WX>hi</WX>', role: 'assistant', depth: 3),
      '<WX>hi</WX>',
    );
    expect(
      applyRegexScripts(scripts, '<WX>hi</WX>', role: 'assistant', depth: 4),
      '',
    );
  });
}
