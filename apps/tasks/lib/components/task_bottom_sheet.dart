import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:tasks/components/subtask_list.dart';
import 'package:tasks/dataclasses/patient.dart';
import '../dataclasses/task.dart';

class _SheetListTile extends StatelessWidget {
  final String label;
  final String name;
  final IconData icon;

  const _SheetListTile({required this.label, required this.name, required this.icon});

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
            Text(
              name,
              style: const TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        )
      ],
    );
  }
}

class TaskBottomSheet extends StatefulWidget {
  final Task task;
  final PatientMinimal? patient;

  const TaskBottomSheet({super.key, required this.task, this.patient});

  @override
  State<StatefulWidget> createState() => _TaskBottomSheetState();
}

class _TaskBottomSheetState extends State<TaskBottomSheet> {
  Task task = Task.empty;
  PatientMinimal? patient;
  bool hasInitialPatient = false;
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
    return WillPopScope(
      onWillPop: () async {
        // TODO do saving or something when the dialog is closed
        return true;
      },
      child: Container(
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
                _SheetListTile(icon: Icons.person, label: context.localization!.assignedTo, name: "Assignee"),
                _SheetListTile(icon: Icons.access_time, label: context.localization!.due, name: "27. Juni"),
              ],
            ),
            const SizedBox(height: distanceSmall),
            _SheetListTile(icon: Icons.lock, label: context.localization!.visibility, name: "Private"),
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
