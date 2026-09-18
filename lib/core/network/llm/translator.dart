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
    // 2048 was truncating them back to English. 8192 gives ample headroom.
    maxTokens: 8192,
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

bool isCjk(int r) =>
    (r >= 0x4E00 && r <= 0x9FFF) ||
    (r >= 0x3400 && r <= 0x4DBF) ||
    (r >= 0x3040 && r <= 0x30FF) ||
    (r >= 0xAC00 && r <= 0xD7AF);
