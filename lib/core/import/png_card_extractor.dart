import 'dart:convert';
import 'dart:typed_data';

import 'package:image/image.dart' as img;

/// Extracts the embedded JSON from a SillyTavern PNG character card.
///
/// SillyTavern writes two tEXt chunks: `chara` (V2) and `ccv3` (V3, read
/// priority). Both hold base64-encoded JSON.
class PngCardExtractor {
  String? extract(List<int> bytes) {
    final image = img.decodePng(Uint8List.fromList(bytes));
    if (image == null) return null;

    final textData = image.textData;
    if (textData == null || textData.isEmpty) return null;

    final raw = textData['ccv3'] ?? textData['chara'];
    if (raw == null || raw.trim().isEmpty) return null;

    try {
      return utf8.decode(base64.decode(raw.trim()));
    } on FormatException {
      return raw; // in case a card stores raw JSON rather than base64
    }
  }
}
