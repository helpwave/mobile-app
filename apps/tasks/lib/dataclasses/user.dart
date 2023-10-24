/// data class for [User]
class User {
  String id;
  String name;
  String nickName;
  Uri profile;

  User({
    required this.id,
    required this.name,
    required this.nickName,
    required this.profile,
  });

  factory User.empty({String id = ""}) => User(id: id, name: "", nickName: "", profile: Uri.base);
}
