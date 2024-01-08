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
import 'package:tasks/services/patient_svc.dart';
import '../controllers/assignee_select_controller.dart';
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
                      style: editableValueTextStyle(context),
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
///   context.pushModal(
///     context: context,
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
      create: (context) =>
          TaskController(TaskWithPatient.fromTaskAndPatient(task: widget.task, patient: widget.patient)),
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
            textStyle: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
              fontSize: iconSizeTiny,
              fontFamily: "SpaceGrotesk",
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        bottomWidget: Flexible(
          child: Consumer<TaskController>(
            builder: (context, taskController, child) => taskController.isCreating
                ? Padding(
                    padding: const EdgeInsets.only(top: paddingSmall),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: taskController.isReadyForCreate
                            ? () {
                                taskController.create().then((value) {
                                  if (value) {
                                    Navigator.pop(context);
                                  }
                                });
                              }
                            : null,
                        child: Text(context.localization!.create),
                      ),
                    ),
                  )
                : const SizedBox(),
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
                  return LoadingAndErrorWidget.pulsing(
                    state: taskController.state,
                    child: !taskController.isCreating
                        ? Text(taskController.patient.name)
                        : LoadingFutureBuilder(
                            future: PatientService().getPatientList(),
                            loadingWidget: const PulsingContainer(),
                            thenWidgetBuilder: (context, patientList) {
                              List<Patient> patients = patientList.active + patientList.unassigned;
                              return DropdownButton(
                                underline: const SizedBox(),
                                iconEnabledColor: Theme.of(context).colorScheme.secondary.withOpacity(0.6),
                                // removes the default underline
                                padding: EdgeInsets.zero,
                                hint: Text(
                                  context.localization!.selectPatient,
                                  style: TextStyle(color: Theme.of(context).colorScheme.secondary.withOpacity(0.6)),
                                ),
                                isDense: true,
                                items: patients
                                    .map((patient) => DropdownMenuItem(value: patient, child: Text(patient.name)))
                                    .toList(),
                                value: taskController.patient.isCreating ? null : taskController.patient,
                                onChanged: (patient) => taskController.changePatient(patient ?? PatientMinimal.empty()),
                              );
                            }),
                  );
                }),
              ),
              const SizedBox(height: distanceMedium),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Consumer<TaskController>(builder: (context, taskController, __) {
                    return _SheetListTile(
                      icon: Icons.person,
                      label: context.localization!.assignedTo,
                      onTap: () => context.pushModal(
                        context: context,
                        builder: (BuildContext context) => LoadingAndErrorWidget(
                          state: taskController.state,
                          child: ChangeNotifierProvider(
                            create: (BuildContext context) => AssigneeSelectController(
                              selected: taskController.task.assignee,
                              taskId: taskController.task.id,
                            ),
                            child: AssigneeSelect(
                              onChanged: (assignee) {
                                taskController.changeAssignee(assigneeId: assignee.id);
                              },
                            ),
                          ),
                        ),
                      ),
                      // TODO maybe do some optimisations here
                      // TODO update the error and loading widgets
                      valueWidget: LoadingAndErrorWidget.pulsing(
                        state: taskController.state,
                        child: taskController.task.hasAssignee
                            ? ChangeNotifierProvider(
                                create: (context) => UserController(User.empty(id: taskController.task.assignee!)),
                                child: Consumer<UserController>(
                                  builder: (context, userController, __) => LoadingAndErrorWidget.pulsing(
                                    state: userController.state,
                                    child: Text(
                                      userController.user.name,
                                      style: editableValueTextStyle(context),
                                    ),
                                  ),
                                ),
                              )
                            : Text(
                                context.localization!.unassigned,
                                style: editableValueTextStyle(context),
                              ),
                      ),
                    );
                  }),
                  Consumer<TaskController>(
                    builder: (context, taskController, __) => LoadingAndErrorWidget.pulsing(
                      state: taskController.state,
                      child: _SheetListTile(
                        icon: Icons.access_time,
                        label: context.localization!.due,
                        // TODO localization and date formatting here
                        valueWidget: Builder(builder: (context) {
                          DateTime? dueDate = taskController.task.dueDate;
                          if (dueDate != null) {
                            String date =
                                "${dueDate.day.toString().padLeft(2, "0")}.${dueDate.month.toString().padLeft(2, "0")}.${dueDate.year.toString().padLeft(4, "0")}";
                            String time =
                                "${dueDate.hour.toString().padLeft(2, "0")}:${dueDate.minute.toString().padLeft(2, "0")}";
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(time, style: editableValueTextStyle(context)),
                                Text(date),
                              ],
                            );
                          }
                          return Text(context.localization!.none);
                        }),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: distanceSmall),
              Consumer<TaskController>(
                builder: (_, taskController, __) => LoadingAndErrorWidget.pulsing(
                  state: taskController.state,
                  child: _SheetListTile(
                    icon: Icons.lock,
                    label: context.localization!.visibility,
                    valueWidget: VisibilitySelect(
                      isPublicVisible: taskController.task.isPublicVisible,
                      onChanged: (value) => taskController.changeIsPublic(isPublic: value),
                      isCreating: taskController.isCreating,
                      textStyle: editableValueTextStyle(context),
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
                builder: (_, taskController, __) => LoadingAndErrorWidget.pulsing(
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
                builder: (_, taskController, __) => LoadingAndErrorWidget.pulsing(
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
