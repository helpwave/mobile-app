import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:helpwave_theme/constants.dart';

/// A Circular Progress indicator
///
/// Example:
/// ```dart
/// StaticProgressIndicator(
///   progress: 0.2,
/// )
/// ```
class StaticProgressIndicator extends StatelessWidget {
  /// The [Size] of the indicator
  final Size size;
  
  /// The width of the ring which displays the progress  
  final double strokeWidth;

  /// The semanticsLabel for Screen Reading Software
  final String? semanticsLabel;

  /// Progress as a Percentage between 0.0 to 1.0
  final double progress;

  /// [Color] that indicates Progress
  ///
  /// Default from [CircularProgressIndicator] is [ProgressIndicatorThemeData.color]
  /// if that also null then [ColorScheme.primary]
  final Color? color;

  /// [Color] that is the background of the ring
  ///
  /// Default from [CircularProgressIndicator] is
  /// [ProgressIndicatorThemeData.circularTrackColor] or transparent if null
  final Color? backgroundColor;

  /// Fill clockwise
  final bool isClockwise;

  /// The rotation angle as degree
  final double angle;

  const StaticProgressIndicator({
    super.key,
    required this.progress,
    this.size = const Size.square(iconSizeSmall),
    this.strokeWidth = 7,
    this.semanticsLabel,
    this.color,
    this.backgroundColor = Colors.grey,
    this.isClockwise = false,
    this.angle = 90,
  });

  double angleToRadian(double angle) {
    return angle * math.pi /180;
  }

  @override
  Widget build(BuildContext context) {
    return  Transform.scale(
        scaleX: isClockwise ? 1 : -1,
        child: Transform.rotate(
          angle: isClockwise ? angleToRadian(angle) : angleToRadian(-angle),
          child:SizedBox(
          height: size.height - strokeWidth,
          width: size.width - strokeWidth,
          child: CircularProgressIndicator(
            strokeWidth: strokeWidth,
            semanticsLabel: semanticsLabel,
            color: color,
            backgroundColor: backgroundColor,
            value: progress,
          ),
        ),
      ),
    );
  }
}
