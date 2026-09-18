import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/database.dart';
import '../network/llm/llm_provider.dart';
import '../network/llm/provider_config.dart';
import '../storage/secure_storage.dart';
import 'db_providers.dart';

/// Reactive list of provider configs (drift rows, no API keys).
final providerConfigsProvider = StreamProvider<List<ProviderConfig>>((ref) {
  return ref.watch(dbProvider).watchProviderConfigs();
});

/// Resolves a ready-to-use config: the named [providerId] if given (falling
/// back to the default when it no longer exists), else the default config.
///
/// Read fresh on every send so edits to the provider are reflected immediately
/// (no cached FutureProvider staleness).
Future<LlmProviderConfig?> resolveProvider(
  AppDatabase db,
  SecureKeyStore store, {
  String? providerId,
}) async {
  ProviderConfig? row;
  if (providerId != null && providerId.isNotEmpty) {
    row = await db.getProviderConfig(providerId);
  }
  row ??= await db.getDefaultProviderConfig();
  if (row == null) return null;
  final apiKey = await store.read(SecureKeyStore.keyForProvider(row.id)) ?? '';
  return LlmProviderConfig(
    id: row.id,
    name: row.name,
    type: _toType(row.type),
    baseUrl: row.baseUrl,
    model: row.model,
    apiKey: apiKey,
    extraParams: _decodeJson(row.extraParamsJson),
    memoryModel: row.memoryModel,
  );
}

/// Resolves the active (default) provider into a ready-to-use config.
Future<LlmProviderConfig?> resolveActiveProvider(
  AppDatabase db,
  SecureKeyStore store,
) =>
    resolveProvider(db, store);

ProviderType _toType(String type) =>
    type == 'anthropic' ? ProviderType.anthropic : ProviderType.openaiCompatible;

Map<String, dynamic> _decodeJson(String s) {
  try {
    final decoded = jsonDecode(s);
    return decoded is Map<String, dynamic> ? decoded : <String, dynamic>{};
  } catch (_) {
    return <String, dynamic>{};
  }
}
