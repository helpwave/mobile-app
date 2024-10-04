abstract class CRUDInterface<T, UpdateFunction extends Function> {
  /// A [Function] for loading the object
  Future<T> get(String id);

  /// A [Function] for creating the object
  Future<T> create(T value);

  /// A [Function] for updating the object
  ///
  /// Due to a lack in the dart language we cannot enforce a return type of a Function without providing a fixed
  /// parameter list
  ///
  /// Example usage:
  ///
  /// ```dart
  /// @override
  /// Future<bool> Function({String? id}) get update => ({String? id}) async {
  ///   return true;
  /// }
  /// ```
  UpdateFunction get update;

  /// A [Function] for deleting the object
  Future<bool> delete(String id);
}
