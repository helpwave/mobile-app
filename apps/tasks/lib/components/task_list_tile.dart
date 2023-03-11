import 'package:flutter/material.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_widget/static_progress_indicator.dart';

/// A ListTile to Display a StaticProgressIndicator and Status
class TaskListTile extends StatefulWidget{
  const TaskListTile({
    super.key,
    required this.statusColor,
    required this.progress,
    required this.title,
    required this.subTitle,
    this.isChecked = false
  });

  /// The [Color] of [Checkbox] and [StaticProgressIndicator]
  final Color statusColor;

  /// The default value of status [Checkbox]
  final bool? isChecked;

  /// Progress as a Percentage between 0.0 to 1.0
  final double progress;

  /// The Title for [ListTile]
  final String title;

  /// The SubTitle for [ListTile]
  final String subTitle;

  @override
  State<TaskListTile> createState() => _TaskListTileState();
}



class _TaskListTileState extends State<TaskListTile> {

  bool? isChecked = false;

  @override
  void initState() {
    super.initState();

    isChecked = widget.isChecked;
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
                    (states) => BorderSide(width: 1.5, color: widget.statusColor)),
            checkColor: widget.statusColor,
            onChanged: (bool? value) {
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
              progress: widget.progress,
              color: widget.statusColor,
            ),
          ),
          const Icon(Icons.drag_indicator),
        ],
      ),
      title: Text(widget.title),
      subtitle: Text(widget.subTitle),
    );
  }
}
