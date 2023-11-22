import 'package:flutter/material.dart';
import 'package:helpwave_widget/loading.dart';
import '../dataclasses/patient.dart';
import '../dataclasses/task.dart';
import '../services/task_svc.dart';

/// The Controller for managing a [TaskWithPatient]
class TaskController extends ChangeNotifier {
  /// The [LoadingState] of the Controller
  LoadingState _state = LoadingState.initializing;

  /// The current [Task], may or may not be loaded depending on the [_state]
  TaskWithPatient _task;

  /// The error message to show should only be used when [state] == [LoadingState.error]
  String errorMessage = "";

  /// Saves whether we are currently creating of a Task or already have them
  bool _isCreating = false;

  TaskController(this._task) {
    _isCreating = _task.id == "";
    if (!_isCreating) {
      load();
    } else {
      state = LoadingState.unspecified;
    }
  }

  LoadingState get state => _state;

  set state(LoadingState value) {
    _state = value;
    notifyListeners();
  }

  TaskWithPatient get task => _task;

  set task(TaskWithPatient value) {
    _task = value;
    _state = LoadingState.loaded;
    notifyListeners();
  }

  // Used to trigger the notify call without having to copy or save the Task locally
  updateTask(void Function(TaskWithPatient task) transformer) {
    transformer(task);
    state = LoadingState.loaded;
  }

  bool get isCreating => _isCreating;

  PatientMinimal get patient => task.patient;

  /// A function to load the [Task]
  load() async {
    state = LoadingState.loading;
    await TaskService()
        .getTask(id: task.id)
        .then((value) {
      task = value;
      state = LoadingState.loaded;
    }).catchError((error, stackTrace) {
      errorMessage = error.toString();
      state = LoadingState.error;
    });
  }

  /// Changes the Assignee
  ///
  /// Without a backend request as we expect this to be done in the [AssigneeSelectController]
  Future<void> changeAssignee({required String assigneeId}) async {
    task.assignee = assigneeId;
    notifyListeners();
  }

  Future<void> changeIsPublic({required bool isPublic}) async {
    // TODO backend request
    task.isPublicVisible = isPublic;
    notifyListeners();
  }

  Future<void> changeNotes(String notes) async {
    // TODO backend request when appropriate
    task.notes = notes;
    notifyListeners();
  }
}
