abstract class CRUDInterface<IdentifierType, T, Create, Update> {
  /// A [Function] for loading the object
  Future<T> get(IdentifierType id);

  /// A [Function] for creating the object
  Future<T> create(Create value);

  /// A [Function] for updating the object with an update object
  Future<bool> update(IdentifierType id, Update? update);

  /// A [Function] for deleting the object
  Future<bool> delete(IdentifierType id);
}
