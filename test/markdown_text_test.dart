import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paracosm/core/widgets/markdown_text.dart';

String _fullText(List<InlineSpan> spans) => spans.map(_text).join();

String _text(InlineSpan span) {
  if (span is TextSpan) {
    return (span.text ?? '') +
        (span.children ?? const <InlineSpan>[]).map(_text).join();
  }
  return '';
}

/// Collects leaf text spans with their effective (merged) style.
List<(String, TextStyle?)> _leaves(InlineSpan span, TextStyle? inherited) {
  if (span is TextSpan) {
    final merged = span.style == null
        ? inherited
        : (inherited?.merge(span.style) ?? span.style);
    final out = <(String, TextStyle?)>[];
    if (span.text != null && span.text!.isNotEmpty) {
      out.add((span.text!, merged));
    }
    for (final c in span.children ?? const <InlineSpan>[]) {
      out.addAll(_leaves(c, merged));
    }
    return out;
  }
  return const [];
}

/// Flattens every leaf across a list of top-level spans.
List<(String, TextStyle?)> _leavesAll(List<InlineSpan> spans) {
  final out = <(String, TextStyle?)>[];
  for (final s in spans) {
    out.addAll(_leaves(s, null));
  }
  return out;
}

void main() {
  const base = TextStyle(fontSize: 14);

  test('**bold** renders bold', () {
    final spans = markdownSpans('a **b** c', base);
    expect(_fullText(spans), 'a b c');
    final leaves = _leavesAll(spans);
    expect(leaves.firstWhere((l) => l.$1 == 'b').$2?.fontWeight,
        FontWeight.bold);
  });

  test('*动作* renders italic', () {
    final spans = markdownSpans('*动作*', base);
    final leaves = _leaves(spans.first, null);
    expect(leaves.firstWhere((l) => l.$1 == '动作').$2?.fontStyle,
        FontStyle.italic);
  });

  test('`code` renders monospace', () {
    final spans = markdownSpans('`x`', base);
    final leaves = _leaves(spans.first, null);
    expect(leaves.firstWhere((l) => l.$1 == 'x').$2?.fontFamily, 'monospace');
  });

  test('list renders bullet markers', () {
    final text = _fullText(markdownSpans('- a\n- b', base));
    expect(text, contains('• a'));
    expect(text, contains('• b'));
  });

  test('fenced code block becomes a boxed WidgetSpan', () {
    final spans = markdownSpans('```\nprint(1)\n```', base);
    expect(spans.whereType<WidgetSpan>(), hasLength(1));
  });

  test('unclosed ** does not throw', () {
    final spans = markdownSpans('**unclosed', base);
    expect(_fullText(spans), isNotEmpty);
  });

  test('```markdown fence is unwrapped to markdown', () {
    final text = _fullText(markdownSpans('```markdown\n- a\n- b\n```', base));
    expect(text, contains('• a'));
    expect(text, contains('• b'));
    expect(text, isNot(contains('```')));
  });

  test('```json fence stays as code (not unwrapped)', () {
    final spans = markdownSpans('```json\n{"a":1}\n```', base);
    // stays a boxed code block, not unwrapped into markdown spans
    expect(spans.whereType<WidgetSpan>(), hasLength(1));
    expect(spans.whereType<TextSpan>(), isEmpty);
  });
}
