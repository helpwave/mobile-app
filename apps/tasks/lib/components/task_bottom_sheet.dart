import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_widget/bottom_sheets.dart';
import 'package:helpwave_widget/loading.dart';
import 'package:helpwave_widget/text_input.dart';
import 'package:provider/provider.dart';
import 'package:tasks/components/assignee_select.dart';
import 'package:tasks/components/subtask_list.dart';
import 'package:tasks/components/visibility_select.dart';
import 'package:tasks/controllers/task_controller.dart';
import 'package:tasks/controllers/user_controller.dart';
import 'package:tasks/dataclasses/patient.dart';
import 'package:tasks/dataclasses/user.dart';
import '../dataclasses/task.dart';

/// A private [Widget] similar to a [ListTile] that has an icon and then to text
///
/// The [label] will be displayed over the [valueText]
class _SheetListTile extends StatelessWidget {
  /// The [label] of the [_SheetListTile]
  final String label;

  /// The [valueText] of the Tile
  ///
  /// [valueText] and [valueWidget] are exclusive
  final String? valueText;

  /// The [valueWidget] of the Tile
  ///
  /// [valueText] and [valueWidget] are exclusive
  final Widget? valueWidget;

  /// The icon to show to the left of the texts
  final IconData icon;

  /// The callback when the tile is clicked
  final Function()? onTap;

  const _SheetListTile({
    required this.label,
    this.valueText,
    this.valueWidget,
    required this.icon,
    this.onTap,
  }) : assert(
          (valueWidget == null && valueText != null) || (valueWidget != null && valueText == null),
          "Exactly one of parameter1 or parameter2 should be provided.",
        );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: iconSizeTiny,
        ),
        const SizedBox(width: paddingTiny),
        GestureDetector(
          onTap: onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12),
              ),
              valueText != null
                  ? Text(
                      valueText!,
                      style: editableValueTextStyle,
                    )
                  : valueWidget!,
            ],
          ),
        )
      ],
    );
  }
}

/// A [BottomSheet] showing all information about a [Task]
///
/// Not providing a [patient] means creating a new task
/// for which the [patient] must be chosen
///
/// When used as a [BottomSheet] make sure to set the isScrollControlled property
/// to true as seen in the example below to avoid an overflow
///
/// ```dart
///   showModalBottomSheet(
///     context: context,
///     isScrollControlled: true,
///     builder: (context) => TaskBottomSheet(),
///   );
/// ```
class TaskBottomSheet extends StatefulWidget {
  /// The [Task] used to display the information
  final Task task;

  /// The [patient] to which the task is assigned to
  ///
  /// Not providing a [patient] means creating a new task
  /// for which the [patient] must be chosen
  final PatientMinimal? patient;

  const TaskBottomSheet({super.key, required this.task, this.patient});

  @override
  State<StatefulWidget> createState() => _TaskBottomSheetState();
}

class _TaskBottomSheetState extends State<TaskBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskController(TaskWithPatient.fromTask(task: widget.task, patient: widget.patient)),
      child: BottomSheetBase(
        onClosing: () async {
          // TODO do saving or something when the dialog is closed
        },
        title: Consumer<TaskController>(
          builder: (context, taskController, child) => ClickableTextEdit(
            initialValue: taskController.task.name,
            onChanged: (value) {
              taskController.updateTask((task) {
                task.name = value;
              });
            },
            textAlign: TextAlign.center,
            textStyle: const TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: iconSizeTiny,
              fontFamily: "SpaceGrotesk",
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        builder: (context) => Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Consumer<TaskController>(builder:
                    // TODO move this to its own component
                    (context, taskController, __) {
                  List<Patient> patients = [];
                  return LoadingAndErrorWidget(
                    state: taskController.state,
                    child: taskController.hasInitialPatient
                        ? Text(taskController.patient.name)
                        : DropdownButton(
                            underline: const SizedBox(),
                            // removes the default underline
                            padding: EdgeInsets.zero,
                            isDense: true,
                            // TODO use the full list of possible assignees
                            items: patients
                                .map((patient) => DropdownMenuItem(value: patient, child: Text(patient.name)))
                                .toList(),
                            value: null,
                            onChanged: (value) {
                              setState(() {
                                // patient = value;
                              });
                            },
                          ),
                  );
                }),
              ),
              const SizedBox(height: distanceMedium),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // TODO change static assignee name
                  Consumer<TaskController>(builder: (context, taskController, __) {
                    return _SheetListTile(
                      icon: Icons.person,
                      label: context.localization!.assignedTo,
                      onTap: () => showModalBottomSheet(
                        context: context,
                        // TODO this doesn't work anymore
                        builder: (BuildContext context) => LoadingAndErrorWidget(
                          state: taskController.state,
                          child: AssigneeSelect(
                            selected: taskController.task.assignee,
                            onChanged: (assignee) {
                              taskController.changeAssignee(assigneeId: assignee.id);
                            },
                          ),
                        ),
                      ),
                      valueWidget: LoadingAndErrorWidget(
                        state: taskController.state,
                        child: taskController.task.assignee != null
                            ? ChangeNotifierProvider(
                                create: (context) => UserController(User.empty(id: taskController.task.assignee!)),
                                child: Consumer<UserController>(
                                  builder: (context, userController, __) => LoadingAndErrorWidget(
                                    state: userController.state,
                                    child: Text(
                                      userController.user.name,
                                      style: editableValueTextStyle,
                                    ),
                                  ),
                                ),
                              )
                            : Text(
                                context.localization!.unassigned,
                                style: editableValueTextStyle,
                              ),
                      ),
                    );
                  }),
                  Consumer<TaskController>(
                    builder: (context, taskController, __) => LoadingAndErrorWidget(
                      state: taskController.state,
                      child: _SheetListTile(
                        icon: Icons.access_time,
                        label: context.localization!.due,
                        // TODO localization and date formatting here
                        valueText: taskController.task.dueDate.toString(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: distanceSmall),
              Consumer<TaskController>(
                builder: (_, taskController, __) => LoadingAndErrorWidget(
                  state: taskController.state,
                  child: _SheetListTile(
                    icon: Icons.lock,
                    label: context.localization!.visibility,
                    valueWidget: VisibilitySelect(
                      isPublicVisible: taskController.task.isPublicVisible,
                      onChanged: (value) => taskController.changeIsPublic(isPublic: value),
                      isCreating: taskController.isCreating,
                      textStyle: editableValueTextStyle,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: distanceMedium),
              Text(
                context.localization!.notes,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: distanceTiny),
              Consumer<TaskController>(
                builder: (_, taskController, __) => LoadingAndErrorWidget(
                  state: taskController.state,
                  child: TextFormField(
                    initialValue: taskController.task.notes,
                    onChanged: taskController.changeNotes,
                    maxLines: 6,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(paddingMedium),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.0,
                        ),
                      ),
                      hintText: context.localization!.yourNotes,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: distanceBig),
              // TODO add callback here for task creation to update the Task accordingly
              Consumer<TaskController>(
                builder: (_, taskController, __) => LoadingAndErrorWidget(
                  state: taskController.state,
                  child: SubtaskList(
                    taskId: taskController.task.id,
                    subtasks: taskController.task.subtasks,
                    onChange: (subtasks) {
                      if (taskController.task.isCreating) {
                        taskController.task.subtasks = subtasks;
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
