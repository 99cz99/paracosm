import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/db/database.dart';
import '../../../contacts/presentation/widgets/character_avatar.dart';

/// Group avatar: a custom image when [avatarPath] points to an existing file,
/// otherwise a 3×3 grid of the first up-to-9 members' avatars, falling back to
/// a group icon when there are no members.
class GroupAvatar extends StatelessWidget {
  const GroupAvatar({
    super.key,
    required this.members,
    this.avatarPath,
    this.size = 48,
  });

  final List<GroupMemberWithCharacter> members;
  final String? avatarPath;
  final double size;

  @override
  Widget build(BuildContext context) {
    final hasPath = avatarPath != null && avatarPath!.isNotEmpty;
    if (hasPath) {
      final pixel = (size * MediaQuery.of(context).devicePixelRatio).round();
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          File(avatarPath!),
          width: size,
          height: size,
          fit: BoxFit.cover,
          cacheWidth: pixel,
          cacheHeight: pixel,
          // File missing → fall back to the member grid (async, no sync I/O).
          errorBuilder: (ctx, _, _) => _memberGrid(ctx),
        ),
      );
    }
    return _memberGrid(context);
  }

  Widget _memberGrid(BuildContext context) {
    final shown = members.take(9).toList();
    if (shown.isEmpty) return Icon(Icons.group, size: size);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(size * 0.05),
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        children: [
          for (final m in shown)
            CharacterAvatar(
              name: m.character.name,
              avatarPath: m.character.avatarPath,
              radius: size / 3 / 2 - 2,
            ),
        ],
      ),
    );
  }
}
