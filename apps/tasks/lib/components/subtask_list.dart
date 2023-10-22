import 'dart:math';
import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_widget/lists.dart';
import 'package:tasks/dataclasses/subtask.dart';
import 'package:tasks/dataclasses/task.dart';

/// A [Widget] for displaying an updating a [List] of [SubTask]s
class SubtaskList extends StatefulWidget {
  // TODO change this here to make an exclusive choice between taskId and subtasks
  // Subtasks should only be used for Task creation and taskId when the task already exists
  /// The identifier of the [Task] to which all of these [SubTask]s belong
  final String taskId;

  /// The [List] of initial subtasks
  final List<SubTask> subtasks;

  const SubtaskList({super.key, required this.taskId, required this.subtasks});

  @override
  State<StatefulWidget> createState() => _SubtaskListState();
}

class _SubtaskListState extends State<SubtaskList> {
  List<SubTask> subtasks = [];

  @override
  void initState() {
    subtasks = [...widget.subtasks];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const double sizeForSubtasks = 200;

    return AddList(
      maxHeight: sizeForSubtasks,
      items: subtasks,
      title: Text(
        context.localization!.subtasks,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      onAdd: () {
        // TODO insert grpc request here
        setState(() {
          subtasks = [
            ...subtasks,
            SubTask(id: Random().nextDouble().toString(), name: "Subtask ${subtasks.length + 1}"),
          ];
        });
      },
      itemBuilder: (_, __, subtask) => ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(subtask.name),
        leading: Checkbox(
          visualDensity: VisualDensity.compact,
          value: subtask.isDone,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(iconSizeSmall),
          ),
          onChanged: (value) {
            // TODO insert grpc request here
            setState(() {
              subtask.isDone = value ?? false;
            });
          },
        ),
        trailing: GestureDetector(
          onTap: () {
            // TODO insert grpc request here
            setState(() {
              subtasks = subtasks.where((element) => element.id != subtask.id).toList();
            });
          },
          child: Text(
            context.localization!.delete,
            style: const TextStyle(color: negativeColor),
          ),
        ),
      ),
    );
  }
}
