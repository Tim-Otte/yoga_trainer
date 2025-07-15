extension IterableExtension<E> on Iterable<E> {
  /// Returns a new iterable with the results of applying the given function to each element
  /// of this iterable, along with its index.
  ///
  /// The provided function receives the element and the index as arguments.
  ///
  /// Example:
  /// ```dart
  /// final list = ['a', 'b', 'c'];
  /// final mapped = list.mapWithIndex((value, index) => '$index: $value');
  /// // mapped: ['0: a', '1: b', '2: c']
  /// ```
  Iterable<T> mapWithIndex<T>(
    T Function(E element, int index) toElement,
  ) sync* {
    int index = 0;
    for (var value in this) {
      yield toElement(value, index++);
    }
  }
}
