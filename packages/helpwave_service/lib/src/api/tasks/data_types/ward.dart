/// data class for [Ward]
class WardMinimal {
  String id;
  String name;

  WardMinimal({
    required this.id,
    required this.name,
  });

  bool get isCreating => id == "";

  WardMinimal copyWith({
    String? id,
    String? name,
  }) {
    return WardMinimal(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  String toString() {
    return "{id: $id, name: $name}";
  }
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
