// TODO delete later and import from protobufs
import 'package:tasks/dataclasses/subtask.dart';

enum TaskStatus {
  TASK_STATUS_UNSPECIFIED,
  TASK_STATUS_TODO,
  TASK_STATUS_IN_PROGRESS,
  TASK_STATUS_DONE,
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
    this.status = TaskStatus.TASK_STATUS_TODO,
    this.subtasks = const [],
    this.dueDate,
    this.creationDate,
    this.isPublicVisible = false,
  });
}
