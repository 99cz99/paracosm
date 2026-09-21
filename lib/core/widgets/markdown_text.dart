import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;

/// Renders a markdown string as a list of rich [InlineSpan]s.
///
/// Keeps `SelectableText` (selection/copy + `contextMenuBuilder`) working,
/// unlike `flutter_markdown`'s `MarkdownBody`. Parsing is best-effort: unclosed
/// `*`/`**` (e.g. mid-stream) stay as literal text and never throw.
List<InlineSpan> markdownSpans(String source, TextStyle base,
    {Color? codeBackground}) {
  final nodes = md.Document(
    extensionSet: md.ExtensionSet.gitHubFlavored,
    encodeHtml: false,
  ).parse(source);
  // Models often wrap their whole answer in a ```markdown fence; unwrap it so
  // the inner markdown actually renders instead of showing as a literal block.
  final inner = _unwrapSingleMarkdownFence(nodes);
  if (inner != null) {
    return markdownSpans(inner, base, codeBackground: codeBackground);
  }
  return _blockChildren(nodes, base, codeBackground);
}

/// A [SelectableText] that renders markdown via [markdownSpans].
class MarkdownSelectableText extends StatelessWidget {
  const MarkdownSelectableText(
    this.data, {
    super.key,
    this.style,
    this.textAlign,
    this.contextMenuBuilder,
  });

  final String data;
  final TextStyle? style;
  final TextAlign? textAlign;
  final EditableTextContextMenuBuilder? contextMenuBuilder;

  @override
  Widget build(BuildContext context) {
    final base = style ?? DefaultTextStyle.of(context).style;
    final codeBackground =
        Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08);
    return SelectableText.rich(
      TextSpan(
        style: base,
        children: markdownSpans(data, base, codeBackground: codeBackground),
      ),
      textAlign: textAlign,
      contextMenuBuilder: contextMenuBuilder,
    );
  }
}

// --- internal ------------------------------------------------------------

const Color _linkColor = Color(0xFF4A9DFF);

TextStyle _codeStyle(TextStyle base) => base.copyWith(
      fontFamily: 'monospace',
      backgroundColor: const Color(0x14000000),
    );

/// A fenced code block rendered as a boxed, monospace container (selectable,
/// so the code can be copied). [background] is theme-derived.
WidgetSpan _codeBlock(String code, TextStyle base, Color? background) {
  return WidgetSpan(
    alignment: PlaceholderAlignment.top,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: background ?? const Color(0x14000000),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SelectableText(
        code.trimRight(),
        style: base.copyWith(fontFamily: 'monospace'),
      ),
    ),
  );
}

/// `Element.children` is nullable in the markdown package; normalize to empty.
List<md.Node> _children(md.Element el) => el.children ?? const <md.Node>[];

/// Returns the inner text when [nodes] is exactly one fenced code block whose
/// language is `markdown`/`md` (so it can be re-rendered as markdown). Other
/// languages (`json`, `text`, bare fences) stay as literal code blocks.
String? _unwrapSingleMarkdownFence(List<md.Node> nodes) {
  if (nodes.length != 1) return null;
  final node = nodes.first;
  if (node is! md.Element || node.tag != 'pre') return null;
  md.Element? code;
  for (final c in _children(node)) {
    if (c is md.Element && c.tag == 'code') {
      code = c;
      break;
    }
  }
  if (code == null) return null;
  final cls = code.attributes['class'] ?? '';
  if (cls != 'language-markdown' && cls != 'language-md') return null;
  return _textOf(code);
}

List<InlineSpan> _blockChildren(
    List<md.Node> children, TextStyle base, Color? codeBackground) {
  final out = <InlineSpan>[];
  for (final child in children) {
    final spans = _blockSpans(child, base, codeBackground);
    if (spans.isEmpty) continue;
    if (out.isNotEmpty) out.add(TextSpan(text: '\n', style: base));
    out.addAll(spans);
  }
  return out;
}

