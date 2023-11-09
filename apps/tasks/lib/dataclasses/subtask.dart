/// data class for [SubTask]
class SubTask {
  String id;
  String name;
  bool isDone;

  bool get isCreating => id == "";

  SubTask({
    required this.id,
    required this.name,
    this.isDone = false
  });
}
