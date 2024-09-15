import '../index.dart';

/// data class for [TaskTemplate]
class TaskTemplate {
  String id;
  String? wardId;
  String name;
  String notes;
  List<TaskTemplateSubTask> subtasks;
  bool isPublicVisible;
  String? createdBy;

  get isWardTemplate => wardId != null;

  TaskTemplate({
    required this.id,
    this.wardId,
    required this.name,
    required this.notes,
    this.subtasks = const [],
    this.isPublicVisible = false,
    this.createdBy
  });

  TaskTemplate copyWith({
    String? id,
    String? wardId,
    String? name,
    String? notes,
    List<TaskTemplateSubTask>? subtasks,
    bool? isPublicVisible,
    String? createdBy,
  }) {
    return TaskTemplate(
      id: id ?? this.id,
      wardId: wardId ?? this.wardId,
      name: name ?? this.name,
      notes: notes ?? this.notes,
      subtasks: subtasks ?? this.subtasks,
      isPublicVisible: isPublicVisible ?? this.isPublicVisible,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}
