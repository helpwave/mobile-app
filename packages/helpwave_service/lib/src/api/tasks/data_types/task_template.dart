import '../index.dart';

/// data class for [TaskTemplate]
class TaskTemplate {
  final String? id;
  final String? wardId;
  String name;
  String description;
  List<TaskTemplateSubtask> subtasks;
  bool isPublicVisible;
  String? createdBy;

  bool get isWardTemplate => wardId != null;

  bool get isCreating => id == null;

  TaskTemplate(
      {this.id,
      this.wardId,
      required this.name,
      this.description = "",
      this.subtasks = const [],
      this.isPublicVisible = false,
      this.createdBy})
      : assert((id == null && subtasks.every((element) => element.isCreating)) ||
            (id != null && subtasks.every((element) => !element.isCreating)));

  TaskTemplate copyWith({
    String? id,
    String? wardId,
    String? name,
    String? description,
    List<TaskTemplateSubtask>? subtasks,
    bool? isPublicVisible,
    String? createdBy,
  }) {
    return TaskTemplate(
      id: id ?? this.id,
      wardId: wardId ?? this.wardId,
      name: name ?? this.name,
      description: description ?? this.description,
      subtasks: subtasks ?? this.subtasks,
      isPublicVisible: isPublicVisible ?? this.isPublicVisible,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  @override
  String toString() {
    return "{id: $id, name: $name, description: $description}";
  }
}
