import 'dart:convert';

import '../../utils/app_exception.dart';
import 'llm_provider.dart';

/// Translates a single text to Simplified Chinese via [provider]. Retries once
/// with a stricter prompt when the first pass still looks untranslated.
Future<String> translateToChinese(LlmProvider provider, String text) async {
  var result = await _translateOnce(provider, text);
  if (result.isNotEmpty && needsTranslation(result)) {
    result = await _translateOnce(provider, text, strict: true);
  }
  return result.isEmpty ? text : result;
}

Future<String> _translateOnce(
  LlmProvider provider,
  String text, {
  bool strict = false,
}) async {
  final buffer = StringBuffer();
  final systemPrompt = strict
      ? '你是专业翻译。把下面的英文完整翻译成简体中文，绝对不能输出英文原文，'
          '保留原文的段落、换行、{{char}}、*动作* 等格式，只输出中文译文。'
      : '把下面的内容翻译成简体中文，保留原文的段落、换行、{{char}}、*动作* 等格式，只输出译文，不要解释。';
  await for (final chunk in provider.streamChat(ChatRequest(
    messages: [ChatMessage(role: 'user', content: text)],
    systemPrompt: systemPrompt,
    // Long English greetings (2k+ chars) translate to 2k~3k Chinese tokens;
    // 2048 was truncating them back to English. 16384 gives ample headroom,
    // including for reasoning models whose "thinking" eats output tokens.
    maxTokens: 16384,
    temperature: 0.3,
  ))) {
    if (chunk.textDelta != null) buffer.write(chunk.textDelta);
  }
  return buffer.toString().trim();
}

/// True when the text has no CJK characters (i.e. likely English/other and
/// should be translated to Chinese).
bool needsTranslation(String text) {
  if (text.trim().isEmpty) return false;
  return !text.runes.any(isCjk);
}

/// Translates a list of English keys to Simplified Chinese in one batch call,
/// returning a map of `{original: translated}`. Keys already containing CJK are
/// skipped.
///
/// Robust against common model quirks (markdown fences, prose around the JSON,
/// array output, trailing commas, keys echoed with different casing). Retries
/// once with a stricter prompt when the first pass yields nothing usable.
///
/// Returns an empty map only on network/stream errors (caller shows a generic
/// "check your provider" hint). Throws [LlmException] — including the raw model
/// output — when the response can't be parsed into any translation.
Future<Map<String, String>> translateKeys(
  LlmProvider provider,
  List<String> keys,
) async {
  final unique = keys.where(needsTranslation).toSet().toList();
  if (unique.isEmpty) return const {};

  String? lastRaw;
  String? lastFinish;
  for (final strict in const [false, true]) {
    final ({String text, String? finishReason}) once;
    try {
      once = await _translateKeysOnce(provider, unique, strict: strict);
    } catch (_) {
      return const {}; // network/stream error → let caller show a generic hint
    }
    lastRaw = once.text;
    lastFinish = once.finishReason;
    final parsed = _parseKeyTranslations(once.text, unique);
    if (parsed.isNotEmpty) return parsed;
  }

  final finish = lastFinish == null ? '' : '（finish: $lastFinish）';
  throw LlmException(
    '模型未返回可解析的关键词译文$finish。原始返回：\n$lastRaw',
    code: 'translate_keys',
  );
}

Future<({String text, String? finishReason})> _translateKeysOnce(
  LlmProvider provider,
  List<String> keys, {
  required bool strict,
}) async {
  final buffer = StringBuffer();
  String? finishReason;
  final systemPrompt = strict
      ? '你是翻译器。只输出一个 JSON 对象，键必须与原文完全一致，值为简体中文译文。'
          '不要解释、不要 markdown、不要代码块，只要纯 JSON。'
      : '你是翻译器，只输出 JSON 对象，键=原文、值=中文译文，不要解释、不要代码块。';
  await for (final chunk in provider.streamChat(ChatRequest(
    messages: [
      ChatMessage(
        role: 'user',
        content: '把下面每个关键词翻译成简体中文，输出 JSON 对象（键=原文，值=中文译文）：\n'
            '${jsonEncode(keys)}',
      ),
    ],
    systemPrompt: systemPrompt,
    // Reasoning models (e.g. deepseek-v4-pro) spend output tokens "thinking"
    // before answering; 4096 was exhausted, leaving `content` empty.
    maxTokens: 16384,
    temperature: 0.2,
  ))) {
    if (chunk.textDelta != null) buffer.write(chunk.textDelta);
    if (chunk.finishReason != null) finishReason = chunk.finishReason;
  }
  return (text: buffer.toString().trim(), finishReason: finishReason);
}

/// Decodes the model's raw output into `{originalKey: translated}`. Returns an
/// empty map when nothing usable can be decoded.
Map<String, String> _parseKeyTranslations(String text, List<String> keys) {
  final decoded = _decodeJsonValue(text);
  if (decoded == null) return const {};

  // Normalize keys (trim + lowercase) so the model echoing them with different
  // casing/whitespace still matches the original key.
  final byNorm = <String, String>{
    for (final k in keys) k.trim().toLowerCase(): k,
  };

  final result = <String, String>{};
  if (decoded is Map) {
    for (final entry in decoded.entries) {
      final orig = byNorm[entry.key.toString().trim().toLowerCase()];
      if (orig == null) continue;
      final v = entry.value?.toString().trim() ?? '';
      if (v.isEmpty || v == orig) continue;
      result[orig] = v;
    }
  } else if (decoded is List) {
    // Some models answer a list of keys with a parallel list of translations.
    for (var i = 0; i < decoded.length && i < keys.length; i++) {
      final orig = keys[i];
      final v = decoded[i]?.toString().trim() ?? '';
      if (v.isEmpty || v == orig) continue;
      result[orig] = v;
    }
  }
  return result;
}

/// Best-effort JSON decode from model output that may be wrapped in markdown
/// fences or prose, or contain trailing commas.
dynamic _decodeJsonValue(String text) {
  var t = text
      .replaceAll(RegExp(r'```[a-zA-Z]*\s*'), '')
      .replaceAll('```', '')
      .trim();
  if (t.isEmpty) return null;

  var d = _tryDecode(t);
  if (d != null) return d;

  d = _tryExtract(t, '{', '}');
  if (d != null) return d;
  return _tryExtract(t, '[', ']');
}

dynamic _tryExtract(String t, String open, String close) {
  final start = t.indexOf(open);
  if (start < 0) return null;
  final end = t.lastIndexOf(close);
  if (end <= start) return null;
  return _tryDecode(t.substring(start, end + 1));
}

dynamic _tryDecode(String s) {
  try {
    return jsonDecode(s);
  } catch (_) {
    // Tolerate trailing commas before a closing bracket/brace.
    try {
      return jsonDecode(
        s.replaceAllMapped(RegExp(r',\s*([}\]])'), (m) => m.group(1)!),
      );
    } catch (_) {
      return null;
    }
  }
}

bool isCjk(int r) =>
    (r >= 0x4E00 && r <= 0x9FFF) ||
    (r >= 0x3400 && r <= 0x4DBF) ||
    (r >= 0x3040 && r <= 0x30FF) ||
    (r >= 0xAC00 && r <= 0xD7AF);
