/// data class for [SubTask]
class SubTask {
  String id;
  String name;
  bool isDone;

  SubTask({
    required this.id,
    required this.name,
    this.isDone = false
  });
}
