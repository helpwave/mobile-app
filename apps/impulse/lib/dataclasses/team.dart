import 'package:helpwave_proto_dart/proto/services/impulse_svc/v1/impulse_svc.pbenum.dart';
import 'package:impulse/dataclasses/user.dart';

/// The dataclass for a [Team]
class Team {
  /// The identifier
  String id;
  /// The name of the [Team]
  String name;
  /// The description of the [Team]
  String description;

  Team({
    required this.id,
    required this.name,
    required this.description,
  });
}

/// The dataclass for [TeamStats]
class TeamStats {
  /// The identifier
  String id;
  /// The [score] of the [Team]
  int score;
  /// The amount of persons per [Gender]
  Map<Gender, int> genderCount;
  /// The average age of the [Team] member
  double averageAge;
  /// The amount of [User]s in the [Team]
  int userCount;

  TeamStats({
    required this.id,
    required this.score,
    required this.genderCount,
    required this.averageAge,
    required this.userCount,
  });
}
