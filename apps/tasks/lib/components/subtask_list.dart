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
            // Open a BottomSheet to get the new subtask-name as input
            onTap: () => showDialog<String>(
              context: context,
              builder: (context) => SubTaskChangeDialog(initialName: subtask.name),
            ).then((value) {
              if (value != null) {
                subtask.name = value;
                subtasksController.updateSubtask(subTask: subtask);
              }
            }),
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

/// A [BottomSheet] for updating a subtask
class SubTaskChangeDialog extends StatefulWidget {
  /// The initial value for the [TextFormField] to change the name
  final String initialName;

  const SubTaskChangeDialog({super.key, required this.initialName});

  @override
  State<StatefulWidget> createState() => _SubTaskChangeDialogState();
}

class _SubTaskChangeDialogState extends State<SubTaskChangeDialog> {
  String? updatedName;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(borderRadiusMedium))),
      child: Padding(
        padding: const EdgeInsets.all(distanceMedium),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                context.localization!.changeSubtask,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: distanceDefault),
            TextFormField(
              decoration: InputDecoration(labelText: context.localization!.subtaskName),
              initialValue: widget.initialName,
              onChanged: (value) => updatedName = value,
            ),
            const SizedBox(height: distanceDefault),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context, null),
                  style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(negativeColor)),
                  child: Text(context.localization!.cancel),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, updatedName),
                  style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(primaryColor)),
                  child: Text(context.localization!.update),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
