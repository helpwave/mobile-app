/// data class for [User]
class User {
  String id;
  String name;
  String nickName;
  Uri profile;

  // TODO add email

  User({
    required this.id,
    required this.name,
    required this.nickName,
    required this.profile,
  });

  factory User.empty({String id = ""}) => User(id: id, name: "", nickName: "", profile: Uri.base);

  bool get isCreating => id == "";

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
