import 'package:flutter/material.dart';
import 'package:helpwave_widget/loading.dart';
import '../dataclasses/task.dart';
import '../services/task_svc.dart';

/// The Controller for managing a [Task]
class TaskController extends ChangeNotifier {
  /// The [LoadingState] of the Controller
  LoadingState _state = LoadingState.initializing;

  /// The current [Task], may or may not be loaded depending on the [_state]
  Task _task;

  /// The error message to show should only be used when [state] == [LoadingState.error]
  String errorMessage = "";

  /// Saves whether we are currently creating of a Task or already have them
  bool _isCreating = false;

  TaskController(this._task) {
    _isCreating = _task.id == "";
    if (!_isCreating) {
      load();
    }
  }

  LoadingState get state => _state;

  set state(LoadingState value) {
    _state = value;
    notifyListeners();
  }

  Task get task => _task;

  set task(Task value) {
    _task = value;
    _state = LoadingState.loaded;
    notifyListeners();
  }

  // Used to trigger the notify call without having to copy or save the Task locally
  updateTask(void Function(Task task) transformer) {
    transformer(task);
    state = LoadingState.loaded;
  }

  get isCreating => _isCreating;

  /// A function to load the [Task]
  load() async {
    state = LoadingState.loading;
    await TaskService()
        .getTask(id: task.id)
        .then((value) => {task = value})
        .catchError((error, stackTrace) {
      errorMessage = error.toString();
      state = LoadingState.error;
      return <Task>{};
    });
  }
}
