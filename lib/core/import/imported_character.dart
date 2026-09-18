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
}
