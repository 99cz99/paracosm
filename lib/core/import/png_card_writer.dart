import 'dart:convert';
import 'dart:typed_data';

import 'package:image/image.dart' as img;

/// Writes a SillyTavern character card JSON into a PNG's `chara` tEXt chunk,
/// mirroring [PngCardExtractor] (which reads `ccv3 ?? chara`).
///
/// The JSON is base64-encoded because the `image` package writes tEXt keyword
/// and value with latin1, and raw UTF-8 JSON may carry non-latin1 code points.
class PngCardWriter {
  Uint8List embed(String json, {List<int>? coverBytes, String? name}) {
    img.Image image;
    if (coverBytes != null && coverBytes.isNotEmpty) {
      image =
          img.decodeImage(Uint8List.fromList(coverBytes)) ?? _placeholder(name);
    } else {
      image = _placeholder(name);
    }
    image.textData = {'chara': base64Encode(utf8.encode(json))};
    return img.encodePng(image);
  }

  /// A brand-purple tile used as the card's visual when the user supplied no
  /// portrait. ASCII names are drawn in white; CJK names are left as a plain
  /// tile (the bundled arial bitmap font has no CJK glyphs).
  img.Image _placeholder(String? name) {
    const size = 512;
    final image = img.Image(width: size, height: size);
    img.fill(image, color: img.ColorRgb8(0x7C, 0x6F, 0xDE));
    final label = (name ?? '').trim();
    if (label.isNotEmpty && label.codeUnits.every((c) => c < 128)) {
      final text = label.length > 16 ? '${label.substring(0, 16)}…' : label;
      img.drawString(image, text,
          font: img.arial48, color: img.ColorRgb8(0xFF, 0xFF, 0xFF));
    }
    return image;
  }
}
