// Sanitizes regex-script HTML into a shape the renderer can handle.
//
// `flutter_widget_from_html_core`'s `HtmlWidget` only honours inline
// `style=""` — it does not process `<style>` blocks, class CSS or gradients.
// This function therefore inlines `<style>` class rules onto the matching
// `class="…"` elements (as inline styles, with gradients degraded to a solid
// colour and overflow-causing properties neutralised), then flattens the
// remaining constructs that break the 320px bubble.

/// Inlines the `<style>` class rules into matching `class="…"` elements.
String sanitizeHtml(String html) {
  var s = html;

  // 0. Read `<style>` rules, inline them onto class elements, then drop the
  //    `<style>`/`<script>` blocks (class CSS isn't understood by HtmlWidget).
  final classCss = _parseStyleClasses(s);
  s = _inlineClassCss(s, classCss);
  s = s.replaceAll(
      RegExp(r'<style[^>]*>[\s\S]*?</style>', caseSensitive: false), '');
  s = s.replaceAll(
      RegExp(r'<script[^>]*>[\s\S]*?</script>', caseSensitive: false), '');

  // 2. <details>/<summary> is left intact — HtmlWidget renders it natively as
  //    a collapsible panel (summary always visible, body hidden until tapped).

  // 3. Drop the ">body" blockquote artifact (a stray <body> tag after ">").
  s = s.replaceAll(RegExp(r'><body>', caseSensitive: false), '');
  s = s.replaceAll(RegExp(r'</body>', caseSensitive: false), '');

  // 4. Markdown bold → <b> (keeps the emphasis, doesn't touch literal "**").
  s = s.replaceAllMapped(
      RegExp(r'\*\*([^*]+)\*\*'), (m) => '<b>${m.group(1)}</b>');

  // 5. Strip remaining Markdown blockquote markers (line-start ">").
  s = s.replaceAll(RegExp(r'(^|\n)\s*>\s*', multiLine: true), '\n');

  // 6. Neutralize fixed dimensions + flex that overflow the 320px bubble.
  //    display:flex rows don't wrap; fixed height / max-width / gap overflow,
  //    and the RenderFlex overflow makes the panel collapse in reverse:true.
  s = s.replaceAll(
      RegExp(r'display\s*:\s*flex', caseSensitive: false), 'display:block');
  s = s.replaceAll(
      RegExp(r'position\s*:\s*(absolute|fixed)', caseSensitive: false),
      'position:static');
  s = s.replaceAll(
      RegExp(r'(max-width|min-width|height|max-height|min-height|gap)\s*:\s*[^;"]+;?',
          caseSensitive: false),
      '');
  return s;
}

/// Parses every `<style>` block into `className → { prop → value }`.
Map<String, Map<String, String>> _parseStyleClasses(String html) {
  final out = <String, Map<String, String>>{};
  final styleRe = RegExp(r'<style[^>]*>([\s\S]*?)</style>', caseSensitive: false);
  final ruleRe = RegExp(r'\.([a-zA-Z][\w-]*)\s*\{([^{}]*)\}');
  for (final m in styleRe.allMatches(html)) {
    final css = m.group(1) ?? '';
    for (final r in ruleRe.allMatches(css)) {
      final name = r.group(1)!;
      final props = _parseDeclarations(r.group(2) ?? '');
      if (props.isEmpty) continue;
      (out[name] ??= <String, String>{}).addAll(props);
    }
  }
  return out;
}

/// Inlines the class CSS onto each `class="…"` element as an inline `style`.
/// The element's own inline `style` (if any) wins over class CSS.
String _inlineClassCss(
    String html, Map<String, Map<String, String>> classCss) {
  if (classCss.isEmpty) return html;
  final tagRe = RegExp(r'<(\w+)([^>]*?)\sclass="([^"]+)"([^>]*)>');
  final styleRe = RegExp(r'style="([^"]*)"', caseSensitive: false);
  return html.replaceAllMapped(tagRe, (m) {
    final tag = m.group(1)!;
    final before = m.group(2) ?? '';
    final classVal = m.group(3) ?? '';
    final after = m.group(4) ?? '';

    final classes =
        classVal.split(RegExp(r'\s+')).where((c) => c.isNotEmpty).toList();
    final classProps = <String, String>{};
    for (final c in classes) {
      final css = classCss[c];
      if (css != null) classProps.addAll(_safeProps(css));
    }
    if (classProps.isEmpty) return m.group(0)!;

    // Existing inline style (before or after `class`) takes precedence.
    final existing = <String, String>{};
    for (final sm in [styleRe.firstMatch(before), styleRe.firstMatch(after)]) {
      if (sm != null) existing.addAll(_parseDeclarations(sm.group(1) ?? ''));
    }
    classProps.addAll(existing);

    final b = before.replaceAll(styleRe, '');
    final a = after.replaceAll(styleRe, '');
    return '<$tag$b class="$classVal"$a style="${_propsToInline(classProps)}">';
  });
}

/// Properties HtmlWidget's inline-style parser understands; everything else
/// (width/height/gap/box-shadow/font-family/calc …) is dropped to avoid the
/// fixed-dimension overflow that collapses panels in the 320px bubble.
const Set<String> _safeCssProps = {
  'border', 'border-top', 'border-bottom', 'border-left', 'border-right',
  'border-radius',
  'color', 'background-color',
  'font-size', 'font-weight', 'font-style', 'line-height',
  'text-align', 'text-decoration', 'white-space',
  'padding', 'padding-top', 'padding-bottom', 'padding-left', 'padding-right',
  'margin', 'margin-top', 'margin-bottom', 'margin-left', 'margin-right',
};

/// Converts class CSS into the safe inline subset (gradient → solid colour,
/// `display:flex` → `block`, `position` → `static`).
Map<String, String> _safeProps(Map<String, String> raw) {
  final out = <String, String>{};
  raw.forEach((prop, value) {
    final v = value.trim();
    if (v.isEmpty) return;
    switch (prop) {
      case 'display':
        out['display'] = v.toLowerCase().contains('flex') ? 'block' : v;
      case 'position':
        out['position'] = 'static';
      case 'background':
        final hex = _lastHex(v);
        if (hex != null) {
          out['background-color'] = hex;
        } else if (v.startsWith('#') || v.toLowerCase().startsWith('rgb')) {
          out['background-color'] = v;
        }
      default:
        if (_safeCssProps.contains(prop)) out[prop] = v;
    }
  });
  return out;
}

/// Last `#hex` in a value — the solid-colour fallback for gradients.
String? _lastHex(String value) {
  final matches = RegExp(r'#([0-9a-fA-F]{3,8})').allMatches(value).toList();
  return matches.isEmpty ? null : matches.last.group(0);
}

Map<String, String> _parseDeclarations(String css) {
  final out = <String, String>{};
  for (final decl in css.split(';')) {
    final idx = decl.indexOf(':');
    if (idx <= 0) continue;
    final prop = decl.substring(0, idx).trim().toLowerCase();
    final value = decl.substring(idx + 1).trim();
    if (prop.isNotEmpty && value.isNotEmpty) out[prop] = value;
  }
  return out;
}

String _propsToInline(Map<String, String> props) =>
    props.entries.map((e) => '${e.key}: ${e.value}').join('; ');
