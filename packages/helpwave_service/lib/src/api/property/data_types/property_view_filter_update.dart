class PropertyViewFilterUpdate {
  final List<String> appendToAlwaysInclude;
  final List<String> removeFromAlwaysInclude;
  final List<String> appendToDontAlwaysInclude;
  final List<String> removeFromDontAlwaysInclude;

  const PropertyViewFilterUpdate({
    this.appendToAlwaysInclude = const [],
    this.removeFromAlwaysInclude = const [],
    this.appendToDontAlwaysInclude = const [],
    this.removeFromDontAlwaysInclude = const [],
  });
}
