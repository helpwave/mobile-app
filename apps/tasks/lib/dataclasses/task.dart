// TODO delete later and import from protobufs
import 'package:tasks/dataclasses/patient.dart';
import 'package:tasks/dataclasses/subtask.dart';

enum TaskStatus {
  unspecified,
  todo,
  inProgress,
  done,
}

/// data class for [Task]
class Task {
  String id;
  String name;
  String? assignee;
  String notes;
  TaskStatus status;
  List<SubTask> subtasks;
  DateTime? dueDate;
  DateTime? creationDate;
  bool isPublicVisible;

  static get empty => Task(id: "", name: "name", notes: "");

  double get progress => subtasks.isNotEmpty
      ? subtasks.where((element) => element.isDone).length / subtasks.length
      : 1;

  /// the remaining time until a task is due
  ///
  /// **NOTE**: returns [Duration.zero] if [dueDate] is null
  Duration get remainingTime =>
      dueDate != null ? dueDate!.difference(DateTime.now()) : Duration.zero;

  bool get isOverdue => remainingTime.isNegative;

  bool get inNextTwoDays => remainingTime.inDays < 2;

  bool get inNextHour => remainingTime.inHours < 1;

  bool get isCreating => id == "";

  Task({
    required this.id,
    required this.name,
    required this.notes,
    this.assignee,
    this.status = TaskStatus.todo,
    this.subtasks = const [],
    this.dueDate,
    this.creationDate,
    this.isPublicVisible = false,
  });
}

class TaskWithPatient extends Task {
  PatientMinimal patient;

  factory TaskWithPatient.empty({
    String taskId = "",
    PatientMinimal? patient,
  }) {
    return TaskWithPatient(id: taskId, name: "task name", notes: "", patient: patient ?? PatientMinimal.empty());
  }

  factory TaskWithPatient.fromTask({
    required Task task,
    PatientMinimal? patient,
  }) {
    return TaskWithPatient(
      id: task.id,
      name: task.name,
      notes: task.notes,
      isPublicVisible: task.isPublicVisible,
      // maybe do deep copy here
      subtasks: task.subtasks,
      status: task.status,
      dueDate: task.dueDate,
      creationDate: task.creationDate,
      assignee: task.assignee,
      patient: patient ?? PatientMinimal.empty(),
    );
  }

  TaskWithPatient({
    required super.id,
    required super.name,
    required super.notes,
    super.assignee,
    super.status,
    super.subtasks,
    super.dueDate,
    super.creationDate,
    super.isPublicVisible,
    required this.patient,
  });
}
