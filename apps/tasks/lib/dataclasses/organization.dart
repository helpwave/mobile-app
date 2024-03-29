/// data class for [Organization]
class Organization {
  String id;
  String name;
  String shortName;

  Organization({
    required this.id,
    required this.name,
    required this.shortName,
  });

  @override
  String toString() {
    return "{id: $id, name: $name, shortName: $shortName}";
  }
}
