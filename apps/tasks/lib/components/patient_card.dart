import 'package:flutter/material.dart';
import 'package:tasks/components/task_status_pill_box.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:tasks/dataclasses/patient.dart';

/// A widget for displaying a card containing patient information
class PatientCard extends StatelessWidget {
  /// [Patient] data including bed information
  final Patient patient;

  /// The margin of the Card
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
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.black.withOpacity(0.2),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(borderRadiusSmall),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(paddingSmall),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patient.name,
                    style: const TextStyle(
                      // TODO set font to SpaceGrotesk
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    patient.bed != null && patient.room != null
                        ? "${patient.room?.name} - ${patient.bed?.name}"
                        : context.localization!.unassigned,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.black.withOpacity(0.6),
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
