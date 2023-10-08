import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_widget/static_progress_indicator.dart';
import 'package:tasks/dataclasses/task.dart';

class TaskCard extends StatelessWidget {
  final TaskWithPatient task;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;

  const TaskCard({super.key, required this.task, this.margin, this.borderRadius = borderRadiusMedium});

  String getDueText(BuildContext context) {
    String result = context.localization!.dueIn;
    if (task.dueDate == null) {
      return "$result -";
    }

    if (task.isOverdue) {
      return context.localization!.overdue;
    }

    if (task.inNextHour) {
      return "$result ${context.localization!.nMinutes(task.remainingTime.inMinutes)}";
    }

    if (task.inNextTwoDays) {
      return "$result ${context.localization!.nHours(task.remainingTime.inHours)}";
    }

    return "$result ${context.localization!.nDays(task.remainingTime.inDays)}";
  }

  Color getBackgroundColor() {
    Color overDue = const Color(0xFFFCE8E8);
    Color warning = const Color(0xFFFEEACB);
    Color normal = const Color(0xFFE2E9DB);

    if (task.isOverdue) {
      return overDue;
    }
    if (task.remainingTime.inHours < 8) {
      return warning;
    }
    return normal;
  }

  Color getTextColor() {
    Color overDue = const Color(0xFFD67268);
    Color warning = const Color(0xFFC79345);
    Color normal = const Color(0xFF7A977E);

    if (task.isOverdue) {
      return overDue;
    }
    if (task.remainingTime.inHours < 8) {
      return warning;
    }
    return normal;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: margin,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          side: const BorderSide(color: Colors.grey, width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: paddingSmall, horizontal: paddingMedium),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StaticProgressIndicator(
                    progress: task.progress,
                    color: primaryColor,
                    backgroundColor: const Color.fromARGB(255, 210, 210, 210),
                    isClockwise: true,
                    angle: 0,
                  ),
                  Chip(
                    backgroundColor: getBackgroundColor(),
                    label: Text(
                      getDueText(context),
                      style: TextStyle(color: getTextColor()),
                    ),
                    elevation: 0,
                  ),
                ],
              ),
              const SizedBox(
                height: distanceTiny,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.patient.name,
                          style: const TextStyle(color: primaryColor),
                        ),
                        Text(
                          task.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: "SpaceGrotesk",
                          ),
                        ),
                        Text(
                          task.notes,
                          style: const TextStyle(
                              fontSize: 14,
                              fontFamily: "SpaceGrotesk",
                              overflow: TextOverflow.ellipsis,
                              color: Color.fromARGB(255, 100, 100, 100)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: distanceTiny),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(maxHeight: iconSizeSmall, maxWidth: iconSizeSmall),
                    onPressed: () {
                      // TODO change task status
                    },
                    icon: Icon(
                      size: iconSizeTiny,
                      Icons.check_circle_outline_rounded,
                      // TODO change colors later
                      color: task.status == TaskStatus.taskStatusDone ? Colors.grey : primaryColor,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
