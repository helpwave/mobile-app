List<int> range(int start, int end, [int step = 1]) {
  if (step == 0) {
    throw ArgumentError('Step cannot be zero.');
  }

  List<int> result = [];
  for (int i = start; (step > 0 ? i < end : i > end); i += step) {
    result.add(i);
  }
  return result;
}
