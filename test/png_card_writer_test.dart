import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:paracosm/core/import/png_card_extractor.dart';
import 'package:paracosm/core/import/png_card_writer.dart';

void main() {
  const json =
      '{"spec":"chara_card_v2","spec_version":"2.0","data":{"name":"测试角色","first_mes":"你好"}}';

  test('embed without cover round-trips through PngCardExtractor', () {
    final bytes = PngCardWriter().embed(json, name: '测试角色');
    expect(PngCardExtractor().extract(bytes), json);
  });

  test('embed with cover round-trips and stays a decodable PNG', () {
    final cover = img.Image(width: 8, height: 8);
    img.fill(cover, color: img.ColorRgb8(255, 0, 0));
    final coverBytes = img.encodePng(cover);

    final bytes =
        PngCardWriter().embed(json, coverBytes: coverBytes, name: 'Alice');
    expect(PngCardExtractor().extract(bytes), json);
    expect(img.decodePng(bytes), isNotNull);
  });

  test('embed with a non-ASCII name falls back to a plain tile', () {
    final bytes = PngCardWriter().embed(json, name: '测试角色');
    expect(bytes, isNotEmpty);
    expect(PngCardExtractor().extract(bytes), json);
  });
}
