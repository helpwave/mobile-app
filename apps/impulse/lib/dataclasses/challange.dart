import 'package:helpwave_proto_dart/proto/services/impulse_svc/v1/impulse_svc.pbenum.dart';

class Challenge {
  String id;
  String title;
  String description;
  DateTime startAt;
  DateTime endAt;
  ChallengeCategory category;

  ChallengeType type;

  int threshold;

  int points;

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.startAt,
    required this.endAt,
    required this.type,
    required this.category,
    required this.threshold,
    required this.points,
  });
}
