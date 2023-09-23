enum Gender {
  male,
  female,
  na,
  divers
}

class User {
  String username;
  Gender sex;
  DateTime birthday;
  int pal;

  User({
    required this.username,
    required this.sex,
    required this.birthday,
    required this.pal,
  });
}
