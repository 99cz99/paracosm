import 'dart:io';

import 'package:flutter/material.dart';

/// A character avatar: a custom image when [avatarPath] points to an existing
/// file, otherwise a deterministic colored circle with the name's first char.
class CharacterAvatar extends StatelessWidget {
  const CharacterAvatar({
    super.key,
    required this.name,
    this.avatarPath,
    this.radius = 20,
  });

  final String name;
  final String? avatarPath;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final hasPath = avatarPath != null && avatarPath!.isNotEmpty;
    // Decode at display size (thumbnail) instead of the full-size source —
    // cropping keeps the original resolution, so decoding 40px avatars from a
    // 2000px image would otherwise jank the list when many load at once.
    final pixel =
        (radius * 2 * MediaQuery.of(context).devicePixelRatio).round();
    return SizedBox(
      width: radius * 2,
      height: radius * 2,
      child: ClipOval(
        child: hasPath
            ? Image.file(
                File(avatarPath!),
                fit: BoxFit.cover,
                cacheWidth: pixel,
                cacheHeight: pixel,
                // File missing → fall back to the initial (async, no sync I/O).
                errorBuilder: (_, _, _) => _initial(),
              )
            : _initial(),
      ),
    );
  }

  Widget _initial() => Container(
        color: _colorFor(name),
        alignment: Alignment.center,
        child: Text(
          name.isEmpty ? '?' : name.characters.first,
          style: TextStyle(color: Colors.white, fontSize: radius * 0.9),
        ),
      );

  Color _colorFor(String name) {
    const palette = [
      Color(0xFF7C6FDE),
      Color(0xFF4A90D9),
      Color(0xFF50B7A0),
      Color(0xFFE08A3C),
      Color(0xFFD9534F),
      Color(0xFF8E6FD8),
    ];
    final hash = name.isEmpty
        ? 0
        : name.codeUnits.fold<int>(0, (acc, c) => acc + c);
    return palette[hash % palette.length];
  }
}
