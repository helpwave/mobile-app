import 'package:tasks/dataclasses/bed.dart';
import 'package:tasks/dataclasses/room.dart';
import 'package:tasks/dataclasses/task.dart';

enum PatientAssignmentStatus { active, unassigned, discharged, all }

class PatientMinimal {
  String id;
  String name;

  factory PatientMinimal.empty() => PatientMinimal(id: "", name: "");

  bool get isCreating => id == "";

  PatientMinimal({
    required this.id,
    required this.name,
  });
}

/// data class for [Patient] with TaskCount
class Patient extends PatientMinimal {
  RoomMinimal? room;
  BedMinimal? bed;
  String notes;
  List<Task> tasks;

  get isUnassigned => bed == null && room == null;

  get isActive => bed != null && room != null;

  List<Task> get unscheduledTasks => tasks.where((task) => task.status == TaskStatus.todo).toList();

  List<Task> get inProgressTasks =>
      tasks.where((task) => task.status == TaskStatus.inProgress).toList();

  List<Task> get doneTasks => tasks.where((task) => task.status == TaskStatus.done).toList();

  get unscheduledCount => unscheduledTasks.length;

  get inProgressCount => inProgressTasks.length;

  get doneCount => doneTasks.length;

  factory Patient.empty({String id = ""}) {
    return Patient(id: id, name: "", tasks: [], notes: "");
  }

  Patient({
    required super.id,
    required super.name,
    required this.tasks,
    required this.notes,
    this.room,
    this.bed,
  });
}

/// A data class which maps all [PatientAssignmentStatus]es to a [List] of [Patient]s
class PatientsByAssignmentStatus {
  List<Patient> active;
  List<Patient> unassigned;
  List<Patient> discharged;
  List<Patient> all;

  PatientsByAssignmentStatus({
    this.active = const [],
    this.unassigned = const [],
    this.discharged = const [],
    this.all = const [],
  });

  byAssignmentStatus(PatientAssignmentStatus status) {
    switch (status) {
      case PatientAssignmentStatus.active:
        return active;
      case PatientAssignmentStatus.unassigned:
        return unassigned;
      case PatientAssignmentStatus.discharged:
        return discharged;
      case PatientAssignmentStatus.all:
        return all;
    }
  }
}
