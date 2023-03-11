import 'package:flutter/material.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:tasks/components/task_status_pill.dart';
import 'package:tasks/util/diagonal_clipper.dart';

/// A Widget for displaying the amount of [Task]'s for a
///
/// Example:
/// ```dart
/// TaskStatusPillBox(
///   unscheduledCount: 0,
///   inProgressCount: 2,
///   finishedCount: 5,
/// )
/// ```
class TaskStatusPillBox extends StatelessWidget {
  /// The amount of unscheduled [Task]'s
  final int unscheduledCount;

  /// The amount of [Task]'s in progress
  final int inProgressCount;

  /// The amount of finished [Task]'s
  final int finishedCount;

  /// The color of the diagonal dividers between each pill
  final Color? dividerColor;

  /// The radius of the Border of the first and last pill
  final double borderRadius;

  const TaskStatusPillBox({
    super.key,
    this.unscheduledCount = 0,
    this.finishedCount = 0,
    this.inProgressCount = 0,
    this.dividerColor,
    this.borderRadius = borderRadiusMedium,
  });

  // TODO define size variables in constants
  @override
  Widget build(BuildContext context) {
    EdgeInsets pillPadding = const EdgeInsets.all(2);
    ShapeBorder leftShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(borderRadius),
        topLeft: Radius.circular(borderRadius),
      ),
    );
    ShapeBorder rightShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(borderRadius),
        topRight: Radius.circular(borderRadius),
      ),
    );

    const double paddingLeftRight = 6;

    return Row(
      children: [
        TaskStatusPill(
          text: unscheduledCount.toString(),
          shape: leftShape,
          diagonalClipper: const DiagonalClipper(
            onLeft: false,
            onRight: true,
          ),
          // TODO implement color in ThemeUpdate
          backgroundColor: dividerColor,
          pillBackgroundColor: const Color.fromARGB(255, 254, 224, 221),
          dotColor: const Color.fromARGB(255, 214, 114, 104),
          textColor: const Color.fromARGB(255, 89, 25, 23),
          padding: pillPadding.copyWith(
            left: paddingLeftRight,
            right: paddingLeftRight + 1,
          ),
        ),
        TaskStatusPill(
          text: inProgressCount.toString(),
          diagonalClipper: const DiagonalClipper(
            onLeft: true,
            onRight: true,
          ),
          // TODO implement color in ThemeUpdate
          backgroundColor: dividerColor,
          pillBackgroundColor: const Color.fromARGB(255, 254, 234, 203),
          dotColor: const Color.fromARGB(255, 199, 147, 69),
          textColor: const Color.fromARGB(255, 65, 42, 29),
          padding: pillPadding.copyWith(
            left: paddingLeftRight + 1,
            right: paddingLeftRight + 1,
          ),
        ),
        TaskStatusPill(
          text: finishedCount.toString(),
          shape: rightShape,
          diagonalClipper: const DiagonalClipper(
            onLeft: true,
            onRight: false,
          ),
          // TODO implement color in ThemeUpdate
          backgroundColor: dividerColor,
          pillBackgroundColor: const Color.fromARGB(255, 206, 253, 219),
          dotColor: const Color.fromARGB(255, 77, 132, 102),
          textColor: const Color.fromARGB(255, 39, 52, 41),
          padding: pillPadding.copyWith(
            left: paddingLeftRight,
            right: paddingLeftRight + 2.5,
          ),
        ),
      ],
    );
  }
}
