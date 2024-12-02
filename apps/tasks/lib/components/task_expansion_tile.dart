import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_theme/util.dart';
import 'package:helpwave_widget/shapes.dart';
import 'package:tasks/components/task_card.dart';
import 'package:helpwave_service/tasks.dart';

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

  /// The [Function] called when the [TaskWithPatient] should be completed
  final Function(TaskWithPatient task) onComplete;

  /// The [Function] called when the [TaskWithPatient] should be edited
  final Function(TaskWithPatient task) onOpenEdit;

  const TaskExpansionTile({
    super.key,
    required this.tasks,
    required this.color,
    required this.title,
    required this.onComplete,
    required this.onOpenEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: context.theme.copyWith(
        dividerColor: Colors.transparent,
        listTileTheme: context.theme.listTileTheme.copyWith(minLeadingWidth: 0, horizontalTitleGap: paddingSmall),
      ),
      child: ExpansionTile(
        iconColor: context.theme.colorScheme.primary.withOpacity(0.8),
        collapsedIconColor: context.theme.colorScheme.primary.withOpacity(0.8),
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
              (task) => Dismissible(
                key: Key(task.id ?? "undefined"),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.endToStart) {
                    onComplete(task);
                  } else {
                    onOpenEdit(task);
                  }
                  return false;
                },
                background: Padding(
                  padding: const EdgeInsets.all(paddingTiny),
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(borderRadiusMedium),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: paddingMedium),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        context.localization.edit,
                      ),
                    ),
                  ),
                ),
                secondaryBackground: Padding(
                  padding: const EdgeInsets.all(paddingTiny),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(borderRadiusSmall),
                      color: positiveColor,
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                          padding: const EdgeInsets.only(right: paddingMedium),
                          child: Text(
                            context.localization.completed,
                          )),
                    ),
                  ),
                ),
                child: TaskCard(
                  task: task,
                  margin: const EdgeInsets.symmetric(
                    horizontal: paddingSmall,
                    vertical: paddingTiny,
                  ),
                  onComplete: () => onComplete(task),
                  onTap: () => onOpenEdit(task),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
