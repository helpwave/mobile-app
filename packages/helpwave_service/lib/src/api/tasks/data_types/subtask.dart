import 'package:helpwave_service/src/api/util/identified_object.dart';

/// Data class for a [Subtask]
class Subtask extends IdentifiedObject<String> {
  final String? taskId;
  String name;
  bool isDone;


  Subtask({super.id, required this.taskId, required this.name, this.isDone = false}) : assert(id == null || taskId != null);

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
