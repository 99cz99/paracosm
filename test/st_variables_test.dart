import 'package:flutter_test/flutter_test.dart';
import 'package:paracosm/core/utils/prompt_template.dart';

void main() {
  test('expandStVariables expands setvar/getvar', () {
    expect(expandStVariables('{{setvar::x::hello}}{{getvar::x}}'), 'hello');
  });

  test('expandStVariables strips setvar and resolves getvar later', () {
    final out = expandStVariables(
        '{{setvar::JailbreakPrompt::破限全文}}\n引用：{{getvar::JailbreakPrompt}}');
    expect(out, '\n引用：破限全文');
  });

  test('expandStVariables handles multi-line values', () {
    final out = expandStVariables('{{setvar::x::第一行\n第二行}}[{{getvar::x}}]');
    expect(out, '[第一行\n第二行]');
  });

  test('expandStVariables leaves unknown getvar untouched', () {
    expect(expandStVariables('{{getvar::unknown}}'), '{{getvar::unknown}}');
  });

  test('expandStVariables is a no-op without macros', () {
    expect(expandStVariables('普通文本 {{char}}'), '普通文本 {{char}}');
  });
}
