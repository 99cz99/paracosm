import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Decodes avatar bytes and re-encodes them as a square [size]×[size] PNG,
/// stripping embedded metadata (a character card used as an avatar stashes a
/// multi-MB base64 JSON in a `tEXt` chunk).
///
/// `crop_your_image` outputs the crop at the source's full resolution, so
/// storing it as-is wastes disk and makes every cold-start read heavier. This
/// downscales at save time; callers then only ever load a small file.
Uint8List resizeAvatarPng(List<int> bytes, {int size = 256}) {
  final decoded = img.decodeImage(Uint8List.fromList(bytes));
  if (decoded == null) return Uint8List.fromList(bytes);
  final resized = img.copyResize(decoded, width: size, height: size);
  // Drop tEXt (character-card JSON) so the file stays small; `copyResize`
  // otherwise carries the source's textData over to the output.
  resized.textData = null;
  return img.encodePng(resized);
}

/// One-off cleanup: re-encodes oversized avatars in the documents dir. Two
/// cases produce large files that should be shrunk:
///  - a character-card PNG used as an avatar (multi-MB `tEXt` chunk), and
///  - full-resolution crops written by older builds.
Future<void> migrateLargeAvatars() async {
  final dir = await getApplicationDocumentsDirectory();
  final avatarDir = Directory(p.join(dir.path, 'avatars'));
  if (!await avatarDir.exists()) return;
  await for (final entity in avatarDir.list()) {
    if (entity is! File || !entity.path.endsWith('.png')) continue;
    try {
      if (await entity.length() <= 256 * 1024) continue;
      await entity.writeAsBytes(resizeAvatarPng(await entity.readAsBytes()));
    } catch (_) {
      // Best-effort: a locked/unreadable file shouldn't crash startup.
    }
  }
}
