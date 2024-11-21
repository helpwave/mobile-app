import 'package:helpwave_service/util.dart';

/// data class for [Ward]
class WardMinimal extends IdentifiedObject {
  String name;

  WardMinimal({
    super.id,
    required this.name,
  });


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
    return "$runtimeType{id: $id, name: $name}";
  }
}

class Ward extends WardMinimal {
  String organizationId;

  Ward({
    super.id,
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
    super.id,
    required super.name,
    required this.bedCount,
    required this.tasksInTodo,
    required this.tasksInInProgress,
    required this.tasksInDone,
  });
}
