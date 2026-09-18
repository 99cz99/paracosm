import 'package:flutter_test/flutter_test.dart';
import 'package:paracosm/core/utils/pinyin.dart';

void main() {
  test('pinyinInitial buckets names into first-letter', () {
    expect(pinyinInitial('顾清寒'), 'G');
    expect(pinyinInitial('绫地宁宁'), 'L');
    expect(pinyinInitial('Yes, My Liege'), 'Y');
    expect(pinyinInitial('abc'), 'A');
    expect(pinyinInitial('123'), '#');
    expect(pinyinInitial(r'@#$'), '#');
    expect(pinyinInitial(''), '#');
  });
}
