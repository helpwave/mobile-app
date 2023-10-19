import 'package:tasks/dataclasses/bed.dart';
import 'package:tasks/dataclasses/room.dart';
import 'package:tasks/dataclasses/task.dart';

enum PatientAssignmentStatus { active, unassigned, discharged }

class PatientMinimal {
  String id;
  String name;

  PatientMinimal({
    required this.id,
    required this.name,
  });
}

/// data class for [Patient] with TaskCount
class Patient extends PatientMinimal {
  RoomMinimal? room;
  BedMinimal? bed;
  List<Task> tasks;

  get isUnassigned => bed == null && room == null;

  get isActive => bed != null && room != null;

  get unscheduledCount => tasks.where((task) => task.status == TaskStatus.todo).length;

  get inProgressCount => tasks.where((task) => task.status == TaskStatus.inProgress).length;

  get doneCount => tasks.where((task) => task.status == TaskStatus.done).length;

  Patient({
    required super.id,
    required super.name,
    required this.tasks,
    this.room,
    this.bed,
  });
}

/// A data class which maps all [PatientAssignmentStatus]es to a [List] of [Patient]s
class PatientsByAssignmentStatus {
  List<Patient> active;
  List<Patient> unassigned;
  List<Patient> discharged;

  PatientsByAssignmentStatus({
    this.active = const [],
    this.unassigned = const [],
    this.discharged = const [],
  });

  byAssignmentStatus(PatientAssignmentStatus status) {
    switch (status) {
      case PatientAssignmentStatus.active:
        return active;
      case PatientAssignmentStatus.unassigned:
        return unassigned;
      case PatientAssignmentStatus.discharged:
        return discharged;
    }
  }
}
