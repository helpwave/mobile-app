List<T> multiSearchWithMapping<T>(String search, List<T> objects, List<String> Function(T object) mapping) {
  return objects.where((object) {
    final mappedSearchKeywords = mapping(object).map((value) => value.toLowerCase().trim());
    return mappedSearchKeywords.any((value) => value.contains(search.toLowerCase().trim()));
  }).toList();
}

List<T> simpleSearchWithMapping<T>(String search, List<T> values, String Function(T object) mapping) {
  return multiSearchWithMapping(search, values, (value) => [mapping(value)]);
}

List<String> simpleSearch(String search, List<String> values) {
  return simpleSearchWithMapping(search, values, (value) => value);
}
