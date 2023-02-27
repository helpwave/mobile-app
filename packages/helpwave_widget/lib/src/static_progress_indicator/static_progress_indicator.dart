import 'package:flutter/material.dart';
import 'package:helpwave_theme/constants.dart';

/// A Circular Progress indicator
class StaticProgressIndicator extends StatelessWidget {
  final Size size;

  final double strokeWidth;

  /// The semanticsLabel for Screen Reading Software
  final String? semanticsLabel;

  /// Progress as a Percentage between 0.0 to 1.0
  final double progress;

  /// Color that indicates Progress
  final Color? color;

  /// Color that is the background of the ring
  final Color? backgroundColor;

  const StaticProgressIndicator({
    super.key,
    required this.progress,
    this.size = const Size.square(iconSizeSmall),
    this.strokeWidth = 8,
    this.semanticsLabel,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height - strokeWidth,
      width: size.width - strokeWidth,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        semanticsLabel: semanticsLabel,
        color: color ?? Theme
            .of(context)
            .colorScheme
            .onBackground,
        backgroundColor: backgroundColor ?? Theme
            .of(context)
            .colorScheme
            .background,
        value: progress,
      ),
    );
  }
}
