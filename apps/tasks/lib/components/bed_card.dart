import 'package:flutter/material.dart';
import 'package:tasks/components/task_status_pill_box.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';

/// Temporary data class for [Patient]
// TODO replace this by grpc definition
class PatientDTO {
  final String id;
  final String bed;
  int tasksUnscheduledCount;
  int tasksInProgressCount;
  int tasksDoneCount;

  PatientDTO({
    required this.id,
    required this.bed,
    required this.tasksUnscheduledCount,
    required this.tasksInProgressCount,
    required this.tasksDoneCount,
  });
}

/// A widget for displaying a card containg bed and patient information
class BedCard extends StatelessWidget {
  // Patient data including bed information
  final PatientDTO patient;

  const BedCard({
    super.key,
    required this.patient,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
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
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${context.localization!.bed} ${patient.bed}",
                  style: const TextStyle(
                    // TODO set font to SpaceGrotesk
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "${context.localization!.patient} ${patient.id}",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
              ],
            ),
            Container(height: 10),
            TaskStatusPillBox(
              unscheduledCount: patient.tasksUnscheduledCount,
              inProgressCount: patient.tasksInProgressCount,
              finishedCount: patient.tasksDoneCount,
            ),
          ],
        ),
      ),
    );
  }
}
