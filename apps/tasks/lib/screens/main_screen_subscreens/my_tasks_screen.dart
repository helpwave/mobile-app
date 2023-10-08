import 'package:flutter/material.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:tasks/dataclasses/patient.dart';
import 'package:tasks/dataclasses/subtask.dart';
import 'package:tasks/screens/settings_screen.dart';
import 'package:helpwave_widget/loading.dart';
import '../../components/task_expansion_tile.dart';
import '../../dataclasses/task.dart';

/// The Screen for showing all [Task]'s the [User] has in the current [ ]
class MyTasksScreen extends StatefulWidget {
  const MyTasksScreen({super.key});

  @override
  State<MyTasksScreen> createState() => _MyTasksScreenState();
}

class _MyTasksScreenState extends State<MyTasksScreen> {
  PatientMinimal patient = PatientMinimal(
    id: 'patient 1',
    name: "Victoria Schäfer",
  );

  Future<List<TaskWithPatient>> getTasks() async {
    return [
      TaskWithPatient(
        id: "task1",
        name: "Task name - 1",
        assignee: "",
        notes: "Some text describing the task",
        dueDate: DateTime.now().add(const Duration(days: 20)),
        status: TaskStatus.taskStatusInProgress,
        subtasks: [
          SubTask(id: "subtask 1", name: "Subtask 1"),
          SubTask(id: "subtask 2", name: "Subtask 2"),
        ],
        patient: patient,
      ),
      TaskWithPatient(
        id: "task2",
        name: "Task name - 2",
        assignee: "",
        notes: "Some text describing the task with an very very very long text",
        dueDate: DateTime.now().add(const Duration(hours: 10)),
        status: TaskStatus.taskStatusDone,
        subtasks: [
          SubTask(id: "subtask 1", name: "Subtask 1", isDone: true),
          SubTask(id: "subtask 2", name: "Subtask 2"),
        ],
        patient: patient,
      ),
      TaskWithPatient(
        id: "task3",
        name: "Task name - 3",
        assignee: "",
        notes: "Some text describing the task",
        dueDate: DateTime.now().add(const Duration(hours: 1)),
        status: TaskStatus.taskStatusTodo,
        subtasks: [
          SubTask(id: "subtask 1", name: "Subtask 1"),
          SubTask(id: "subtask 2", name: "Subtask 2", isDone: true),
        ],
        patient: patient,
      ),
      TaskWithPatient(
        id: "task4",
        name: "Task name - 4",
        assignee: "",
        notes: "Some text describing the task",
        dueDate: DateTime.now().subtract(const Duration(days: 20)),
        status: TaskStatus.taskStatusInProgress,
        subtasks: [
          SubTask(id: "subtask 1", name: "Subtask 1"),
          SubTask(id: "subtask 2", name: "Subtask 2", isDone: true),
          SubTask(id: "subtask 3", name: "Subtask 3", isDone: true),
        ],
        patient: patient,
      ),
      TaskWithPatient(
        id: "task5",
        name: "Task name - 5",
        assignee: "",
        notes: "Some text describing the task",
        status: TaskStatus.taskStatusInProgress,
        subtasks: [
          SubTask(id: "subtask 1", name: "Subtask 1"),
          SubTask(id: "subtask 2", name: "Subtask 2", isDone: true),
          SubTask(id: "subtask 3", name: "Subtask 3", isDone: true),
        ],
        patient: patient,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, ThemeModel themeNotifier, _) => Scaffold(
        appBar: AppBar(
          title: Text(context.localization!.myTasks),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.settings),
            )
          ],
        ),
        body: LoadingFutureBuilder(
          future: getTasks(),
          thenWidgetBuilder: (context, data) {
            List<TaskWithPatient> done = data.where((element) => element.status == TaskStatus.taskStatusDone).toList();
            List<TaskWithPatient> todo = data.where((element) => element.status == TaskStatus.taskStatusTodo).toList();
            List<TaskWithPatient> inProgress =
                data.where((element) => element.status == TaskStatus.taskStatusInProgress).toList();

            return ListView(children: [
              Theme(
                data: Theme.of(context).copyWith(
                  dividerColor: Colors.transparent,
                  listTileTheme: const ListTileThemeData(minLeadingWidth: 0, horizontalTitleGap: distanceSmall),
                ),
                child: Wrap(
                  spacing: distanceSmall,
                  // TODO change the color off the expansion tiles
                  children: [
                    TaskExpansionTile(
                      tasks: todo,
                      color: upcomingColor,
                      title: context.localization!.upcoming,
                    ),
                    TaskExpansionTile(
                      tasks: inProgress,
                      color: inProgressColor,
                      title: context.localization!.inProgress,
                    ),
                    TaskExpansionTile(
                      tasks: done,
                      color: doneColor,
                      title: context.localization!.done,
                    ),
                  ],
                ),
              ),
            ]);
          },
        ),
      ),
    );
  }
}

