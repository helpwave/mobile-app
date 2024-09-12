import '../index.dart';

/// data class for [TaskTemplate]
class TaskTemplate {
  String id;
  String? wardID;
  String name;
  String notes;
  List<TaskTemplateSubTask> subtasks;
  bool isPublicVisible;

  get isWardTemplate => wardID != null;

  TaskTemplate({
    required this.id,
    this.wardID,
    required this.name,
    required this.notes,
    this.subtasks = const [],
    this.isPublicVisible = false,
  });
}
