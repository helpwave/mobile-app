import 'package:helpwave_proto_dart/proto/services/impulse_svc/v1/impulse_svc.pbenum.dart';

class User {
  String id;
  String username;
  Gender gender;
  DateTime birthday;
  double pal;
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
