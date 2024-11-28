import 'package:flutter/material.dart';
import 'package:helpwave_service/tasks.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_theme/util.dart';
import 'package:helpwave_widget/bottom_sheets.dart';
import 'package:helpwave_widget/navigation.dart';
import 'package:provider/provider.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:tasks/components/bottom_sheet_pages/task_bottom_sheet.dart';
import 'package:tasks/components/task_expansion_tile.dart';
import 'package:helpwave_widget/loading.dart';

/// The Screen for showing all [Task]'s the [User] has assigned to them
class MyTasksScreen extends StatefulWidget {
  const MyTasksScreen({super.key});

  @override
  State<MyTasksScreen> createState() => _MyTasksScreenState();
}

class _MyTasksScreenState extends State<MyTasksScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AssignedTasksController(),
      child: Consumer<AssignedTasksController>(
        builder: (BuildContext context, AssignedTasksController tasksController, Widget? child) {
          complete(Task task, AssignedTasksController controller) {
            controller.updateTask(task.copyWith(status: TaskStatus.done));
          }

          openEdit(TaskWithPatient task) {
            context.pushModal(context: context, builder: (context) => NavigationOutlet(initialValue: TaskBottomSheet(task: task, patient: task.patient)));
          }

          return LoadingAndErrorWidget(
            state: tasksController.state,
            child: ListView(children: [
              Theme(
                data: context.theme.copyWith(
                  dividerColor: Colors.transparent,
                  listTileTheme: const ListTileThemeData(minLeadingWidth: 0, horizontalTitleGap: distanceSmall),
                ),
                child: Wrap(
                  spacing: distanceSmall,
                  children: [
                    TaskExpansionTile(
                      tasks: tasksController.todo,
                      color: upcomingColor,
                      title: context.localization.upcoming,
                      onComplete: (task) => complete(task,tasksController),
                      onOpenEdit: (task) => openEdit(task),
                    ),
                    TaskExpansionTile(
                      tasks: tasksController.inProgress,
                      color: inProgressColor,
                      title: context.localization.inProgress,
                      onComplete: (task) => complete(task,tasksController),
                      onOpenEdit: (task) => openEdit(task),
                    ),
                    TaskExpansionTile(
                      tasks: tasksController.done,
                      color: doneColor,
                      title: context.localization.done,
                      onComplete: (task) => complete(task,tasksController),
                      onOpenEdit: (task) => openEdit(task),
                    ),
                  ],
                ),
              ),
            ]),
          );
        },
      ),
    );
  }
}
