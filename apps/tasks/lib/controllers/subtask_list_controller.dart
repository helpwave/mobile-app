import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:helpwave_widget/loading.dart';
import 'package:tasks/dataclasses/subtask.dart';
import 'package:tasks/services/task_svc.dart';

/// The Controller for managing [Subtask]s in a [Task]
///
/// Providing a [taskId] means loading and synchronising the [SubTask]s with
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
  List<SubTask> _subtasks = [];

  List<SubTask> get subtasks => [..._subtasks];

  set subtasks(List<SubTask> value) {
    _subtasks = value;
    notifyListeners();
  }

  bool _isCreating = false;

  bool get isCreating => _isCreating;

  String taskId;

  /// Only valid in case [state] == [LoadingState.error]
  String errorMessage = "";

  SubtasksController({this.taskId = "", List<SubTask>? subtasks}) {
    _isCreating = taskId == "";
    if (!isCreating) {
      load();
    } else {
      state = LoadingState.unspecified;
    }
  }

  Future<void> load() async {
    state = LoadingState.loading;
  }

  /// Delete the subtask by the index
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
    await TaskService().deleteSubTask(id: subtasks[index].id).then((value) {
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

  /// Delete the [SubTask] by the id
  Future<void> delete(String id) async {
    assert(!isCreating,
        "delete should not be used when creating a completely new SubTask list");
    int index = _subtasks.indexWhere((element) => element.id == id);
    if (index != -1) {
      deleteByIndex(index);
    }
  }

  /// Add the [SubTask]
  Future<void> add(SubTask subTask) async {
    if (isCreating) {
      _subtasks.add(subTask);
      notifyListeners();
      return;
    }
    TaskService().addSubTask(taskId: taskId, subTask: subTask).then((value) {
      _subtasks.add(value);
      state = LoadingState.loaded;
    }).catchError((error, stackTrace) {
      errorMessage = error.toString();
      state = LoadingState.error;
      return null;
    });
  }
}
