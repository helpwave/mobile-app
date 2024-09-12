import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:helpwave_service/src/api/tasks/index.dart';
import 'package:helpwave_util/loading_state.dart';

/// The Controller for managing [Subtask]s in a [Task]
///
/// Providing a [taskId] means loading and synchronising the [Subtask]s with
/// the backend while no [taskId] or a empty [String] means that the subtasks
/// only used locally
class SubtasksController extends ChangeNotifier {
  /// The [LoadingState] of the Controller
  LoadingState _state = LoadingState.initializing;

  LoadingState get state => _state;

  set state(LoadingState value) {
    _state = state;
    notifyListeners();
  }

  /// The [Subtask]s
  List<Subtask> _subtasks = [];

  List<Subtask> get subtasks => [..._subtasks];

  set subtasks(List<Subtask> value) {
    _subtasks = value;
    notifyListeners();
  }

  bool _isCreating = false;

  bool get isCreating => _isCreating;

  String taskId;

  /// Only valid in case [state] == [LoadingState.error]
  String errorMessage = "";

  SubtasksController({this.taskId = "", List<Subtask>? subtasks}) {
    _isCreating = taskId == "";
    if (!isCreating) {
      load();
    } else {
      state = LoadingState.unspecified;
    }
  }

  Future<void> load() async {
    state = LoadingState.loading;
    if (!isCreating) {
      await TaskService().getTask(id: taskId).then((task) {
        subtasks = task.subtasks;
        state = LoadingState.loaded;
      }).onError(
        (error, stackTrace) {
          state = LoadingState.error;
        },
      );
      return;
    }
    state = LoadingState.loaded;
  }

  /// Delete the subtask by the index.dart
  Future<void> deleteByIndex(int index) async {
    if (index < 0 || index >= subtasks.length) {
      return;
    }
    if (isCreating) {
      _subtasks.removeAt(index);
      notifyListeners();
      return;
    }
    state = LoadingState.loading;
    await TaskService().deleteSubTask(subtaskId: subtasks[index].id, taskId: taskId).then((value) {
      if (value) {
        _subtasks.removeAt(index);
        state = LoadingState.loaded;
      }
    }).catchError((error, stackTrace) {
      errorMessage = error.toString();
      state = LoadingState.error;
      return null;
    });
  }

  /// Delete the [Subtask] by the id
  Future<void> delete(String id) async {
    assert(!isCreating, "delete should not be used when creating a completely new SubTask list");
    int index = _subtasks.indexWhere((element) => element.id == id);
    if (index != -1) {
      deleteByIndex(index);
    }
  }

  /// Add the [Subtask]
  Future<void> add(Subtask subTask) async {
    if (isCreating) {
      _subtasks.add(subTask);
      notifyListeners();
      return;
    }
    await TaskService().createSubTask(taskId: taskId, subTask: subTask).then((value) {
      _subtasks.add(value);
      state = LoadingState.loaded;
    }).catchError((error, stackTrace) {
      errorMessage = error.toString();
      state = LoadingState.error;
      return null;
    });
  }

  Future<void> updateSubtask({required Subtask subTask}) async {
    if (!subTask.isCreating) {
      state = LoadingState.loading;
      await TaskService().updateSubtask(subtask: subTask, taskId: taskId).then((value) {
        state = LoadingState.loaded;
      }).catchError((error, stackTrace) {
        // Just reload in case of an error
        load();
      });
    }
    notifyListeners();
  }
}
