import 'dart:convert';

/// Exports a character (core persona + optional world book) to a SillyTavern
/// V2 character card JSON string, round-trippable with the importer.
class CharacterExporter {
  String exportToJson({
    required String name,
    required Map<String, dynamic> core,
    Map<String, dynamic>? worldbook,
    List<String> tags = const [],
  }) {
    final data = <String, dynamic>{
      'name': name,
      ...core,
      'tags': tags,
      'character_book': ?worldbook,
    };
    // `affinity` / `state_schema` are app-internal skill state, not
    // SillyTavern persona fields.
    data.remove('affinity');
    data.remove('state_schema');
    // `regex_scripts` is a SillyTavern field that lives under `extensions`
    // (not top-level); move it back so HTML/regex cards round-trip on export.
    final regexScripts = data.remove('regex_scripts');
    if (regexScripts is List && regexScripts.isNotEmpty) {
      final existing = data['extensions'];
      final extensions = existing is Map<String, dynamic>
          ? Map<String, dynamic>.from(existing)
          : <String, dynamic>{};
      extensions['regex_scripts'] = regexScripts;
      data['extensions'] = extensions;
    }
    return jsonEncode({
      'spec': 'chara_card_v2',
      'spec_version': '2.0',
      'data': data,
    });
  }
}
