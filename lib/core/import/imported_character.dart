/// The single, provider-agnostic import model.
///
/// Every import source (SillyTavern card, future Skill import) collapses into
/// this: a core persona + a default adaptation + an optional built-in world
/// book. The built-in book stays private to the character; the shared
/// `Worldbooks` library is a separate concern.
class ImportedCharacter {
  ImportedCharacter({
    required this.name,
    required this.core,
    required this.adaptation,
    this.worldbook,
    this.tags = const [],
    this.sourcePath,
    this.affinity,
    this.stateSchema,
    this.avatarBytes,
    this.gallery = const [],
    this.regexScripts = const [],
  });

  final String name;

  /// Core persona (stable across worlds).
  final Map<String, dynamic> core;

  /// Default adaptation (worldId = '').
  final Map<String, dynamic> adaptation;

  /// The character's own lorebook / world book, nullable. Kept on the character
  /// (not split into the shared library).
  final Map<String, dynamic>? worldbook;

  final List<String> tags;
  final String? sourcePath;

  /// Skill state from `references/affinity.json` (trust/corruption axes), if
  /// the imported source carried one. Persisted under `core['affinity']`.
  final Map<String, dynamic>? affinity;

  /// State field-name map from `references/state_schema.json` (key → display
  /// label), if present. Persisted under `core['state_schema']`.
  final Map<String, dynamic>? stateSchema;

  /// The character's portrait/avatar image (from a PNG card, a V3 `assets`
  /// `icon`, a base64 `image` field, or a Skill avatar file); null when none.
  final List<int>? avatarBytes;

  /// Extra images (expressions/backgrounds) the character can send in chat.
  final List<ImportedImage> gallery;

  /// SillyTavern "regex scripts" (JS regex find/replace) applied to the
  /// character's displayed output (e.g. `<CG{code}>` → `<img src=…>`).
  final List<Map<String, dynamic>> regexScripts;

  ImportedCharacter withAvatar(List<int> bytes) => ImportedCharacter(
        name: name,
        core: core,
        adaptation: adaptation,
        worldbook: worldbook,
        tags: tags,
        sourcePath: sourcePath,
        affinity: affinity,
        stateSchema: stateSchema,
        avatarBytes: bytes,
        gallery: gallery,
        regexScripts: regexScripts,
      );

  ImportedCharacter withGallery(List<ImportedImage> gallery) => ImportedCharacter(
        name: name,
        core: core,
        adaptation: adaptation,
        worldbook: worldbook,
        tags: tags,
        sourcePath: sourcePath,
        affinity: affinity,
        stateSchema: stateSchema,
        avatarBytes: avatarBytes,
        gallery: gallery,
        regexScripts: regexScripts,
      );
}

/// A named image (expression / background) carried by a character card.
class ImportedImage {
  ImportedImage({required this.name, required this.bytes});

  final String name;
  final List<int> bytes;
}
