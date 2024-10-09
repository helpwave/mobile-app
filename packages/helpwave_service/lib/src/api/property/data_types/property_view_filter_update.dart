class PropertyViewFilterUpdate {
  final String subjectId;
  final List<String> appendToAlwaysInclude;
  final List<String> removeFromAlwaysInclude;
  final List<String> appendToDontAlwaysInclude;
  final List<String> removeFromDontAlwaysInclude;

  PropertyViewFilterUpdate({
    required this.subjectId,
    this.appendToAlwaysInclude = const [],
    this.removeFromAlwaysInclude = const [],
    this.appendToDontAlwaysInclude = const [],
    this.removeFromDontAlwaysInclude = const [],
  });
}
