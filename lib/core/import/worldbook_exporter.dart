import 'dart:convert';

/// Exports a world book as a SillyTavern lorebook JSON document (name +
/// description + entries), round-trippable with [WorldbookParser].
String exportWorldbookJson({
  required String name,
  required String description,
  required String bookJson,
}) {
  Map<String, dynamic> book;
  try {
    book = jsonDecode(bookJson) as Map<String, dynamic>;
  } catch (_) {
    book = const {};
  }
  final entries = book['entries'];
  return jsonEncode({
    'name': name,
    'description': description,
    'entries': entries is List ? entries : const <dynamic>[],
  });
}
