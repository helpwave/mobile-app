import 'package:flutter/material.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_widget/shapes.dart';
import 'package:tasks/components/task_bottom_sheet.dart';
import 'package:tasks/components/task_card.dart';
import '../dataclasses/task.dart';

/// A [ExpansionTile] for showing a [List] of [Task]s
///
/// Shows the title, which should be the category for the [Task] list
/// and can be clicked to show the tasks
class TaskExpansionTile extends StatelessWidget {
  /// The [List] of [Task]s
  final List<TaskWithPatient> tasks;

  /// The [Color] of the leading dot
  final Color color;

  /// The size of the leading dot
  final double circleSize = 8;

  /// The [title] of the Tile
  final String title;

  const TaskExpansionTile({super.key, required this.tasks, required this.color, required this.title});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      textColor: color,
      collapsedTextColor: color,
      initiallyExpanded: true,
      leading: SizedBox(
        width: circleSize,
        child: Center(
          child: Circle(
            color: color,
            diameter: circleSize,
          ),
        ),
      ),
      title: Text("$title (${tasks.length})"),
      children: tasks
          .map(
            (task) => GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => TaskBottomSheet(task: task, patient: task.patient),
                  isScrollControlled: true,
                );
              },
              child: TaskCard(
                task: task,
                margin: const EdgeInsets.symmetric(
                  horizontal: paddingSmall,
                  vertical: paddingTiny,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
