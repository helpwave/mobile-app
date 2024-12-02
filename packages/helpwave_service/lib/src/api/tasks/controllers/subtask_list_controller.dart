import 'dart:async';
import 'package:helpwave_service/src/api/tasks/index.dart';
import 'package:helpwave_util/lists.dart';
import 'package:helpwave_util/loading.dart';
import 'package:helpwave_service/util.dart';


/// The Controller for managing [Subtask]s in a [Task]
///
/// Providing a [taskId] means loading and synchronising the [Subtask]s with
/// the backend while no [taskId] or a empty [String] means that the subtasks
/// only used locally
class SubtasksController extends LoadingChangeNotifier {
  /// The [Subtask]s
  List<Subtask> _subtasks = [];

  List<Subtask> get subtasks => [..._subtasks];

  set subtasks(List<Subtask> value) {
    _subtasks = value;
    notifyListeners();
  }

  bool get isCreating => taskId == null;

  String? taskId;

  SubtasksController({this.taskId, List<Subtask>? subtasks}) {
    load();
  }

  /// Loads a [Task]
  Future<void> load() async {
    loadTask() async {
      if (isCreating) {
        return;
      }
      final task = await TaskService().getTask(id: taskId);
      subtasks = task.subtasks;
    }

    loadHandler(future: loadTask());
  }

  /// Delete the [Subtask] by its index.dart int the list
  Future<void> deleteByIndex(int index) async {
    if (!subtasks.isIndexValid(index)) {
      return;
    }
    if (isCreating) {
      _subtasks.removeAt(index);
      notifyListeners();
      return;
    }
    await deleteById(subtasks[index].id!);
  }

  /// Delete the [Subtask] by the id
  Future<void> deleteById(String id) async {
    assert(!isCreating, "deleteById should not be used when creating a completely new Subtask list");
    deleteSubtask() async {
      await TaskService().deleteSubTask(subtaskId: id, taskId: taskId!).then((value) {
        if (value) {
          int index = _subtasks.indexWhere((element) => element.id == id);
          if (index != -1) {
            _subtasks.removeAt(index);
          }
        }
      });
    }

    loadHandler(future: deleteSubtask());
  }

  /// Add the [Subtask]
  Future<void> create(Subtask subTask) async {
    if (isCreating) {
      _subtasks.add(subTask);
      notifyListeners();
      return;
    }
    createSubtask() async {
      await TaskService().createSubTask(taskId: taskId!, subTask: subTask).then((value) {
        _subtasks.add(value);
      });
    }

    loadHandler(future: createSubtask());
  }

  Future<void> update({required Subtask subtask, int? index}) async {
    if (isCreating) {
      assert(
        index != null && index >= 0 && index < subtasks.length,
        "When creating a subtask list and updating a subtask, a index.dart for the subtask must be provided",
      );
      subtasks[index!] = subtask;
      return;
    }
    updateSubtask() async {
      assert(!subtask.isCreating, "To update a subtask on the server the subtask must have an id");
      await TaskService().updateSubtask(subtask: subtask, taskId: taskId!);
      int index = subtasks.indexWhere((element) => element.id == subtask.id);
      if (index != -1) {
        subtasks[index] = subtask;
      }
    }

    loadHandler(future: updateSubtask());
  }
}
