import 'package:helpwave_proto_dart/proto/services/impulse_svc/v1/impulse_svc.pbenum.dart';

/// The data class for a [Challenge]
class Challenge {
  /// The identifier
  String id;

  /// The [title]
  String title;

  /// The [description]
  String description;

  /// The [DateTime] at which the task can be started
  DateTime startAt;

  /// The [DateTime] until which the task can be completed
  DateTime endAt;

  /// The Category in which the [Challenge] falls
  ChallengeCategory category;

  /// The type of [Challenge]
  ChallengeType type;

  // TODO clear up what this does
  int threshold;

  /// The points awarded on [Challenge] completion
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
