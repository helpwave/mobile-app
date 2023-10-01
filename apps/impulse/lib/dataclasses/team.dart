import 'package:helpwave_proto_dart/proto/services/impulse_svc/v1/impulse_svc.pbenum.dart';

class Team {
  String id;
  String name;
  String description;

  Team({
    required this.id,
    required this.name,
    required this.description,
  });
}

class TeamStats {
  String id;
  int score;
  Map<Gender, int> genderCount;
  double averageAge;
  int userCount;

  TeamStats({
    required this.id,
    required this.score,
    required this.genderCount,
    required this.averageAge,
    required this.userCount,
  });
}
