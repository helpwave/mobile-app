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

  /// Used to trigger the notify call without having to copy or save the Task locally
  updateTask(void Function(TaskWithPatient task) updateTransform, void Function(TaskWithPatient task) revertTransform) {
    updateTransform(task);
    if (!isCreating) {
      TaskService().updateTask(task).then((value) {
        if (value) {
          state = LoadingState.loaded;
        } else {
          throw Error();
        }
      }).catchError((error, stackTrace) {
        revertTransform(task);
        errorMessage = error.toString();
        state = LoadingState.error;
      });
    } else {
      state = LoadingState.loaded;
    }
    state = LoadingState.loaded;
  }

  bool get isCreating => _isCreating;

  PatientMinimal get patient => task.patient;

  /// A function to load the [Task]
  load() async {
    state = LoadingState.loading;
    await TaskService().getTask(id: task.id).then((value) {
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
  Future<void> changeAssignee(String assigneeId) async {
    String? old = task.assignee;
    updateTask((task) {
      task.assignee = assigneeId;
    }, (task) {
      task.assignee = old;
    });
  }

  Future<void> changeName(String name) async {
    String oldName = task.name;
    updateTask((task) {
      task.name = name;
    }, (task) {
      task.name = oldName;
    });
  }

  Future<void> changeIsPublic(bool isPublic) async {
    task.isPublicVisible = isPublic;
    bool old = task.isPublicVisible;
    updateTask((task) {
      task.isPublicVisible = isPublic;
    }, (task) {
      task.isPublicVisible = old;
    });
  }

  Future<void> changeNotes(String notes) async {
    String oldNotes = notes;
    updateTask((task) {
      task.notes = notes;
    }, (task) {
      task.notes = oldNotes;
    });
  }
}
