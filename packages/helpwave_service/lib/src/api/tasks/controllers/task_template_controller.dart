import 'dart:async';
import 'package:helpwave_service/src/api/tasks/index.dart';
import 'package:helpwave_util/lists.dart';
import 'package:helpwave_util/loading.dart';

/// The Controller for managing a [TaskTemplate]
///
/// Providing a [templateId] means loading and synchronising the [TaskTemplate]s with
/// the backend while no [templateId] or a empty [String] means that the [TaskTemplate] is
/// only used locally
class TaskTemplateController extends LoadingChangeNotifier {
  /// The [TaskTemplate]
  TaskTemplate? _taskTemplate;

  List<TaskTemplateSubtask> get subtasks => _taskTemplate?.subtasks ?? [];

  TaskTemplate get taskTemplate {
    return _taskTemplate ?? TaskTemplate(name: "");
  }

  set taskTemplate(TaskTemplate value) {
    _taskTemplate = value;
    notifyListeners();
  }

  bool get isCreating => templateId == null;

  String? templateId;

  TaskTemplateController({this.templateId, TaskTemplate? taskTemplate}) {
    assert(taskTemplate == null || taskTemplate.id == templateId, "Either provide only the templateId or provide an "
        "taskTemplate that has the same identifier");
    if (taskTemplate != null) {
      _taskTemplate = taskTemplate;
      templateId = taskTemplate.id;
    }
    load();
  }

  /// Loads the [TaskTemplate]s
  Future<void> load() async {
    loadOp() async {
      if (isCreating) {
        return;
      }
      taskTemplate = await TaskTemplateService().get(id: templateId!);
    }

    loadHandler(future: loadOp());
  }

  /// Add the [TaskTemplate]
  Future<void> create() async {
    assert(isCreating);
    createOp() async {
      await TaskTemplateService().create(template: taskTemplate).then((value) {
        templateId = value.id;
        taskTemplate = value;
      });
      await load(); // because the template returned by create does not have the subtask ids
    }

    loadHandler(future: createOp());
  }

  Future<void> update({String? name, String? description}) async {
    updateOp() async {
      if (isCreating) {
        _taskTemplate = taskTemplate.copyWith(name: name, description: description);
        return;
      }
      await TaskTemplateService().update(id: taskTemplate.id!, name: name, description: description);
      _taskTemplate = taskTemplate.copyWith(name: name, description: description);
      notifyListeners();
    }

    loadHandler(future: updateOp());
  }

  /// Delete the [TaskTemplate] by the id
  Future<void> delete() async {
    assert(!isCreating, "deleteById should not be used when creating a completely new Subtask list");
    deleteOp() async {
      await TaskTemplateService().delete(id: taskTemplate.id!);
    }

    loadHandler(future: deleteOp());
  }

  /// Add the [TaskTemplateSubtask]
  ///
  /// **Only use** this when the [TaskTemplate] was **loaded or an initial [TaskTemplate]** is provided
  Future<void> createSubtask(TaskTemplateSubtask subtask) async {
    assert(_taskTemplate != null);
    createOp() async {
      if (isCreating) {
        _taskTemplate = _taskTemplate!.copyWith(subtasks: [..._taskTemplate!.subtasks, subtask]);
        return;
      }
      await TaskTemplateService().createSubtask(value: subtask).then((value) {
        _taskTemplate = _taskTemplate!.copyWith(subtasks: [..._taskTemplate!.subtasks, value]);
      });
    }

    loadHandler(future: createOp());
  }

  /// Updates the [TaskTemplateSubtask] by its index.dart in the [List]
  ///
  /// **Only use** this when the [TaskTemplate] was **loaded or an initial [TaskTemplate]** is provided
  Future<void> updateSubtaskByIndex({required int index, String? name}) async {
    assert(_taskTemplate != null && _taskTemplate!.subtasks.isIndexValid(index));
    updateOp() async {
      if (isCreating) {
        _taskTemplate = _taskTemplate!.copyWith(
          subtasks: _taskTemplate!.subtasks
              .mapWithIndex((element, index1) => index == index1 ? element.copyWith(name: name) : element),
        );
        return;
      }
      final subtaskId = _taskTemplate!.subtasks[index].id!;
      await TaskTemplateService().updateSubtask(id: subtaskId, name: name);
      _taskTemplate = _taskTemplate!.copyWith(
        subtasks: _taskTemplate!.subtasks
            .mapWithIndex((element, index1) => index == index1 ? element.copyWith(name: name) : element),
      );
    }

    loadHandler(future: updateOp());
  }

  /// Updates the [TaskTemplateSubtask]
  ///
  /// **Only use** this when the [TaskTemplate] was **loaded and exists** on the server
  Future<void> updateSubtask({required String id, String? name}) async {
    assert(_taskTemplate != null && !isCreating);
    updateOp() async {
      await TaskTemplateService().updateSubtask(id: id, name: name);
      _taskTemplate = _taskTemplate!.copyWith(
        subtasks: _taskTemplate!.subtasks.map((element) => id == element.id ? element.copyWith(name: name) : element)
            .toList(),
      );
    }
    loadHandler(future: updateOp());
  }

  /// Delete the [TaskTemplate] by the index.dart in the [List]
  Future<void> deleteSubtaskByIndex({required int index}) async {
    assert(_taskTemplate != null && _taskTemplate!.subtasks.isIndexValid(index));
    deleteOp() async {
      if (isCreating) {
        _taskTemplate = _taskTemplate!.copyWith(
          subtasks: [..._taskTemplate!.subtasks]..removeAt(index),
        );
        return;
      }
      final subtaskId = _taskTemplate!.subtasks[index].id!;
      await TaskTemplateService().deleteSubtask(id: subtaskId);
      _taskTemplate = _taskTemplate!.copyWith(
        subtasks: [..._taskTemplate!.subtasks]..removeAt(index),
      );
    }

    loadHandler(future: deleteOp());
  }

  /// Delete the [TaskTemplate] by the id
  Future<void> deleteSubtask({required String id}) async {
    assert(_taskTemplate != null && !isCreating);
    deleteOp() async {
      await TaskTemplateService().deleteSubtask(id: id);
      _taskTemplate = _taskTemplate!.copyWith(
        subtasks: _taskTemplate!.subtasks.where((element) => id != element.id).toList(),
      );
    }

    loadHandler(future: deleteOp());
  }
}
