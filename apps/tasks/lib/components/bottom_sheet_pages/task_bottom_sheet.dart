import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_service/auth.dart';
import 'package:helpwave_service/user.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_theme/util.dart';
import 'package:helpwave_util/loading.dart';
import 'package:helpwave_widget/bottom_sheets.dart';
import 'package:helpwave_widget/loading.dart';
import 'package:helpwave_widget/text_input.dart';
import 'package:provider/provider.dart';
import 'package:tasks/components/bottom_sheet_pages/assignee_select.dart';
import 'package:tasks/components/subtask_list.dart';
import 'package:tasks/components/visibility_select.dart';
import 'package:helpwave_service/tasks.dart';
import 'package:helpwave_service/util.dart';
import '../patient_selector.dart';

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
    Map<TaskStatus, String> taskStatusTranslationMap = {
      TaskStatus.done: context.localization.done,
      TaskStatus.inProgress: context.localization.inProgress,
      TaskStatus.todo: context.localization.upcoming,
    };

    return ChangeNotifierProvider(
      create: (context) =>
          TaskController(TaskWithPatient.fromTaskAndPatient(task: widget.task, patient: widget.patient)),
      child: BottomSheetPage(
        header: BottomSheetHeader(
          title: Consumer<TaskController>(
            builder: (context, taskController, child) => LoadingAndErrorWidget(
              state: taskController.state,
              loadingWidget: const PulsingContainer(width: 60),
              child: ClickableTextEdit(
                initialValue: taskController.task.name,
                onUpdated: taskController.changeName,
                textAlign: TextAlign.center,
                textStyle: TextStyle(
                  color: context.theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: iconSizeTiny,
                  fontFamily: "SpaceGrotesk",
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ),
        bottom: Consumer<TaskController>(
          builder: (context, taskController, child) => Visibility(
            visible: taskController.isCreating,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: paddingSmall),
              child: Align(
                alignment: Alignment.topRight,
                child: FilledButton(
                  style: buttonStyleBig,
                  onPressed: taskController.isReadyForCreate
                      ? () {
                          taskController.create().then((value) {
                            if (value && context.mounted) {
                              Navigator.pop(context);
                            }
                          });
                        }
                      : null,
                  child: Text(context.localization.create),
                ),
              ),
            ),
          ),
        ),
        child: Flexible(
          child: ListView(
            children: [
              Center(
                child: Consumer<TaskController>(builder:
                    // TODO move this to its own component
                    (context, taskController, __) {
                  return LoadingAndErrorWidget(
                    state: taskController.state,
                    loadingWidget: const PulsingContainer(width: 60),
                    child: !taskController.isCreating
                        ? Text(taskController.patient.name)
                        : PatientSelector(
                            initialPatientId: taskController.patient.id,
                            onChange: (value) {
                              if (value != null) {
                                taskController.changePatient(value);
                              }
                            },
                          ),
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
                      label: context.localization.assignedTo,
                      onTap: () => context.pushModal(
                        context: context,
                        builder: (BuildContext context) => AssigneeSelectBottomSheet(
                          users: OrganizationService()
                              .getMembersByOrganization(CurrentWardService().currentWard!.organizationId),
                          onChanged: (User? assignee) {
                            taskController.changeAssignee(assignee);
                            Navigator.pop(context);
                          },
                          selectedId: taskController.task.assigneeId,
                        ),
                      ),
                      valueWidget: taskController.task.hasAssignee
                          ? LoadingAndErrorWidget(
                              state: taskController.assignee != null ? LoadingState.loaded : LoadingState.loading,
                              loadingWidget: const PulsingContainer(width: 60, height: 24),
                              child: Text(
                                // Never the case that we display the empty String, but the text is computed
                                // before being displayed
                                taskController.assignee?.name ?? "",
                                style: editableValueTextStyle(context),
                              ),
                            )
                          : Text(
                              context.localization.unassigned,
                              style: editableValueTextStyle(context),
                            ),
                    );
                  }),
                  Consumer<TaskController>(
                    builder: (context, taskController, __) => LoadingAndErrorWidget(
                      state: taskController.state,
                      loadingWidget: const PulsingContainer(width: 60, height: 24),
                      child: _SheetListTile(
                        icon: Icons.access_time,
                        label: context.localization.due,
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
                          return Text(context.localization.none);
                        }),
                        onTap: () => showDatePicker(
                          context: context,
                          initialDate: taskController.task.dueDate ?? DateTime.now(),
                          firstDate: DateTime(1960),
                          lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                        ).then((date) async {
                          await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(taskController.task.dueDate ?? DateTime.now()),
                          ).then((time) {
                            if (date == null && time == null) {
                              return;
                            }
                            date ??= taskController.task.dueDate;
                            if (date == null) {
                              return;
                            }
                            if (time != null) {
                              date = DateTime(
                                date!.year,
                                date!.month,
                                date!.day,
                                time.hour,
                                time.minute,
                              );
                            }
                            taskController.changeDueDate(date);
                          });
                        }),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: distanceSmall),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Consumer<TaskController>(
                    builder: (_, taskController, __) => LoadingAndErrorWidget.pulsing(
                      state: taskController.state,
                      child: _SheetListTile(
                        icon: Icons.lock,
                        label: context.localization.visibility,
                        valueWidget: VisibilitySelect(
                          isPublicVisible: taskController.task.isPublicVisible,
                          onChanged: taskController.changeIsPublic,
                          isCreating: taskController.isCreating,
                          textStyle: editableValueTextStyle(context),
                        ),
                      ),
                    ),
                  ),
                  Consumer<TaskController>(
                    builder: (_, taskController, __) => LoadingAndErrorWidget.pulsing(
                      state: taskController.state,
                      child: _SheetListTile(
                        icon: Icons.check,
                        label: context.localization.status,
                        valueWidget: Text(
                          taskStatusTranslationMap[taskController.task.status] ?? "",
                          style: editableValueTextStyle(context),
                        ),
                        // TODO show modal here
                        onTap: () => taskController.changeStatus(TaskStatus.done),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: distanceMedium),
              Text(
                context.localization.notes,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: distanceTiny),
              Consumer<TaskController>(
                builder: (_, taskController, __) => LoadingAndErrorWidget(
                  state: taskController.state,
                  loadingWidget: PulsingContainer(
                    width: MediaQuery.of(context).size.width,
                    height: 25 * 6, // 25px per line
                  ),
                  errorWidget: PulsingContainer(
                    width: MediaQuery.of(context).size.width,
                    height: 25 * 6,
                    // 25px per line
                    maxOpacity: 1,
                    minOpacity: 1,
                    color: negativeColor,
                  ),
                  child: TextFormFieldWithTimer(
                    initialValue: taskController.task.notes,
                    onUpdate: taskController.changeNotes,
                    maxLines: 6,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(paddingMedium),
                      hintText: context.localization.yourNotes,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: distanceBig),
              // TODO add callback here for task creation to update the Task accordingly
              Consumer<TaskController>(
                builder: (_, taskController, __) => LoadingAndErrorWidget(
                  state: taskController.state,
                  loadingWidget: const PulsingContainer(height: 200),
                  child: SubtaskList(
                    taskId: taskController.task.id,
                    subtasks: taskController.task.subtasks,
                    onChange: (subtasks) {
                      if (taskController.task.isCreating) {
                        taskController.task.subtasks = subtasks;
                      } else {
                        taskController.load();
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
