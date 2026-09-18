import 'package:flutter/material.dart';

/// A titled text block that collapses long content behind an 展开/收起 toggle.
class ExpandableSection extends StatefulWidget {
  const ExpandableSection({
    super.key,
    required this.title,
    required this.text,
    this.threshold = 120,
  });

  final String title;
  final String text;

  /// Chars above which the content starts collapsed.
  final int threshold;

  @override
  State<ExpandableSection> createState() => _ExpandableSectionState();
}

class _ExpandableSectionState extends State<ExpandableSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLong = widget.text.length > widget.threshold;
    final collapsed = isLong && !_expanded;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title.isNotEmpty) ...[
            Text(widget.title, style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
          ],
          Text(
            widget.text,
            maxLines: collapsed ? 4 : null,
            overflow: collapsed ? TextOverflow.ellipsis : null,
          ),
          if (isLong)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => setState(() => _expanded = !_expanded),
                child: Text(_expanded ? '收起' : '展开'),
              ),
            ),
        ],
      ),
    );
  }
}
