import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_widget/static_progress_indicator.dart';

/// Temporary data class for Task
// TODO replace this by grpc definition
class TaskDTO {


  bool isChecked;

  final Color statusColor;
  final double progress;
  final String title;
  final String subTitle;

  TaskDTO({
    required this.statusColor,
    required this.progress,
    required this.title,
    required this.subTitle,
    this.isChecked = false,
  });
}

/// A ListTile to Display a StaticProgressIndicator and Status
class TaskListTile extends StatefulWidget {
  /// Task data
  final TaskDTO task;

  /// Index for [ReorderableDragStartListener]
  final int index;

  /// onDismissed Callback for [Dismissible]
  final Function(DismissDirection?) onDismissed;

  /// confirmDismiss Callback for [Dismissible]
  final Future<bool> Function(DismissDirection direction) confirmDismiss;

  const TaskListTile({
    super.key,
    required this.task,
    required this.index,
    required this.onDismissed,
    required this.confirmDismiss
  });


  @override
  State<TaskListTile> createState() => _TaskListTileState();
}

class _TaskListTileState extends State<TaskListTile> {

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: widget.confirmDismiss,
        onDismissed: widget.onDismissed,
        key: ValueKey(widget.index),
        secondaryBackground: const ColoredBox(
            color: Colors.red,
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(paddingMedium),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: paddingSmall),
                      child: Text(context.localization!.delete),),
                    const Icon(Icons.delete)
                  ],
                ),
              ),
            )
        ),
        background: const ColoredBox(
          color: Colors.green,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: paddingMedium),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.done),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: paddingSmall),
                    child: Text(context.localization!.setDone),),
                ],
              ),
            )
          ),
        ),

        child: ListTile(
          leading: Transform.scale(
            scale: 1.5,
            child: Checkbox(
                value: widget.task.isChecked,
                shape: const CircleBorder(),
                fillColor: MaterialStateColor.resolveWith(
                    (states) => Colors.transparent),
                side: MaterialStateBorderSide.resolveWith((states) =>
                    BorderSide(width: 1.5, color: widget.task.statusColor)),
                checkColor: widget.task.statusColor,
                onChanged: (bool? value) {
                  //  TODO API-Call here
                  setState(() {
                    widget.task.isChecked = value!;
                  });
                }),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(paddingSmall),
                child: StaticProgressIndicator(
                  progress: widget.task.progress,
                  color: widget.task.statusColor,
                ),
              ),
              ReorderableDragStartListener(
                index: widget.index,
                child: const Icon(Icons.drag_indicator),
              ),
            ],
          ),
          title: Text(widget.task.title),
          subtitle: Text(widget.task.subTitle),
        )
    );
  }
}
