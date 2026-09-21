import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../../core/db/database.dart';
import '../../../core/import/imported_character.dart';
import '../../../core/import/png_card_extractor.dart';
import '../../../core/import/skill_importer.dart';
import '../../../core/import/st_card_parser.dart';
import '../../../core/utils/app_exception.dart';
import '../../../core/utils/avatar_image.dart';

/// Persists imported characters and their default adaptation.
class CharacterRepository {
  CharacterRepository(this._db);

  final AppDatabase _db;
  static final _uuid = const Uuid();

  /// Imports a character from raw file bytes. Dispatches on [filename]:
  /// PNG (tEXt chunk), JSON, ZIP (Skill), or Markdown frontmatter.
  Future<String> importFromBytes(
    List<int> bytes, {
    String? sourcePath,
    String? filename,
  }) async {
    final imported = _parseBytes(bytes, filename);
    return importCharacter(
      imported,
      sourcePath: sourcePath,
      sourceType: _sourceTypeFor(filename),
    );
  }

  String _sourceTypeFor(String? filename) {
    final name = (filename ?? '').toLowerCase();
    if (name.endsWith('.zip') || name.endsWith('.md')) return 'skill';
    return 'sillytavern';
  }

  ImportedCharacter _parseBytes(List<int> bytes, String? filename) {
    final name = (filename ?? '').toLowerCase();
    if (name.endsWith('.zip')) {
      return SkillImporter().importZip(bytes);
    }
    if (name.endsWith('.md')) {
      final imported = SkillImporter().importMarkdown(utf8.decode(bytes));
      if (imported != null) return imported;
      throw AppException('Markdown 中未找到角色前置元数据（name 等）');
    }
    final extracted = PngCardExtractor().extract(bytes);
    if (extracted != null) {
      // PNG card: the PNG itself is the portrait.
      return StCardParser().parse(extracted).withAvatar(bytes);
    }
    return StCardParser().parse(utf8.decode(bytes));
  }

