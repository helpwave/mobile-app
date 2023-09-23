enum Gender { male, female, na, divers }

class User {
  String id;
  String username;
  Gender gender;
  DateTime birthday;
  int pal;
  String teamId;

  User({
    required this.id,
    required this.username,
    required this.gender,
    required this.birthday,
    required this.pal,
    this.teamId = "",
  });
}
