import 'package:flutter/material.dart';

/// Parses a `#RRGGBB` / `#AARRGGBB` hex string into a [Color]; null when
/// invalid (so illegal input is silently ignored).
Color? parseHexColor(String? s) {
  if (s == null) return null;
  var v = s.trim();
  if (v.isEmpty) return null;
  if (!v.startsWith('#')) v = '#$v';
  final parsed = int.tryParse(v.substring(1), radix: 16);
  if (parsed == null) return null;
  if (v.length == 7) return Color(0xFF000000 | parsed); // #RRGGBB → opaque
  if (v.length == 9) return Color(parsed); // #AARRGGBB
  return null;
}

const List<String> _presetColors = <String>[
  '#FF6B9D', '#F44336', '#FF9800', '#FFC107',
  '#8BC34A', '#4CAF50', '#00BCD4', '#2196F3',
  '#7C6FDE', '#9C27B0', '#795548', '#607D8B',
  '#FFFFFF', '#000000',
];

/// A compact color-setting row: a swatch + label; tapping opens [showColorPicker].
class ColorRow extends StatelessWidget {
  const ColorRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;

  /// Current hex string; null = default.
  final String? value;

  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final color = parseHexColor(value);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: color ?? Theme.of(context).colorScheme.surfaceContainerHighest,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black26),
        ),
      ),
      title: Text(label),
      trailing: Text(value ?? '默认', style: Theme.of(context).textTheme.bodySmall),
      onTap: () async {
        final picked =
            await showColorPicker(context, current: value, title: label);
        if (picked == null) return; // cancelled
        onChanged(picked.isEmpty ? null : picked);
      },
    );
  }
}

/// A bottom sheet with preset swatches + a `#RRGGBB` hex input.
///
/// Returns null when cancelled, `''` for "default" (clear), or the chosen hex.
Future<String?> showColorPicker(
  BuildContext context, {
  required String? current,
  required String title,
}) async {
  String? selected = current;
  final hex = TextEditingController(text: current ?? '');
  final result = await showModalBottomSheet<String?>(
    context: context,
    builder: (sheetContext) => StatefulBuilder(
      builder: (context, setState) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final c in _presetColors)
                    _swatch(c, selected: selected == c, onTap: () {
                      setState(() => selected = c);
                      hex.text = c;
                    }),
                  _swatch(null, selected: selected == null, onTap: () {
                    setState(() => selected = null);
                    hex.text = '';
                  }),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: hex,
                decoration: const InputDecoration(
                  isDense: true,
                  hintText: '如 #FF6B9D',
                  border: OutlineInputBorder(),
                ),
                onChanged: (v) {
                  final t = v.trim();
                  if (t.isEmpty) {
                    setState(() => selected = null);
                    return;
                  }
                  if (parseHexColor(t) != null) {
                    setState(() => selected =
                        '#${t.replaceFirst('#', '').toUpperCase()}');
                  }
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(sheetContext).pop(null),
                    child: const Text('取消'),
                  ),
                  FilledButton(
                    onPressed: () =>
                        Navigator.of(sheetContext).pop(selected ?? ''),
                    child: const Text('确定'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
  hex.dispose();
  return result;
}

Widget _swatch(String? hex,
    {required bool selected, required VoidCallback onTap}) {
  final color = parseHexColor(hex);
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color ?? Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? Colors.black87 : Colors.black26,
          width: selected ? 3 : 1,
        ),
      ),
      child: hex == null
          ? Icon(Icons.refresh,
              size: 16, color: selected ? Colors.black87 : Colors.grey)
          : null,
    ),
  );
}
