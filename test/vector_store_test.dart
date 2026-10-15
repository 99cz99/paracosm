import 'package:flutter_test/flutter_test.dart';
import 'package:paracosm/core/memory/vector_store.dart';

void main() {
  test('cosineSimilarity returns 1 for identical vectors', () {
    expect(VectorStore.cosineSimilarity([1, 0], [1, 0]), closeTo(1.0, 1e-9));
    expect(VectorStore.cosineSimilarity([1, 1], [1, 1]), closeTo(1.0, 1e-9));
  });

  test('cosineSimilarity returns 0 for orthogonal vectors', () {
    expect(VectorStore.cosineSimilarity([1, 0], [0, 1]), closeTo(0.0, 1e-9));
  });

  test('cosineSimilarity handles zero vectors and mismatched lengths', () {
    expect(VectorStore.cosineSimilarity([0, 0], [1, 0]), 0.0);
    expect(VectorStore.cosineSimilarity([1, 0], [1, 0, 0]), 0.0);
  });
}
