/// data class for [Ward]
class WardMinimal {
  String id;
  String name;
  String organizationId;

  WardMinimal({
    required this.id,
    required this.name,
    required this.organizationId,
  });
}

class Ward extends WardMinimal {
  String organizationId;

  Ward({
    required super.id,
    required super.name,
    required this.organizationId,
  });
}

class WardOverview extends WardMinimal {
  int bedCount;
  int tasksInTodo;
  int tasksInInProgress;
  int tasksInDone;

  WardOverview({
    required super.id,
    required super.name,
    required this.bedCount,
    required this.tasksInTodo,
    required this.tasksInInProgress,
    required this.tasksInDone,
  });
}
