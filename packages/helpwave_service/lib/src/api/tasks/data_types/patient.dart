import 'package:helpwave_service/src/api/tasks/index.dart';

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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is PatientMinimal) {
      return id == other.id && name == other.name;
    }

    return false;
  }

  @override
  int get hashCode => id.hashCode + name.hashCode;

  @override
  String toString() {
    if (isCreating) {
      return "PatientMinimal<Empty>";
    }
    return "PatientMinimal<$id, $name>";
  }
}

class PatientWithBedId extends PatientMinimal {
  String? bedId;
  bool isDischarged;
  String notes;

  PatientWithBedId({
    required super.id,
    required super.name,
    required this.isDischarged,
    required this.notes,
    this.bedId,
  });

  PatientWithBedId copyWith({
    String? id,
    String? name,
    String? bedId,
    bool? isDischarged,
    String? notes,
  }) {
    return PatientWithBedId(
      id: id ?? this.id,
      name: name ?? this.name,
      isDischarged: isDischarged ?? this.isDischarged,
      notes: notes ?? this.notes,
      bedId: bedId ?? this.bedId,
    );
  }

  bool get hasBed => bedId != null;
}

/// data class for [Patient] with TaskCount
class Patient extends PatientMinimal {
  RoomMinimal? room;
  BedMinimal? bed;
  String notes;
  List<Task> tasks;
  bool isDischarged;

  get isUnassigned => bed == null && room == null;

  get isActive => bed != null && room != null;

  List<Task> get unscheduledTasks => tasks.where((task) => task.status == TaskStatus.todo).toList();

  List<Task> get inProgressTasks => tasks.where((task) => task.status == TaskStatus.inProgress).toList();

  List<Task> get doneTasks => tasks.where((task) => task.status == TaskStatus.done).toList();

  get unscheduledCount => unscheduledTasks.length;

  get inProgressCount => inProgressTasks.length;

  get doneCount => doneTasks.length;

  factory Patient.empty({String id = ""}) {
    return Patient(id: id, name: "Patient", tasks: [], notes: "", isDischarged: false);
  }

  Patient({
    required super.id,
    required super.name,
    required this.tasks,
    required this.notes,
    required this.isDischarged,
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
