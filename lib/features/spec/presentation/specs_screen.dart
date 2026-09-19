import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/spec_docs.dart';

class SpecsScreen extends StatelessWidget {
  const SpecsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('制作规范')),
      body: ListView(
        children: [
          for (final e in specEntries)
            ListTile(
              leading: const Icon(Icons.article_outlined),
              title: Text(e.title),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/profile/specs/${e.key}'),
            ),
        ],
      ),
    );
  }
}