List<InlineSpan> _blockSpans(
    md.Node node, TextStyle base, Color? codeBackground) {
  if (node is md.Text) return [TextSpan(text: node.text, style: base)];
  final el = node as md.Element;
  switch (el.tag) {
    case 'p':
      return _inlineSpans(_children(el), base);
    case 'h1':
    case 'h2':
    case 'h3':
    case 'h4':
    case 'h5':
    case 'h6':
      final level = int.parse(el.tag.substring(1));
      final scale = const [1.35, 1.25, 1.18, 1.12, 1.06, 1.0][level - 1];
      final h = base.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: base.fontSize == null ? null : base.fontSize! * scale,
      );
      return _inlineSpans(_children(el), h);
    case 'ul':
      return _listSpans(el, base, ordered: false);
    case 'ol':
      return _listSpans(el, base, ordered: true);
    case 'blockquote':
      return _blockChildren(_children(el),
          base.copyWith(fontStyle: FontStyle.italic), codeBackground);
    case 'pre':
      return [_codeBlock(_textOf(el), base, codeBackground)];
    case 'hr':
      return [TextSpan(text: '───', style: base)];
    default:
      // Tables and unknown elements: flatten to text so nothing is dropped.
      return _blockChildren(_children(el), base, codeBackground);
  }
}

List<InlineSpan> _inlineSpans(List<md.Node> nodes, TextStyle style) {
  final out = <InlineSpan>[];
  for (final node in nodes) {
    if (node is md.Text) {
      out.add(TextSpan(text: node.text, style: style));
      continue;
    }
    final el = node as md.Element;
    switch (el.tag) {
      case 'strong':
        out.addAll(_inlineSpans(
            _children(el), style.copyWith(fontWeight: FontWeight.bold)));
        break;
      case 'em':
        out.addAll(_inlineSpans(
            _children(el), style.copyWith(fontStyle: FontStyle.italic)));
        break;
      case 'del':
        out.addAll(_inlineSpans(_children(el),
            style.copyWith(decoration: TextDecoration.lineThrough)));
        break;
      case 'code':
        out.add(TextSpan(text: _textOf(el), style: _codeStyle(style)));
        break;
      case 'a':
        out.addAll(_inlineSpans(
          _children(el),
          style.copyWith(
              color: _linkColor, decoration: TextDecoration.underline),
        ));
        break;
      case 'br':
        out.add(TextSpan(text: '\n', style: style));
        break;
      case 'img':
        out.add(TextSpan(text: el.attributes['alt'] ?? '', style: style));
        break;
      default:
        out.addAll(_inlineSpans(_children(el), style));
    }
  }
  return out;
}

List<InlineSpan> _listSpans(md.Element list, TextStyle base,
    {required bool ordered}) {
  final items = _children(list)
      .where((c) => c is md.Element && c.tag == 'li')
      .toList();
  final out = <InlineSpan>[];
  var index = 0;
  for (var i = 0; i < items.length; i++) {
    final li = items[i] as md.Element;
    index++;
    final marker = ordered ? '$index. ' : '• ';
    out.add(TextSpan(
        text: marker, style: base.copyWith(fontWeight: FontWeight.w600)));
    out.addAll(_listItemSpans(li, base));
    if (i < items.length - 1) out.add(TextSpan(text: '\n', style: base));
  }
  return out;
}

List<InlineSpan> _listItemSpans(md.Element li, TextStyle base) {
  final out = <InlineSpan>[];
  for (final child in _children(li)) {
    if (child is md.Text) {
      out.add(TextSpan(text: child.text, style: base));
    } else if (child is md.Element) {
      if (child.tag == 'p') {
        out.addAll(_inlineSpans(_children(child), base));
      } else if (child.tag == 'ul' || child.tag == 'ol') {
        out.add(TextSpan(text: '\n', style: base));
        out.addAll(_listSpans(child, base, ordered: child.tag == 'ol'));
      } else {
        out.addAll(_inlineSpans([child], base));
      }
    }
  }
  return out;
}

String _textOf(md.Node node) {
  if (node is md.Text) return node.text;
  if (node is md.Element) return _children(node).map(_textOf).join();
  return '';
}
