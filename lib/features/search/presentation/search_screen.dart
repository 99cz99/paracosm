import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/db/database.dart';
import '../../../core/providers/db_providers.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  String _query = '';
  List<Character> _characters = [];
  List<({Message message, String characterName})> _messages = [];
  bool _loading = false;

  Future<void> _search(String q) async {
    setState(() => _query = q);
    if (q.trim().isEmpty) {
      setState(() {
        _characters = [];
        _messages = [];
      });
      return;
    }
    setState(() => _loading = true);
    final db = ref.read(dbProvider);
    final characters = await db.searchCharacters(q.trim());
    final messages = await db.searchMessagesWithCharacter(q.trim());
    if (!mounted) return;
    setState(() {
      _characters = characters;
      _messages = messages;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('搜索')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              autofocus: true,
              decoration: const InputDecoration(
                hintText: '搜索角色 / 消息…',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _search,
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    children: [
                      if (_characters.isNotEmpty) ...[
                        const _Header('角色'),
                        for (final c in _characters)
                          ListTile(
                            leading: const Icon(Icons.person),
                            title: Text(c.name),
                            onTap: () => context.go('/contacts/${c.id}'),
                          ),
                      ],
                      if (_messages.isNotEmpty) ...[
                        const _Header('消息'),
                        for (final m in _messages)
                          ListTile(
                            leading: const Icon(Icons.chat_bubble_outline),
                            title: Text(
                              m.message.content,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(m.characterName),
                            onTap: () =>
                                context.go('/chat/${m.message.sessionId}'),
                          ),
                      ],
                      if (_query.isNotEmpty &&
                          _characters.isEmpty &&
                          _messages.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(24),
                          child: Text('无结果'),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleSmall
            ?.copyWith(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}
