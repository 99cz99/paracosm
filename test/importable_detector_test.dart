import 'package:flutter_test/flutter_test.dart';
import 'package:paracosm/features/assistant/data/importable_detector.dart';

void main() {
  test('detects a flat V1 character card', () {
    const json = '{"name":"猫娘","description":"傲娇系猫娘"}';
    final r = detectImportable(json);
    expect(r?.kind, ImportableKind.character);
  });

  test('detects a V2 character card wrapped in data', () {
    const json = '{"spec":"chara_card_v2","spec_version":"2.0",'
        '"data":{"name":"猫娘","description":"傲娇系猫娘"}}';
    final r = detectImportable(json);
    expect(r?.kind, ImportableKind.character);
  });

  test('detects a V2 card inside a code fence', () {
    const json = '```json\n'
        '{"spec":"chara_card_v2","spec_version":"2.0",'
        '"data":{"name":"猫娘","first_mes":"喵～"}}\n'
        '```';
    final r = detectImportable(json);
    expect(r?.kind, ImportableKind.character);
  });

  test('detects a world export', () {
    const json = '{"type":"paracosm_world","name":"异世界"}';
    final r = detectImportable(json);
    expect(r?.kind, ImportableKind.world);
  });

  test('detects a worldbook', () {
    const json = '{"name":"设定","entries":[{"keys":["a"],"content":"b"}]}';
    final r = detectImportable(json);
    expect(r?.kind, ImportableKind.worldbook);
  });

  test('returns null for non-card JSON', () {
    const json = '{"foo":"bar"}';
    expect(detectImportable(json), isNull);
  });
}
