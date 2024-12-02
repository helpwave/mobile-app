/// A class for the identification of objects
class IdentifiedObject<T> {
  final T? id;

  IdentifiedObject({this.id});

  bool isReferencingSame(IdentifiedObject<T> other) {
    return runtimeType == other.runtimeType && this.id == other.id;
  }

  @override
  String toString() {
    return "$runtimeType{id: $id}";
  }
}

/// A Extension to check the creation status of an [IdentifiedObject]
extension CreationExtension<T> on IdentifiedObject<T> {
  bool get isCreating => id == null;
}
