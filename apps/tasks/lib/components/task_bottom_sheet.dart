import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:tasks/components/subtask_list.dart';
import 'package:tasks/components/visibility_select.dart';
import 'package:tasks/dataclasses/patient.dart';
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

  const _SheetListTile({
    required this.label,
    this.valueText,
    this.valueWidget,
    required this.icon,
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
        Column(
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

  @override
  void initState() {
    task = widget.task;
    patient = widget.patient;
    hasInitialPatient = patient != null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {
        // TODO handle this
      },
      builder: (context) => Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
        padding: const EdgeInsets.only(
          bottom: paddingSmall,
          top: paddingMedium,
          left: paddingMedium,
          right: paddingMedium,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
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
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: paddingSmall),
                    child: Text(
                      widget.task.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: iconSizeTiny,
                        fontFamily: "SpaceGrotesk",
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: iconSizeTiny),
              ],
            ),
            Center(
              child: hasInitialPatient
                  ? Text(patient!.name)
                  : DropdownButton(
                      underline: const SizedBox(),
                      // removes the default underline
                      padding: EdgeInsets.zero,
                      isDense: true,
                      // TODO use the full list of possible assignees
                      items: patients
                          .map((patient) => DropdownMenuItem(value: patient, child: Text(patient.name)))
                          .toList(),
                      value: patient,
                      onChanged: (value) {
                        setState(() {
                          patient = value;
                        });
                      },
                    ),
            ),
            const SizedBox(height: distanceMedium),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // TODO change static assignee name
                _SheetListTile(icon: Icons.person, label: context.localization!.assignedTo, valueText: "Assignee"),
                _SheetListTile(icon: Icons.access_time, label: context.localization!.due, valueText: "27. Juni"),
              ],
            ),
            const SizedBox(height: distanceSmall),
            _SheetListTile(
              icon: Icons.lock,
              label: context.localization!.visibility,
              valueWidget: VisibilitySelect(
                isPublicVisible: task.isPublicVisible,
                onChanged: (value) => setState(() {task.isPublicVisible = value;}),
                isCreating: task.id == "",
                textStyle: editableValueTextStyle,
              ),
            ),
            const SizedBox(height: distanceMedium),
            Text(
              context.localization!.notes,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
    );
  }
}
