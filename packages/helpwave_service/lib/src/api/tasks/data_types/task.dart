import 'package:helpwave_service/src/api/tasks/data_types/patient.dart';
import 'package:helpwave_service/src/api/tasks/data_types/subtask.dart';
import 'package:helpwave_service/util.dart';

enum TaskStatus {
  unspecified,
  todo,
  inProgress,
  done,
}

/// data class for [Task]
class Task extends IdentifiedObject<String> {
  String name;
  String? assigneeId;
  String notes;
  TaskStatus status;
  List<Subtask> subtasks;
  DateTime? dueDate;
  final DateTime? creationDate;
  final String? createdBy;
  bool isPublicVisible;
  final String? patientId;

  factory Task.empty(String? patientId) => Task(name: "name", notes: "", patientId: patientId);

  final _nullID = "00000000-0000-0000-0000-000000000000";

  double get progress => subtasks.isNotEmpty ? subtasks.where((element) => element.isDone).length / subtasks.length : 1;

  /// the remaining time until a task is due
  ///
  /// **NOTE**: returns [Duration.zero] if [dueDate] is null
  Duration get remainingTime => dueDate != null ? dueDate!.difference(DateTime.now()) : Duration.zero;

  bool get isOverdue => remainingTime.isNegative;

  bool get inNextTwoDays => remainingTime.inDays < 2;

  bool get inNextHour => remainingTime.inHours < 1;

  bool get hasAssignee => assigneeId != null && assigneeId != "" && assigneeId != _nullID;

  Task({
    super.id,
    required this.name,
    required this.notes,
    this.assigneeId,
    this.status = TaskStatus.todo,
    this.subtasks = const [],
    this.dueDate,
    this.creationDate,
    this.createdBy,
    this.isPublicVisible = false,
    required this.patientId,
  });

  Task copyWith({
    String? id,
    String? name,
    String? assigneeId,
    String? notes,
    TaskStatus? status,
    List<Subtask>? subtasks,
    DateTime? dueDate,
    DateTime? creationDate,
    String? createdBy,
    bool? isPublicVisible,
    String? patientId,
  }) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      assigneeId: assigneeId ?? this.assigneeId,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      subtasks: subtasks ?? this.subtasks,
      dueDate: dueDate ?? this.dueDate,
      creationDate: creationDate ?? this.creationDate,
      createdBy: createdBy ?? this.createdBy,
      isPublicVisible: isPublicVisible ?? this.isPublicVisible,
      patientId: patientId ?? this.patientId,
    );
  }

  @override
  String toString() {
    return "{id: $id, name: $name, description: $notes, subtasks: $subtasks, patientId: $patientId}";
  }
}

class TaskWithPatient extends Task {
  final PatientMinimal patient;

  factory TaskWithPatient.empty({
    String? taskId,
    PatientMinimal? patient,
  }) {
    return TaskWithPatient(
      id: taskId,
      name: "task name",
      notes: "",
      patient: patient ?? PatientMinimal.empty(),
      patientId: patient?.id,
    );
  }

  factory TaskWithPatient.fromTaskAndPatient({
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
      assigneeId: task.assigneeId,
      patient: patient ?? PatientMinimal.empty(),
      patientId: patient?.id,
    );
  }

  TaskWithPatient({
    required super.id,
    required super.name,
    required super.notes,
    super.assigneeId,
    super.status,
    super.subtasks,
    super.dueDate,
    super.creationDate,
    super.createdBy,
    super.isPublicVisible,
    required super.patientId,
    required this.patient,
  }) : assert(patientId == patient.id);
}
