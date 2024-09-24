/// data class for [User]
class User {
  String id;
  String name;
  String nickName;
  String email;
  Uri profileUrl;

  User({
    required this.id,
    required this.name,
    required this.nickName,
    required this.email,
    required this.profileUrl,
  });

  factory User.empty({String id = ""}) => User(id: id, name: "", nickName: "", email: "", profileUrl: Uri.base);

  bool get isCreating => id == "";

  User copyWith({String? name, String? nickName, Uri? profileUrl, String? email}) => User(
        id: id,
        name: name ?? this.name,
        nickName: nickName ?? this.nickName,
        profileUrl: profileUrl ?? this.profileUrl,
        email: email ?? this.email,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
