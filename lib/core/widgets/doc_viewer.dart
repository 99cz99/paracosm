import 'package:flutter/material.dart';

/// A plain-text document section: a title plus paragraphs (rendered as-is).
class DocSection {
  const DocSection(this.title, this.paragraphs);

  final String title;
  final List<String> paragraphs;
}

/// A plain-text document (spec / manual) rendered by [DocViewer].
class Doc {
  const Doc(this.title, this.sections);

  final String title;
  final List<DocSection> sections;
}

/// Renders a [Doc] as a scrollable list of titled sections. No markdown — the
/// content is authored as structured text so it stays dependency-free.
class DocViewer extends StatelessWidget {
  const DocViewer({super.key, required this.doc});

  final Doc doc;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text(doc.title)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          for (final s in doc.sections) ...[
            Text(s.title, style: textTheme.titleMedium),
            const SizedBox(height: 6),
            for (final p in s.paragraphs)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(p, style: textTheme.bodyMedium),
              ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}
