import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:paracosm/core/import/st_card_parser.dart';

void main() {
  test('parses V3 assets: icon → avatar, emotion → gallery', () {
    final iconB64 = base64.encode([1, 2, 3, 4]);
    final happyB64 = base64.encode([5, 6, 7, 8]);
    final card = jsonEncode({
      'data': {'name': '宁宁', 'description': 'd'},
      'assets': [
        {
          'type': 'icon',
          'uri': 'data:image/png;base64,$iconB64',
          'name': 'icon',
          'ext': 'png',
        },
        {
          'type': 'emotion',
          'uri': 'data:image/png;base64,$happyB64',
          'name': 'happy',
          'ext': 'png',
        },
      ],
    });
    final imported = StCardParser().parse(card);
    expect(imported.avatarBytes, [1, 2, 3, 4]);
    expect(imported.gallery.single.name, 'happy');
    expect(imported.gallery.single.bytes, [5, 6, 7, 8]);
  });

  test('falls back to base64 image field for avatar', () {
    final b64 = base64.encode([9, 9, 9]);
    final card = jsonEncode({
      'data': {'name': '宁宁', 'image': b64},
    });
    final imported = StCardParser().parse(card);
    expect(imported.avatarBytes, [9, 9, 9]);
    expect(imported.gallery, isEmpty);
  });

  test('background assets go into the gallery too', () {
    final bgB64 = base64.encode([1, 1, 1]);
    final card = jsonEncode({
      'data': {'name': '宁宁'},
      'assets': [
        {
          'type': 'background',
          'uri': 'data:image/png;base64,$bgB64',
          'name': '教室',
          'ext': 'png',
        },
      ],
    });
    final imported = StCardParser().parse(card);
    expect(imported.gallery.single.name, '教室');
  });

  test('parses risuai additionalAssets into gallery', () {
    final imgB64 = base64.encode([7, 8, 9]);
    final card = jsonEncode({
      'data': {
        'name': 'Aria',
        'extensions': {
          'risuai': {
            'additionalAssets': [
              ['Aria/admiration', imgB64, 'webp'],
            ],
          },
        },
      },
    });
    final imported = StCardParser().parse(card);
    expect(imported.gallery.single.name, 'Aria/admiration');
    expect(imported.gallery.single.bytes, [7, 8, 9]);
  });
}
