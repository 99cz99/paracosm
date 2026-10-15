import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:uuid/uuid.dart';

import '../db/database.dart';

/// Exports a Paracosm sampling preset as a SillyTavern-compatible generation
/// preset JSON. Only the fields Paracosm can express are emitted; ST-only
/// fields (min_p / top_k / top_a / typical_p / tfs / mirostat_* …) are omitted
/// so SillyTavern falls back to its own defaults.
///
/// Note: `presencePenalty` / `frequencyPenalty` are OpenAI-style (−2..2),
/// mapped approximately onto SillyTavern's repetition-penalty axes — the two
/// systems disagree on range and direction, so this is best-effort, not exact.
String exportPresetJson(Preset p) => jsonEncode({
      'type': 'paracosm_preset',
      'name': p.name,
      if (p.temperature != null) 'temperature': p.temperature,
      if (p.topP != null) 'top_p': p.topP,
      if (p.maxTokens != null) 'max_length': p.maxTokens,
      if (p.presencePenalty != null)
        'repetition_penalty_presence': p.presencePenalty,
      if (p.frequencyPenalty != null)
        'repetition_penalty_frequency': p.frequencyPenalty,
    });

/// Parses a SillyTavern generation preset (or a `paracosm_preset` export) into
/// a [PresetsCompanion]. Returns null when the payload isn't a usable preset.
PresetsCompanion? parseStPresetJson(String json) {
  try {
    final data = jsonDecode(json);
    if (data is! Map<String, dynamic>) return null;
    final name = (data['name'] ?? '').toString().trim();
    if (name.isEmpty) return null;
    final now = DateTime.now().millisecondsSinceEpoch;
    return PresetsCompanion.insert(
      id: const Uuid().v4(),
      name: name,
      temperature: Value(_toDouble(data['temperature'])),
      topP: Value(_toDouble(data['top_p'] ?? data['topP'])),
      maxTokens: Value(
          _toInt(data['max_length'] ?? data['max_tokens'] ?? data['response_length'])),
      presencePenalty: Value(_toDouble(data['repetition_penalty_presence'])),
      frequencyPenalty: Value(_toDouble(data['repetition_penalty_frequency'])),
      createdAt: now,
      updatedAt: now,
    );
  } catch (_) {
    return null;
  }
}

double? _toDouble(dynamic v) {
  if (v is num) return v.toDouble();
  if (v == null) return null;
  return double.tryParse(v.toString());
}

int? _toInt(dynamic v) {
  if (v is num) return v.toInt();
  if (v == null) return null;
  return int.tryParse(v.toString());
}
