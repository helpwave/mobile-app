// TODO delete later and import from protobufs
import 'package:tasks/dataclasses/subtask.dart';

enum TaskStatus {
  taskStatusUnspecified,
  taskStatusTodo,
  taskStatusInProgress,
  taskStatusDone,
}

/// data class for [Task]
class Task {
  String id;
  String name;
  String assignee;
  String notes;
  TaskStatus status;
  List<SubTask> subtasks;
  DateTime? dueDate;
  DateTime? creationDate;
  bool isPublicVisible;

  Task({
    required this.id,
    required this.name,
    required this.assignee,
    required this.notes,
    this.status = TaskStatus.taskStatusTodo,
    this.subtasks = const [],
    this.dueDate,
    this.creationDate,
    this.isPublicVisible = false,
  });
}
