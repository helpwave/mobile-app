/// A class for the identification of objects
class IdentifiedObject<T> {
  final T? id;

  bool get isCreating => id == null;

  IdentifiedObject({this.id});

  bool isReferencingSame(IdentifiedObject<T> other) {
    return runtimeType == other.runtimeType && this.id == other.id;
  }

  @override
  String toString() {
    return "$runtimeType{id: $id}";
  }
}
