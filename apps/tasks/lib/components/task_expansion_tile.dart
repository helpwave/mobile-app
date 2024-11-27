import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_theme/util.dart';
import 'package:helpwave_widget/bottom_sheets.dart';
import 'package:helpwave_widget/shapes.dart';
import 'package:provider/provider.dart';
import 'package:tasks/components/bottom_sheet_pages/task_bottom_sheet.dart';
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

  const TaskExpansionTile({super.key, required this.tasks, required this.color, required this.title});

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
              (task) => GestureDetector(
                onTap: () {
                  context.pushModal(
                    context: context,
                    builder: (context) => TaskBottomSheet(task: task, patient: task.patient),
                  ).then((_) {
                    try {
                      if(!context.mounted) {
                        return;
                      }
                      // TODO This widget is used in contexts without the AssignedTasksController leading to issues
                      AssignedTasksController controller = Provider.of<AssignedTasksController>(context, listen: false);
                      controller.load();
                    } catch (e) {
                      if (kDebugMode) {
                        print(e);
                      }
                    }
                  });
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
      ),
    );
  }
}
