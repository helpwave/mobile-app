import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';

/// Page for Editing or Creating a [Task]
///
/// Code Example:
/// ```dart
/// TaskEditPage(
///   patientId: "734fd141-fd1889ab-1452",
///   roomName: "Room 24 E1",
///   task: {
///     "content": "- [ ] Example Checkbox",
///     "title": "Test Title",
///   },
/// ),
/// ```
class TaskEditPage extends StatefulWidget {
  // TODO replace later with [Task] data type
  /// The ID of the [Task]
  ///
  /// Here it is used to edit a existing [Task] or to be used as an Template which can be used to create a new Task
  final String taskID;

  const TaskEditPage({
    super.key,
    required this.taskID,
  });

  @override
  State<StatefulWidget> createState() => _TaskEditPageState();
}

class _TaskEditPageState extends State<TaskEditPage> {
  Future<Map<String, dynamic>> getTask() async {
    // TODO make ApiCall here with widget.taskID
    await Future.delayed(const Duration(milliseconds: 500));
    return {
      "id": "UUID",
      "name": "Task Name",
      "description": "Description",
      "subtasks": [
        {
          "name": "subtask1",
          "done": false,
        },
      ],
      "assignee": {
        "id": "UUID",
        "fullName": "string",
        "nickName": "string",
      },
      "bed": {
        "id": "UUID",
        "name": "Bed Nr. 6",
      },
      "patient": {
        "id": "UUID",
      },
      "room": {
        "id": "UUID",
        "name": "string",
      },
      "ward": {
        "id": "UUID",
        "name": "string",
      },
      "organization": {
        "id": "UUID",
        "longName": "string",
        "shortName": "string",
      },
    };
  }

  @override
  Widget build(BuildContext context) {
    const double padding = distanceDefault;
    Size buttonSize =
        Size(MediaQuery.of(context).size.width * 0.5 - padding, 50);

    return FutureBuilder(
        future: getTask(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return LoadErrorWidget(
              iconColor: Theme.of(context).colorScheme.primary,
              errorText: context.localization!.errorOnLoad,
            );
          }
          if (!snapshot.hasData) {
            return LoadingSpinner(
              text: context.localization!.loading,
              color: Theme.of(context).colorScheme.primary,
            );
          }

          Map<String, dynamic> task = snapshot.data[0];
          List<Map<String, dynamic>> subtasks = task["subtask"];
          List<Widget> subtaskWidgets = subtasks
              .map((subtask) => Row(
                    children: [
                      Checkbox(
                        value: subtask["done"],
                        onChanged: (value) => setState(() => subtask["done"]),
                      ),
                      const SizedBox(width: distanceDefault),
                      Flexible(
                        child: TextFormField(
                          onChanged: (value) => subtask["name"] = value,
                          initialValue: subtask["name"],
                        ),
                      ),
                    ],
                  ))
              .toList();
          return Scaffold(
            appBar: AppBar(title: Text(task["name"])),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: TextButton(
              style: ButtonStyle(
                shape: const MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(borderRadiusBig),
                      bottomLeft: Radius.circular(borderRadiusBig),
                    ),
                  ),
                ),
                minimumSize: MaterialStatePropertyAll(buttonSize),
              ),
              onPressed: () => setState(() {
                for (var element in subtasks) {
                  element["done"] = true;
                }
                // TODO also change status of entire task to done
                // TODO make api call here for update
              }),
              child: Text(context.localization!.finishAllTasks),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(padding),
              child: Column(
                children: [
                  Card(
                    margin: EdgeInsets.zero,
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.all(Radius.circular(paddingSmall))),
                    child: Padding(
                      padding: const EdgeInsets.all(paddingSmall),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("${context.localization!.room}:"),
                              Text(task["room"]["name"]),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("${context.localization!.bed}:"),
                              Text(task["bed"]["name"]),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  ...subtaskWidgets,
                  Center(
                    child: TextButton(
                      style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.transparent),
                      ),
                      onPressed: () => setState(() {
                        subtasks.add({"done": false, "name": ""});
                      }),
                      child: Text(context.localization!.addSubtask),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
