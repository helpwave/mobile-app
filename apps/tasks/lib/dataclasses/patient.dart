import 'package:tasks/dataclasses/bed.dart';
import 'package:tasks/dataclasses/room.dart';
import 'package:tasks/dataclasses/task.dart';

enum PatientAssignmentStatus {
  active,
  unassigned,
  discharged
}

/// data class for [Patient] with TaskCount
class Patient {
  String id;
  String name;
  RoomMinimal? room;
  BedMinimal? bed;
  List<Task> tasks;

  get isUnassigned => bed == null && room == null;
  get isActive =>bed != null && room != null;
  get unscheduledCount => tasks.where((task) => task.status == TaskStatus.taskStatusTodo).length;
  get inProgressCount => tasks.where((task) => task.status == TaskStatus.taskStatusInProgress).length;
  get doneCount => tasks.where((task) => task.status == TaskStatus.taskStatusInProgress).length;

  Patient({
    required this.id,
    required this.name,
    required this.tasks,
    this.room,
    this.bed,
  });
}
