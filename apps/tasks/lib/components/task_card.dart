import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_service/tasks.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_theme/util.dart';
import 'package:helpwave_widget/static_progress_indicator.dart';

/// A [Card] showing a [Task]'s information
class TaskCard extends StatelessWidget {
  /// The [Task] used to display the information
  final TaskWithPatient task;

  /// The [margin] of the [Card]
  final EdgeInsetsGeometry? margin;

  /// The [borderRadius] of the [Card]
  final double borderRadius;

  /// The [Function] called when the [Task] should be completed
  final Function() onComplete;

  /// The [Function] called when the [Task] should be edited
  final Function() onTap;

  const TaskCard({
    super.key,
    required this.task,
    this.margin,
    this.borderRadius = borderRadiusMedium,
    required this.onComplete,
    required this.onTap,
  });

  /// Determines the text shown for indicating the remaining time for the [Task]
  String getDueText(BuildContext context) {
    String result = context.localization.dueIn;
    if (task.dueDate == null) {
      return "$result -";
    }

    if (task.isOverdue) {
      return context.localization.overdue;
    }

    if (task.inNextHour) {
      return "$result ${context.localization.nMinutes(task.remainingTime.inMinutes)}";
    }

    if (task.inNextTwoDays) {
      return "$result ${context.localization.nHours(task.remainingTime.inHours)}";
    }

    return "$result ${context.localization.nDays(task.remainingTime.inDays)}";
  }

  /// Depending on the remaining time of the [task] the use a different background color
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

  /// Depending on the remaining time of the [task] the use a different text color
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
    return InkWell(
      borderRadius: BorderRadius.circular(borderRadius),
      onTap: onTap,
      child: Card(
        margin: margin,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: paddingSmall, horizontal: paddingMedium),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StaticProgressIndicator(
                    progress: task.progress,
                    color: context.theme.colorScheme.primary,
                    backgroundColor: context.theme.colorScheme.onSurface.withOpacity(0.3),
                    isClockwise: true,
                    angle: 0,
                  ),
                  Chip(
                    side: BorderSide.none,
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
                          style: TextStyle(color: context.theme.colorScheme.primary),
                        ),
                        Text(
                          task.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: "SpaceGrotesk",
                          ),
                        ),
                        task.notes.isNotEmpty
                            ? Text(
                                task.notes,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "SpaceGrotesk",
                                  overflow: TextOverflow.ellipsis,
                                  color: context.theme.colorScheme.onSurface.withOpacity(0.6),
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                  const SizedBox(width: distanceTiny),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(maxHeight: iconSizeSmall, maxWidth: iconSizeSmall),
                    onPressed: onComplete,
                    icon: Icon(
                      size: iconSizeTiny,
                      Icons.check_circle_outline_rounded,
                      // TODO change colors later
                      color: task.status != TaskStatus.done
                          ? context.theme.colorScheme.onSurface.withOpacity(0.4)
                          : context.theme.colorScheme.primary,
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
