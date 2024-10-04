extension ListIsInRangeExtension on List {
  bool isIndexValid(int index) => index >= 0 && index < length;
}
