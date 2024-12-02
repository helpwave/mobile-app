extension ListMapWithIndexExtension<T> on List<T> {
  /// Maps each element of the list to a new value based on its index.
  /// The [mapper] function receives the element and its index.
  List<E> mapWithIndex<E>(E Function(T element, int index) mapper) {
    return indexed.map((value) => mapper(value.$2, value.$1)).toList();
  }
}
