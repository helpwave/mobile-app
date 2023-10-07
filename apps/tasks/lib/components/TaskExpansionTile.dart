import 'package:flutter/material.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_widget/shapes.dart';
import 'package:tasks/components/task_card.dart';

import '../dataclasses/task.dart';

class TaskExpansionTile extends StatelessWidget {
  final List<TaskWithPatient> tasks;
  final Color color;
  final double circleSize = 8;
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
            (task) => TaskCard(
          task: task,
          margin: const EdgeInsets.symmetric(
            horizontal: paddingSmall,
            vertical: paddingTiny,
          ),
        ),
      )
          .toList(),
    );
  }
}
