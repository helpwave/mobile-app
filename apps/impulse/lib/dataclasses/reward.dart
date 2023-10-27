/// The data class for a [Reward]
class Reward {
  /// The identifier
  String id;

  /// The title
  String title;

  /// The description
  String description;

  /// The points for the [Reward]
  int points;

  Reward({
    required this.title,
    required this.description,
    required this.points,
    required this.id,
  });
}
