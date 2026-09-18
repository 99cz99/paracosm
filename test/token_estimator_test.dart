import 'package:flutter_test/flutter_test.dart';
import 'package:paracosm/core/network/llm/token_estimator.dart';

void main() {
  test('empty string is 0 tokens', () {
    expect(estimateTokens(''), 0);
  });

  test('CJK chars count ~1 token each', () {
    expect(estimateTokens('一二三四五六七八九十'), 10);
  });

  test('ASCII counts ~4 chars per token', () {
    expect(estimateTokens('abcdefghijklmnop'), 4);
  });

  test('mixed CJK + ASCII', () {
    expect(estimateTokens('你好世界abcdefgh'), 6);
  });
}
