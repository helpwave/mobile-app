/// data class for [TaskTemplateSubtask]
class TaskTemplateSubtask {
  final String? id;
  final String? templateId;
  String name;

  bool get isCreating => id == null || templateId == null;

  TaskTemplateSubtask({
    this.id,
    this.templateId,
    required this.name,
  }) : assert((templateId == null && id == null) || (templateId != null));

  TaskTemplateSubtask copyWith({
    String? id,
    String? templateId,
    String? name,
  }) {
    return TaskTemplateSubtask(
      id: id ?? this.id,
      templateId: templateId ?? this.templateId,
      name: name ?? this.name,
    );
  }

  @override
  String toString() {
    return "{id: $id, templateId: $templateId, name: $name}";
  }
}
