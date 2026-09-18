import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/db/database.dart';
import '../../../core/providers/db_providers.dart';
import '../../../core/utils/dialogs.dart';
import '../../../core/utils/pinyin.dart';
import 'contacts_providers.dart';
import 'widgets/character_avatar.dart';

class ContactsScreen extends ConsumerWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final charactersAsync = ref.watch(charactersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('联系人'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1),
            tooltip: '新建角色',
            onPressed: () => context.push('/contacts/create'),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: '导入角色',
            onPressed: () => context.push('/contacts/import'),
          ),
        ],
      ),
      body: charactersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('加载失败：$e')),
        data: (characters) {
          if (characters.isEmpty) return const _EmptyContacts();
          return _ContactList(characters: characters);
        },
      ),
    );
  }
}

class _ContactList extends ConsumerStatefulWidget {
  const _ContactList({required this.characters});

  final List<Character> characters;

  @override
  ConsumerState<_ContactList> createState() => _ContactListState();
}

class _ContactListState extends ConsumerState<_ContactList> {
  static const _letters = [
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
    'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '#',
  ];

  // Fixed row heights so A-Z jumps can compute an offset without laying out
  // off-screen rows (lazy list).
  static const _headerHeight = 40.0;
  static const _itemHeight = 72.0;

  final _scrollController = ScrollController();
  final GlobalKey _sidebarKey = GlobalKey();

  /// Flattened rows: header (label set) or contact (character set).
  List<({String? label, Character? character})> _flat = [];
  final Map<String, int> _headerIndex = {};

  List<({String label, List<Character> items})> _group() {
    final pinned = widget.characters
        .where((c) => c.pinnedAt != null)
        .toList()
      ..sort((a, b) => (b.pinnedAt ?? 0).compareTo(a.pinnedAt ?? 0));

    final rest = widget.characters.where((c) => c.pinnedAt == null).toList();
    final map = <String, List<Character>>{};
    for (final c in rest) {
      map.putIfAbsent(pinyinInitial(c.name), () => []).add(c);
    }
    final letters = map.keys.toList()..sort((a, b) {
      if (a == '#') return 1;
      if (b == '#') return -1;
      return a.compareTo(b);
    });

    final sections = <({String label, List<Character> items})>[];
    if (pinned.isNotEmpty) sections.add((label: '置顶', items: pinned));
    for (final letter in letters) {
      final items = map[letter]!..sort((a, b) => a.name.compareTo(b.name));
      sections.add((label: letter, items: items));
    }
    return sections;
  }

  void _buildFlat(List<({String label, List<Character> items})> sections) {
    _flat = [];
    _headerIndex.clear();
    for (final section in sections) {
      _headerIndex[section.label] = _flat.length;
      _flat.add((label: section.label, character: null));
      for (final c in section.items) {
        _flat.add((label: null, character: c));
      }
    }
  }

  void _jumpTo(String label) {
    final idx = _headerIndex[label];
    if (idx == null || !_scrollController.hasClients) return;
    var offset = 0.0;
    for (var i = 0; i < idx; i++) {
      offset += _flat[i].character == null ? _headerHeight : _itemHeight;
    }
    _scrollController.animateTo(
      offset.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onSidebarDrag(DragUpdateDetails details) {
    final box = _sidebarKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    final local = box.globalToLocal(details.globalPosition);
    const itemHeight = 18.0;
    final idx = (local.dy / itemHeight).floor().clamp(0, _letters.length - 1);
    _jumpTo(_letters[idx]);
  }

  Future<void> _showMenu(Character c) async {
    final pinned = c.pinnedAt != null;
    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(pinned ? Icons.push_pin_outlined : Icons.push_pin),
              title: Text(pinned ? '取消置顶' : '置顶'),
              onTap: () => Navigator.of(sheetContext).pop('pin'),
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('删除'),
              onTap: () => Navigator.of(sheetContext).pop('delete'),
            ),
          ],
        ),
      ),
    );
    if (!mounted) return;
    if (action == 'pin') {
      await ref.read(dbProvider).setCharacterPinned(c.id, !pinned);
    } else if (action == 'delete') {
      await _confirmDelete(c);
    }
  }

  Future<void> _confirmDelete(Character c) async {
    final ok = await showConfirmDialog(
      context,
      title: '删除角色',
      message: '确定删除「${c.name}」？其所有会话也会被删除。',
    );
    if (!ok) return;
    await ref.read(dbProvider).deleteCharacter(c.id);
    if (mounted) await showSuccessDialog(context, '已删除');
  }

  String _tags(Character c) {
    try {
      final tags = jsonDecode(c.tags) as List<dynamic>;
      return tags.isEmpty ? '无标签' : tags.join(' · ');
    } catch (_) {
      return '无标签';
    }
  }

  @override
  Widget build(BuildContext context) {
    final sections = _group();
    _buildFlat(sections);
    final scheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        ListView.builder(
          controller: _scrollController,
          itemCount: _flat.length,
          itemBuilder: (context, index) {
            final row = _flat[index];
            if (row.character == null) return _header(row.label!);
            final c = row.character!;
            return SizedBox(
              height: _itemHeight,
              child: ListTile(
                leading: CharacterAvatar(
                  name: c.name,
                  avatarPath: c.avatarPath,
                ),
                title: Text(c.name),
                subtitle: Text(
                  _tags(c),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: c.pinnedAt != null
                    ? Icon(Icons.push_pin, size: 18, color: scheme.primary)
                    : null,
                onTap: () => context.push('/contacts/${c.id}'),
                onLongPress: () => _showMenu(c),
              ),
            );
          },
        ),
        Positioned(
          right: 2,
          top: 0,
          bottom: 0,
          child: Center(
            child: GestureDetector(
              key: _sidebarKey,
              behavior: HitTestBehavior.opaque,
              onVerticalDragUpdate: _onSidebarDrag,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final l in _letters)
                    GestureDetector(
                      onTap: () => _jumpTo(l),
                      child: SizedBox(
                        height: 18,
                        width: 22,
                        child: Center(
                          child: Text(
                            l,
                            style: TextStyle(
                              fontSize: 11,
                              color: scheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _header(String label) {
    return SizedBox(
      height: _headerHeight,
      child: Container(
        width: double.infinity,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        child: Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
      ),
    );
  }
}

class _EmptyContacts extends StatelessWidget {
  const _EmptyContacts();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.person_add_alt_1, size: 64, color: Colors.grey),
          const SizedBox(height: 12),
          const Text('还没有角色'),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: () => context.push('/contacts/create'),
            child: const Text('新建角色'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => context.push('/contacts/import'),
            child: const Text('导入角色卡'),
          ),
        ],
      ),
    );
  }
}
