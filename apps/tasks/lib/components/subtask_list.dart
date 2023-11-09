import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_widget/lists.dart';
import 'package:provider/provider.dart';
import 'package:tasks/controllers/subtask_list_controller.dart';
import 'package:tasks/dataclasses/subtask.dart';
import 'package:tasks/dataclasses/task.dart';

/// A [Widget] for displaying an updating a [List] of [SubTask]s
class SubtaskList extends StatelessWidget {
  /// The identifier of the [Task] to which all of these [SubTask]s belong
  final String taskId;

  /// The [List] of initial subtasks
  final List<SubTask> subtasks;

  /// The callback when the [subtasks] are changed
  ///
  /// Should **only** be used when [taskId == ""]
  final void Function(List<SubTask> subtasks) onChange;

  const SubtaskList({
    super.key,
    this.taskId = "",
    this.subtasks = const [],
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    const double sizeForSubtasks = 200;

    return ChangeNotifierProvider(
      create: (context) => SubtasksController(taskId: taskId, subtasks: subtasks),
      child: Consumer<SubtasksController>(builder: (context, subtasksController, __) {
        return AddList(
          maxHeight: sizeForSubtasks,
          items: subtasksController.subtasks,
          title: Text(
            context.localization!.subtasks,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          onAdd: () => subtasksController
              .add(SubTask(id: "", name: "Subtask ${subtasksController.subtasks.length + 1}"))
              .then((_) => onChange(subtasksController.subtasks)),
          itemBuilder: (context, _, subtask) => ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(subtask.name),
            leading: Checkbox(
              visualDensity: VisualDensity.compact,
              value: subtask.isDone,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(iconSizeSmall),
              ),
              onChanged: (value) => subtasksController
                  .changeStatus(subTask: subtask, value: value ?? false)
                  .then((value) => onChange(subtasksController.subtasks)),
            ),
            trailing: GestureDetector(
              onTap: () {
                subtasksController
                    .deleteByIndex(subtasksController.subtasks.indexWhere((element) => element.id == subtask.id))
                    .then((value) => onChange(subtasksController.subtasks));
              },
              child: Text(
                context.localization!.delete,
                style: const TextStyle(color: negativeColor),
              ),
            ),
          ),
        );
      }),
    );
  }
}
