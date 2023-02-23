import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_widget/dialog.dart';
import 'package:helpwave_widget/loading.dart';

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
  List<TextEditingController> textEditingControllers = [];
  Map<String, dynamic>? task;
  bool hasError = false;

  getTask() async {
    // TODO make ApiCall here with widget.taskID
    // set hasError to true in case of an error
    await Future.delayed(const Duration(milliseconds: 500));
    task = {
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
        "name": "Blue Room",
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
    for (var _ in (task!["subtasks"] as List<Map<String, dynamic>>)) {
      textEditingControllers.add(TextEditingController());
    }
    setState(() {});
  }

  addEntry() {
    // Type cast needed, otherwise type error on add to list
    // ignore: unnecessary_cast
    Map<String, dynamic> subtask = {
      "name": "",
      "done": false,
    } as Map<String, dynamic>;
    task!["subtasks"].add(subtask);
    textEditingControllers.add(TextEditingController());
    setState(() {});
  }

  removeEntry(Map<String, dynamic> subtask) {
    task!["subtasks"].remove(subtask);
    TextEditingController controller = textEditingControllers.removeLast();
    controller.dispose();
    setState(() {});
  }

  @override
  void initState() {
    getTask();
    super.initState();
  }

  @override
  void dispose() {
    for (var element in textEditingControllers) {
      element.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double padding = distanceDefault;
    Size buttonSize = Size(MediaQuery.of(context).size.width - 2 * padding, 50);

    return Builder(builder: (context) {
      if (hasError) {
        return Scaffold(
          body: LoadErrorWidget(
            iconColor: Theme.of(context).colorScheme.primary,
            errorText: context.localization!.errorOnLoad,
          ),
        );
      }
      if (task == null) {
        return Scaffold(
          body: LoadingSpinner(
            text: context.localization!.loading,
            color: Theme.of(context).colorScheme.primary,
          ),
        );
      }

      List<Map<String, dynamic>> subtasks = task!["subtasks"];
      List<Widget> subtaskWidgets = [];
      for (int i = 0; i < subtasks.length; i++) {
        Map<String, dynamic> subtask = subtasks[i];
        TextEditingController textEditingController = textEditingControllers[i];
        textEditingController.text = subtask["name"];
        subtaskWidgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: distanceSmall),
            child: ListTile(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(borderRadiusBig)),
              ),
              minLeadingWidth: iconSizeSmall,
              horizontalTitleGap: distanceSmall,
              contentPadding: EdgeInsets.zero,
              leading: Checkbox(
                visualDensity: VisualDensity.compact,
                value: subtask["done"],
                onChanged: (value) => setState(() {
                  subtask["done"] = value;
                }),
              ),
              title: TextFormField(
                decoration: const InputDecoration(contentPadding: EdgeInsets.all(distanceSmall)),
                maxLines: null,
                onChanged: (value) => subtask["name"] = value,
                controller: textEditingController,
              ),
              trailing: IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: negativeColor,
                  size: iconSizeSmall,
                ),
                onPressed: () {
                  if (subtask["name"] == "") {
                    removeEntry(subtask);
                    return;
                  }
                  showDialog(
                    context: context,
                    builder: (context) => AcceptDialog(
                      titleText: "Delete Subtask?",
                      content: Text(subtask["name"]),
                    ),
                  ).then((value) {
                    if (value == true) {
                      removeEntry(subtask);
                    }
                  });
                },
              ),
            ),
          ),
        );
      }
      return Scaffold(
        floatingActionButton: Visibility(
          visible: MediaQuery.of(context).viewInsets.bottom == 0,
          child: TextButton(
            style: ButtonStyle(
              shape: const MaterialStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(borderRadiusBig)),
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
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: AppBar(title: Text(task!["name"])),
        body: Column(
          children: [
            Card(
              margin: const EdgeInsets.symmetric(horizontal: padding, vertical: 0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(paddingSmall)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(paddingSmall),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${context.localization!.room}:"),
                        Text(task!["room"]["name"]),
                      ],
                    ),
                    const SizedBox(
                      height: distanceSmall,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${context.localization!.bed}:"),
                        Text(task!["bed"]["name"]),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(padding),
                child: Column(
                  children: [
                    ...subtaskWidgets,
                    Center(
                      child: TextButton.icon(
                        icon: Icon(
                          Icons.add,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        style: ButtonStyle(
                          foregroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.onBackground),
                          backgroundColor: const MaterialStatePropertyAll(Colors.transparent),
                          shape: const MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(paddingSmall),
                              ),
                            ),
                          ),
                        ),
                        onPressed: addEntry,
                        label: Text(context.localization!.addSubtask),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
