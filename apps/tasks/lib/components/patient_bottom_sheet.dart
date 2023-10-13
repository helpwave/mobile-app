import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_theme/theme.dart';
import 'package:helpwave_widget/lists.dart';
import 'package:provider/provider.dart';
import 'package:tasks/components/task_bottom_sheet.dart';
import 'package:tasks/components/task_expansion_tile.dart';
import 'package:tasks/dataclasses/patient.dart';
import 'package:tasks/dataclasses/subtask.dart';
import 'package:tasks/dataclasses/task.dart';

/// A [BottomSheet] for showing [Patient] information and [Task]s for that [Patient]
class PatientBottomSheet extends StatefulWidget {
  /// The identifier of the [Patient]
  final String patentId;

  const PatientBottomSheet({Key? key, required this.patentId}) : super(key: key);

  @override
  State<PatientBottomSheet> createState() => _PatientBottomSheetState();
}

class _PatientBottomSheetState extends State<PatientBottomSheet> {
  String? selectedRoom;
  final rooms = ["Room 2 - Bed 5"];
  Map<TaskStatus, List<TaskWithPatient>> tasks = {
    TaskStatus.taskStatusTodo: [
      TaskWithPatient(
        id: "task1",
        name: "Task name - 1",
        assignee: "",
        notes: "Some text describing the task",
        dueDate: DateTime.now().add(const Duration(days: 20)),
        status: TaskStatus.taskStatusTodo,
        subtasks: [
          SubTask(id: "subtask 1", name: "Subtask 1"),
          SubTask(id: "subtask 2", name: "Subtask 2"),
        ],
        patient: PatientMinimal(id: "patientID", name: "Patient"),
      ),
    ],
    TaskStatus.taskStatusInProgress: [
      TaskWithPatient(
        id: "task2",
        name: "Task name - 2",
        assignee: "",
        notes: "Some text describing the task",
        dueDate: DateTime.now().add(const Duration(days: 20)),
        status: TaskStatus.taskStatusInProgress,
        subtasks: [
          SubTask(id: "subtask 1", name: "Subtask 1"),
          SubTask(id: "subtask 2", name: "Subtask 2"),
        ],
        patient: PatientMinimal(id: "patientID", name: "Patient"),
      ),
    ],
    TaskStatus.taskStatusDone: [
      TaskWithPatient(
        id: "task3",
        name: "Task name - 3",
        assignee: "",
        notes: "Some text describing the task",
        dueDate: DateTime.now().add(const Duration(days: 20)),
        status: TaskStatus.taskStatusTodo,
        subtasks: [
          SubTask(id: "subtask 1", name: "Subtask 1"),
          SubTask(id: "subtask 2", name: "Subtask 2"),
        ],
        patient: PatientMinimal(id: "patientID", name: "Patient"),
      ),
    ],
  };

  // TODO either get this from the id or have it already provided
  PatientMinimal patient = PatientMinimal(id: "patientID", name: "Patient");

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    List<TaskWithPatient> todo = tasks[TaskStatus.taskStatusTodo] ?? [];
    List<TaskWithPatient> inProgress = tasks[TaskStatus.taskStatusInProgress] ?? [];
    List<TaskWithPatient> done = tasks[TaskStatus.taskStatusDone] ?? [];
    return Consumer<ThemeModel>(
      builder: (BuildContext context, ThemeModel themeNotifier, __) {
        return SingleChildScrollView(
          child: BottomSheet(
            onClosing: () {
              // TODO handle this
            },
            builder: (BuildContext ctx) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: paddingMedium),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              constraints: const BoxConstraints(maxWidth: iconSizeTiny, maxHeight: iconSizeTiny),
                              padding: EdgeInsets.zero,
                              iconSize: iconSizeTiny,
                              onPressed: () => Navigator.maybePop(context),
                              icon: const Icon(Icons.close_rounded),
                            ),
                            const Flexible(
                              child: Padding(
                                padding: EdgeInsets.only(top: paddingOffset),
                                child: Text(
                                  "Patient 1", // TODO: replace with real data
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: fontSizeBig,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: iconSizeTiny),
                          ],
                        ),
                        Center(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              padding: EdgeInsets.zero,
                              isDense: true,
                              value: selectedRoom,
                              items: rooms
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(color: Colors.grey),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  selectedRoom = value;
                                });
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Text(
                    context.localization!.notes,
                    style: const TextStyle(fontSize: fontSizeBig, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: distanceSmall),
                  TextFormField(
                    initialValue: "", // TODO: replace with real data
                    maxLines: 6,
                    keyboardType: TextInputType.multiline,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: paddingMedium),
                    child: AddList(
                      maxHeight: width * 0.5,
                      items: [todo, inProgress, done],
                      itemBuilder: (_, index, taskList) {
                        if (taskList.isEmpty) {
                          return null;
                        }
                        if (index == 0) {
                          return TaskExpansionTile(
                            tasks: taskList,
                            title: context.localization!.upcoming,
                            color: upcomingColor,
                          );
                        }
                        if (index == 2) {
                          return TaskExpansionTile(
                            tasks: taskList,
                            title: context.localization!.inProgress,
                            color: inProgressColor,
                          );
                        }
                        return TaskExpansionTile(
                          tasks: taskList,
                          title: context.localization!.done,
                          color: doneColor,
                        );
                      },
                      title: Text(
                        context.localization!.tasks,
                        style: const TextStyle(fontSize: fontSizeBig, fontWeight: FontWeight.bold),
                      ),
                      // TODO use return value to add it to task list or force a refetch
                      onAdd: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => TaskBottomSheet(task: Task.empty, patient: patient),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: paddingMedium),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: width * 0.4,
                          child: TextButton(
                            onPressed: () {
                              // TODO: implement unassign
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(borderRadiusMedium),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all(inProgressColor),
                            ),
                            child: Text(context.localization!.unassigne),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: paddingSmall),
                          child: SizedBox(
                            width: width * 0.4,
                            child: TextButton(
                              onPressed: () {
                                // TODO: implement discharge
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(borderRadiusMedium),
                                  ),
                                ),
                                backgroundColor: MaterialStateProperty.all(negativeColor),
                              ),
                              child: Text(context.localization!.discharge),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
