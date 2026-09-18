import 'package:lpinyin/lpinyin.dart';

/// Returns the WeChat/QQ-style first-letter bucket for a name:
/// ASCII letter → uppercase letter; Chinese → pinyin initial; anything else
/// (digits / symbols / unknown) → '#'.
String pinyinInitial(String name) {
  final trimmed = name.trim();
  if (trimmed.isEmpty) return '#';

  final first = trimmed.runes.first;
  // A-Z / a-z.
  if ((first >= 0x41 && first <= 0x5A) || (first >= 0x61 && first <= 0x7A)) {
    return String.fromCharCode(first).toUpperCase();
  }
  // CJK Unified Ideographs.
  if (first >= 0x4E00 && first <= 0x9FFF) {
    final py = PinyinHelper.getShortPinyin(String.fromCharCode(first));
    if (py.isNotEmpty) return py[0].toUpperCase();
    return '#';
  }
  return '#';
}
