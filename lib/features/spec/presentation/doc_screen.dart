import 'package:flutter/material.dart';

import '../../../core/widgets/doc_viewer.dart';
import '../data/spec_docs.dart';

/// Shows one document (a spec or the manual) resolved by [docKey].
class DocScreen extends StatelessWidget {
  const DocScreen({super.key, required this.docKey});

  final String docKey;

  @override
  Widget build(BuildContext context) {
    final doc = docForKey(docKey);
    if (doc == null) {
      return const Scaffold(body: Center(child: Text('未找到文档')));
    }
    return DocViewer(doc: doc);
  }
}
