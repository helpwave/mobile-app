import 'package:tasks/dataclasses/bed.dart';
import 'package:tasks/dataclasses/room.dart';
import 'package:tasks/dataclasses/task.dart';

/// data class for [Patient] with TaskCount
class Patient {
  String id;
  String name;
  RoomMinimal? room;
  BedMinimal? bed;
  List<Task> tasks;

  get unscheduledCount => tasks.where((task) => task.status == TaskStatus.TASK_STATUS_TODO).length;
  get inProgressCount => tasks.where((task) => task.status == TaskStatus.TASK_STATUS_IN_PROGRESS).length;
  get doneCount => tasks.where((task) => task.status == TaskStatus.TASK_STATUS_DONE).length;

  Patient({
    required this.id,
    required this.name,
    required this.tasks,
    this.room,
    this.bed,
  });
}
