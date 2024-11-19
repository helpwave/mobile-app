import 'package:flutter/material.dart';
import 'package:helpwave_service/tasks.dart';
import 'package:tasks/components/task_status_pill_box.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';

/// A [Widget] for displaying a card containing [Patient] information
class PatientCard extends StatelessWidget {
  /// [Patient] data including [Bed] information
  final Patient patient;

  /// The margin of the [Card]
  final EdgeInsetsGeometry? margin;

  /// A on click callback
  final void Function()? onClick;

  const PatientCard({
    super.key,
    required this.patient,
    this.onClick,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Card(
        margin: margin,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: paddingSmall, horizontal: paddingSmall),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patient.name,
                    style: const TextStyle(
                      fontFamily: "SpaceGrotesk",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    patient.bed != null && patient.room != null
                        ? "${patient.room?.name} - ${patient.bed?.name}"
                        : context.localization.unassigned,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              TaskStatusPillBox(
                unscheduledCount: patient.unscheduledCount,
                inProgressCount: patient.inProgressCount,
                finishedCount: patient.doneCount,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