  Future<String> importCharacter(
    ImportedCharacter imported, {
    String? sourcePath,
    String sourceType = 'sillytavern',
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;

    // Skill state (references/affinity.json) rides along in the persona JSON
    // under a reserved key, injected into the system prompt at chat time.
    final core = Map<String, dynamic>.from(imported.core);
    if (imported.affinity != null && imported.affinity!.isNotEmpty) {
      core['affinity'] = imported.affinity;
    }
    if (imported.stateSchema != null && imported.stateSchema!.isNotEmpty) {
      core['state_schema'] = imported.stateSchema;
    }
    if (imported.regexScripts.isNotEmpty) {
      core['regex_scripts'] = imported.regexScripts;
    }

    // Re-importing a same-named character overwrites it in place (keeping its
    // id so sessions/memory/avatar/pin survive) instead of duplicating it.
    final existing = await _db.getCharacterByName(imported.name);
    final id = existing?.id ?? _uuid.v4();

    // Save the portrait as the avatar (best-effort).
    String? avatarPath;
    if (imported.avatarBytes != null) {
      try {
        avatarPath = await saveAvatar(imported.avatarBytes!,
            oldPath: existing?.avatarPath);
      } catch (_) {}
    }

    // Save the gallery images and build the manifest (best-effort).
    final galleryJson = await _saveGallery(imported.gallery, characterId: id);

    if (existing != null) {
      await _db.updateCharacter(
        existing.id,
        CharactersCompanion(
          name: Value(imported.name),
          corePersonaJson: Value(jsonEncode(core)),
          worldbookJson: imported.worldbook != null
              ? Value(jsonEncode(imported.worldbook))
              : const Value.absent(),
          tags: Value(jsonEncode(imported.tags)),
          sourceType: Value(sourceType),
          sourcePath: Value(sourcePath),
          avatarPath: avatarPath != null
              ? Value(avatarPath)
              : const Value.absent(),
          imageGalleryJson: galleryJson.isNotEmpty
              ? Value(jsonEncode(galleryJson))
              : const Value.absent(),
          updatedAt: Value(now),
        ),
      );
      final adaptation = await _db.getAdaptation(existing.id, '');
      if (adaptation != null) {
        await _db.upsertAdaptation(CharacterAdaptationsCompanion.insert(
          id: adaptation.id,
          characterId: existing.id,
          adaptationJson: jsonEncode(imported.adaptation),
          createdAt: adaptation.createdAt,
          updatedAt: now,
        ));
      }
      return existing.id;
    }

    await _db.insertCharacter(CharactersCompanion.insert(
      id: id,
      name: imported.name,
      corePersonaJson: jsonEncode(core),
      worldbookJson: imported.worldbook != null
          ? Value(jsonEncode(imported.worldbook))
          : const Value.absent(),
      tags: Value(jsonEncode(imported.tags)),
      avatarPath: Value(avatarPath),
      imageGalleryJson: galleryJson.isNotEmpty
          ? Value(jsonEncode(galleryJson))
          : const Value.absent(),
      sourceType: sourceType,
      sourcePath: Value(sourcePath),
      createdAt: now,
      updatedAt: now,
    ));

    await _db.insertAdaptation(CharacterAdaptationsCompanion.insert(
      id: _uuid.v4(),
      characterId: id,
      adaptationJson: jsonEncode(imported.adaptation),
      createdAt: now,
      updatedAt: now,
    ));

    return id;
  }

  /// Saves gallery images into `documents/character_images/<id>/` and returns
  /// the manifest entries (`{name, path}`).
  Future<List<Map<String, dynamic>>> _saveGallery(
    List<ImportedImage> images, {
    required String characterId,
  }) async {
    if (images.isEmpty) return const [];
    final dir = await getApplicationDocumentsDirectory();
    final imagesDir =
        Directory(p.join(dir.path, 'character_images', characterId));
    await imagesDir.create(recursive: true);
    final out = <Map<String, dynamic>>[];
    for (final img in images) {
      try {
        final file = File(p.join(imagesDir.path, '${_uuid.v4()}.png'));
        await file.writeAsBytes(resizeImage(img.bytes));
        out.add({'name': img.name, 'path': file.path});
      } catch (_) {
        // Best-effort: a bad image shouldn't fail the import.
      }
    }
    return out;
  }

  /// Creates a user-defined character (sourceType = manual) with a default
  /// adaptation, mirroring the import path.
  Future<String> createCharacter({
    required String name,
    required Map<String, dynamic> core,
    List<String> tags = const [],
    String? avatarPath,
    String? virtualAge,
    String? realAge,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final id = _uuid.v4();
    await _db.insertCharacter(CharactersCompanion.insert(
      id: id,
      name: name,
      corePersonaJson: jsonEncode(core),
      avatarPath: Value(avatarPath),
      tags: Value(jsonEncode(tags)),
      virtualAge: Value(virtualAge),
      realAge: Value(realAge),
      sourceType: 'manual',
      createdAt: now,
      updatedAt: now,
    ));
    await _db.insertAdaptation(CharacterAdaptationsCompanion.insert(
      id: _uuid.v4(),
      characterId: id,
      adaptationJson: '{}',
      createdAt: now,
      updatedAt: now,
    ));
    return id;
  }

  Future<void> deleteCharacter(String id) async {
    final character = await _db.getCharacter(id);
    if (character == null) throw AppException('角色不存在');
    await _db.deleteCharacter(id);
  }

  /// Saves avatar bytes to the app documents dir (downscaled to a 256×256 PNG)
  /// and returns the path. When [oldPath] is given, the old avatar file is
  /// deleted after the new one is written, so re-setting an avatar doesn't leak
  /// orphan files.
  Future<String> saveAvatar(List<int> bytes, {String? oldPath}) async {
    final dir = await getApplicationDocumentsDirectory();
    final avatarDir = Directory(p.join(dir.path, 'avatars'));
    await avatarDir.create(recursive: true);
    final file = File(p.join(avatarDir.path, '${_uuid.v4()}.png'));
    await file.writeAsBytes(resizeAvatarPng(bytes));
    if (oldPath != null && oldPath.isNotEmpty) {
      try {
        await File(oldPath).delete();
      } catch (_) {
        // Best-effort: a missing/held old file shouldn't fail the save.
      }
    }
    return file.path;
  }

  Future<void> updateCharacter(String id, CharactersCompanion entry) =>
      _db.updateCharacter(id, entry);
}
