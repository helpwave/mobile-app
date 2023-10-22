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
import 'package:tasks/controllers/patients_controller.dart';
import 'package:tasks/controllers/task_controller.dart';
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
          (valueWidget == null && valueText != null) ||
              (valueWidget != null && valueText == null),
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
  Task task = Task.empty;
  PatientMinimal? patient;
  bool hasInitialPatient = false;

  // TODO delete this and load from backend
  List<PatientMinimal> patients = [
    PatientMinimal(id: "patient1", name: "Victoria Schäfer"),
    PatientMinimal(id: "patient2", name: "Peter Patient"),
    PatientMinimal(id: "patient3", name: "Max Mustermann"),
    PatientMinimal(id: "patient4", name: "John Doe"),
    PatientMinimal(id: "patient5", name: "Patient Name"),
  ];

  // TODO delete this and load from backend
  User user = User(id: "user1", name: "User 1", profile: Uri.parse("uri"));

  @override
  void initState() {
    task = widget.task;
    patient = widget.patient;
    hasInitialPatient = patient != null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => TaskController(widget.task),
        ),
        ChangeNotifierProvider(
          create: (context) => PatientsController(),
        ),
      ],
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
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Consumer2<TaskController, PatientsController>(
                  builder:
                      // TODO somehow get the patient for the task
                      (context, taskController, patientsController, child) =>
                          LoadingAndErrorWidget(
                    state: taskController.state,
                    child: LoadingAndErrorWidget(
                      state: patientsController.state,
                      child: hasInitialPatient
                          ? Text(patient!.name)
                          : DropdownButton(
                              underline: const SizedBox(),
                              // removes the default underline
                              padding: EdgeInsets.zero,
                              isDense: true,
                              // TODO use the full list of possible assignees
                              items: patients
                                  .map((patient) => DropdownMenuItem(
                                      value: patient,
                                      child: Text(patient.name)))
                                  .toList(),
                              value: patient,
                              onChanged: (value) {
                                setState(() {
                                  patient = value;
                                });
                              },
                            ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: distanceMedium),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // TODO change static assignee name
                  _SheetListTile(
                    icon: Icons.person,
                    label: context.localization!.assignedTo,
                    valueText: user.name,
                    onTap: () => showModalBottomSheet(
                      context: context,
                      builder: (context) => AssigneeSelect(
                        selected: user.id,
                        onChanged: (assignee) {
                          setState(() {
                            user = assignee;
                          });
                        },
                      ),
                    ),
                  ),
                  _SheetListTile(
                      icon: Icons.access_time,
                      label: context.localization!.due,
                      valueText: "27. Juni"),
                ],
              ),
              const SizedBox(height: distanceSmall),
              _SheetListTile(
                icon: Icons.lock,
                label: context.localization!.visibility,
                valueWidget: VisibilitySelect(
                  isPublicVisible: task.isPublicVisible,
                  onChanged: (value) => setState(() {
                    task.isPublicVisible = value;
                  }),
                  isCreating: task.id == "",
                  textStyle: editableValueTextStyle,
                ),
              ),
              const SizedBox(height: distanceMedium),
              Text(
                context.localization!.notes,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: distanceTiny),
              TextFormField(
                initialValue: task.notes,
                onChanged: (value) {
                  // TODO add grpc here
                  setState(() {
                    task.notes = value;
                  });
                },
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
              const SizedBox(height: distanceBig),
              SubtaskList(
                taskId: task.id,
                subtasks: task.subtasks,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
