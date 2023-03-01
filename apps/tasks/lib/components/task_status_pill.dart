import 'package:flutter/material.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_widget/shapes.dart';
import 'package:tasks/util/diagonal_clipper.dart';

/// A Widget for displaying a Task Status Pill
class TaskStatusPill extends StatelessWidget {
  /// The text to be displayed
  final String text;

  /// The Shape of the Pill
  final ShapeBorder? shape;

  /// The [Color] behind the Pill
  final Color? backgroundColor;

  /// Background [Color] of the inner pill
  final Color? pillBackgroundColor;

  /// The [Color] of the dot
  final Color? dotColor;

  /// The [Color] of the text
  final Color? textColor;

  /// The padding surrounding the dot and the text
  final EdgeInsetsGeometry? padding;

  /// The [DiagonalClipper] that's used to clip the Pill
  final DiagonalClipper diagonalClipper;

  const TaskStatusPill({
    super.key,
    this.text = "0",
    this.shape,
    this.backgroundColor,
    this.pillBackgroundColor,
    this.dotColor,
    this.textColor,
    this.padding,
    this.diagonalClipper = const DiagonalClipper(onRight: true, onLeft: true),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: shape ?? const RoundedRectangleBorder(),
        color: backgroundColor ?? Colors.transparent,
      ),
      child: ClipPath(
        clipper: diagonalClipper,
        child: Container(
          padding: padding ?? const EdgeInsets.all(distanceTiny),
          decoration: ShapeDecoration(
            color: pillBackgroundColor ?? Colors.grey,
            shape: shape ?? const RoundedRectangleBorder(),
          ),
          child: Row(children: [
            Circle(color: dotColor ?? Colors.black),
            const SizedBox(width: distanceTiny),
            Text(
              text,
              style: TextStyle(color: textColor ?? Colors.black),
            ),
          ]),
        ),
      ),
    );
  }
}
