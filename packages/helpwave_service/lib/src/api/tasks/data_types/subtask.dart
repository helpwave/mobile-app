/// Data class for a [Subtask]
class Subtask {
  final String id;
  final String taskId;
  String name;
  bool isDone;

  bool get isCreating => id == "";

  Subtask({required this.id, required this.taskId, required this.name, this.isDone = false});

  /// Create a copy of the [Subtask]
  Subtask copyWith({
    String? id,
    String? taskId,
    String? name,
    bool? isDone,
  }) {
    return Subtask(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      name: name ?? this.name,
      isDone: isDone ?? this.isDone,
    );
  }
}
