import 'package:flutter/material.dart';

/// One selectable option in a [showMultiSelectSheet].
class MultiSelectOption {
  const MultiSelectOption(this.id, this.name, {this.subtitle});

  final String id;
  final String name;
  final String? subtitle;
}

/// Shows a checkbox multi-select bottom sheet. Returns the selected ids, or
/// null when dismissed. Uses the branch navigator (default `useRootNavigator:
/// false` for `showModalBottomSheet`), so it plays nice with `StatefulShellRoute`.
Future<List<String>?> showMultiSelectSheet(
  BuildContext context, {
  required String title,
  required List<MultiSelectOption> options,
  Set<String> initial = const {},
}) {
  return showModalBottomSheet<List<String>>(
    context: context,
    builder: (_) => _MultiSelectSheet(
      title: title,
      options: options,
      initial: initial,
    ),
  );
}

class _MultiSelectSheet extends StatefulWidget {
  const _MultiSelectSheet({
    required this.title,
    required this.options,
    required this.initial,
  });

  final String title;
  final List<MultiSelectOption> options;
  final Set<String> initial;

  @override
  State<_MultiSelectSheet> createState() => _MultiSelectSheetState();
}

class _MultiSelectSheetState extends State<_MultiSelectSheet> {
  late final Set<String> _selected = {...widget.initial};

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(widget.title,
                style: Theme.of(context).textTheme.titleMedium),
          ),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final o in widget.options)
                  CheckboxListTile(
                    value: _selected.contains(o.id),
                    onChanged: (v) => setState(() {
                      if (v == true) {
                        _selected.add(o.id);
                      } else {
                        _selected.remove(o.id);
                      }
                    }),
                    title: Text(o.name),
                    subtitle: o.subtitle == null ? null : Text(o.subtitle!),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton(
              onPressed: () => Navigator.of(context).pop(_selected.toList()),
              child: const Text('确定'),
            ),
          ),
        ],
      ),
    );
  }
}
