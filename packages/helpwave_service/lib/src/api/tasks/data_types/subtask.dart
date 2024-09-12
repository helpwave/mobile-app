/// Data class for a [Subtask]
class Subtask {
  String id;
  String name;
  bool isDone;

  bool get isCreating => id == "";

  Subtask({
    required this.id,
    required this.name,
    this.isDone = false
  });

  /// Create a copy of the [Subtask]
  Subtask copyWith({
    String? id,
    String? name,
    bool? isDone,
  }) {
    return Subtask(
      id: id ?? this.id,
      name: name ?? this.name,
      isDone: isDone ?? this.isDone,
    );
  }
}
