extension UpsertExtension<T> on List<T> {
  List<T> upsert(List<T> upsertList, String Function(T a) hash) {
    Map<String, T> uniqueMap = {};

    for (T item in this) {
      uniqueMap[hash(item)] = item;
    }

    for (T item in upsertList) {
      uniqueMap[hash(item)] = item;
    }

    return uniqueMap.values.toList();
  }
}
