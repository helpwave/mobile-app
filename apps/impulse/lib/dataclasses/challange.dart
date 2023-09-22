// TODO update later
enum ChallengeCategory { fitness }

enum ChallengeType { timer }

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
