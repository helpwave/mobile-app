import 'package:helpwave_service/src/api/util/identified_object.dart';

/// data class for [User]
class User extends IdentifiedObject {
  String name;
  String nickName;
  String email;
  Uri profileUrl;

  User({
    super.id,
    required this.name,
    required this.nickName,
    required this.email,
    required this.profileUrl,
  });

  factory User.empty({String? id}) => User(id: id, name: "User", nickName: "", email: "", profileUrl: Uri.base);

  User copyWith({String? id, String? name, String? nickName, Uri? profileUrl, String? email}) => User(
        id: id ?? this.id,
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

  @override
  String toString() {
    return "$runtimeType{id: $id, name: $name}";
  }
}
