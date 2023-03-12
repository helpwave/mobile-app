import 'package:flutter/material.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_widget/static_progress_indicator.dart';




/// Temporary data class for Task
// TODO replace this by grpc definition
class TaskDTO{
  final Color statusColor;
  final bool isChecked;
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
class TaskListTile extends StatefulWidget{

  /// Task data
  final TaskDTO task;

  /// Index for [ReorderableDragStartListener]
  final int index;

  const TaskListTile({
    super.key,
    required this.task,
    required this.index
  });


  @override
  State<TaskListTile> createState() => _TaskListTileState();
}



class _TaskListTileState extends State<TaskListTile> {

  bool? isChecked = false;

  @override
  void initState() {
    super.initState();

    isChecked = widget.task.isChecked;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Transform.scale(
        scale: 1.5,
        child: Checkbox(
            value: isChecked,
            shape: const CircleBorder(),
            fillColor:
            MaterialStateColor.resolveWith((states) => Colors.transparent),
            side: MaterialStateBorderSide.resolveWith(
                    (states) => BorderSide(width: 1.5, color: widget.task.statusColor)),
            checkColor: widget.task.statusColor,
            onChanged: (bool? value) {
              //  TODO API-Call here
              setState(() {
                isChecked = value;
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
            child: const Icon(Icons.drag_indicator),),
        ],
      ),
      title: Text(widget.task.title),
      subtitle: Text(widget.task.subTitle),
    );
  }
}
