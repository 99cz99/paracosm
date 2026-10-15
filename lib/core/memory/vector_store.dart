import 'dart:convert';
import 'dart:math' as math;

import 'package:drift/drift.dart' show Value;

import '../db/database.dart';
import '../network/llm/llm_provider.dart';
import '../network/llm/provider_factory.dart';
import '../providers/llm_providers.dart';
import '../storage/secure_storage.dart';

/// Semantic recall: embeds text via the default provider's embedding model and
/// retrieves the most similar stored vectors by cosine similarity. Purely
/// best-effort — every public method returns empty / no-ops when embedding is
/// unavailable or fails, and never throws to the caller.
class VectorStore {
  VectorStore(this._db, this._store);

  final AppDatabase _db;
  final SecureKeyStore _store;

  /// Resolves an embedding-capable provider: the default provider, but only
  /// when it has a non-empty `embeddingModel`. Null = recall disabled.
  Future<LlmProvider?> _embeddingProvider() async {
    final config = await resolveActiveProvider(_db, _store);
    if (config == null) return null;
    final provider = buildLlmProvider(config);
    return provider.supportsEmbeddings ? provider : null;
  }

  /// Embeds [text] into a vector, or returns null when unavailable / on failure.
  Future<List<double>?> embed(String text) async {
    final provider = await _embeddingProvider();
    if (provider == null) return null;
    try {
      return await provider.embed(text);
    } catch (_) {
      return null;
    }
  }

  /// Embeds and stores [text] under a stable [id] (dedup key). Skips when the
  /// id is already present, so re-running never re-embeds the same text.
  Future<void> upsert({
    required String id,
    required String? characterId,
    required String worldId,
    required String kind,
    required String text,
  }) async {
    if (await _db.getMemoryVector(id) != null) return;
    final vector = await embed(text);
    if (vector == null) return;
    await _db.upsertMemoryVector(MemoryVectorsCompanion.insert(
      id: id,
      characterId: Value(characterId),
      worldId: Value(worldId),
      kind: kind,
      content: text,
      embeddingJson: jsonEncode(vector),
      createdAt: DateTime.now().millisecondsSinceEpoch,
    ));
  }

  /// Returns the top-K vectors most similar to [query] within the scope,
  /// sorted by descending cosine similarity.
  Future<List<MemoryVector>> search(
    String query, {
    required String? characterId,
    required String worldId,
    required String kind,
    int topK = 3,
  }) async {
    final q = await embed(query);
    if (q == null) return const [];
    final rows = await _db.getMemoryVectors(characterId, worldId, kind);
    final scored = <({MemoryVector row, double score})>[];
    for (final row in rows) {
      final v = _decode(row.embeddingJson);
      if (v.isEmpty) continue;
      scored.add((row: row, score: cosineSimilarity(q, v)));
    }
    scored.sort((a, b) => b.score.compareTo(a.score));
    return scored.take(topK).map((s) => s.row).toList();
  }

  static List<double> _decode(String json) {
    try {
      final d = jsonDecode(json);
      if (d is List) return d.map((e) => (e as num).toDouble()).toList();
    } catch (_) {}
    return const [];
  }

  static double cosineSimilarity(List<double> a, List<double> b) {
    if (a.length != b.length) return 0;
    var dot = 0.0, na = 0.0, nb = 0.0;
    for (var i = 0; i < a.length; i++) {
      dot += a[i] * b[i];
      na += a[i] * a[i];
      nb += b[i] * b[i];
    }
    if (na == 0 || nb == 0) return 0;
    return dot / (math.sqrt(na) * math.sqrt(nb));
  }
}
