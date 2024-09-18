/// data class for [TaskTemplateSubTask]
class TaskTemplateSubTask {
  String id;
  String name;
  bool isDone;

  TaskTemplateSubTask({
    required this.id,
    required this.name,
    this.isDone = false
  });
}
