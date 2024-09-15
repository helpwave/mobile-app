import 'package:flutter/cupertino.dart';
import 'package:helpwave_service/tasks.dart';
import 'package:helpwave_util/loading_state.dart';

/// The Controller for [Task]s of the current [User]
class MyTasksController extends ChangeNotifier {
  /// The [LoadingState] of the Controller
  LoadingState state = LoadingState.initializing;

  /// The currently loaded tasks
  List<TaskWithPatient> _tasks = [];

  /// The currently loaded tasks
  List<TaskWithPatient> get tasks => _tasks;

  /// The loaded tasks which have [TaskStatus.todo]
  List<TaskWithPatient> get todo => _tasks.where((element) => element.status == TaskStatus.todo).toList();

  /// The loaded tasks which have [TaskStatus.inProgress]
  List<TaskWithPatient> get inProgress => _tasks.where((element) => element.status == TaskStatus.inProgress).toList();

  /// The loaded tasks which have [TaskStatus.done]
  List<TaskWithPatient> get done => _tasks.where((element) => element.status == TaskStatus.done).toList();

  MyTasksController() {
    load();
  }

  /// Loads the tasks
  Future<void> load() async {
    if (state == LoadingState.initializing) {
      state = LoadingState.loading;
      notifyListeners();
    }

    var patients = await PatientService().getPatientList();
    List<Patient>allPatients = patients.all;

    _tasks = [];
    // TODO use the already given information by the later updated getPatientList
    for(Patient patient in allPatients) {
      List<Task> tasks = await TaskService().getTasksByPatient(patientId: patient.id);
      for(var task in tasks) {
        _tasks.add(TaskWithPatient(
          id: task.id,
          name: task.name,
          assigneeId: task.assigneeId,
          notes: task.notes,
          dueDate: task.dueDate,
          status: task.status,
          subtasks: task.subtasks,
          patientId: patient.id,
          patient: patient,
        ));
      }
    }

    state = LoadingState.loaded;
    notifyListeners();
  }
}
