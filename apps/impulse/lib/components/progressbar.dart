import 'package:flutter/material.dart';
import 'package:impulse/theming/colors.dart';

/// A [ProgressBar]
class ProgressBar extends StatelessWidget {
  /// The progress that has been made as an double
  ///
  /// All values between 0 and 1
  final double progress;

  /// The width of the [ProgressBar]
  final double width;

  /// The height of the [ProgressBar]
  final double height;

  const ProgressBar({
    super.key,
    required this.progress,
    this.width = 200,
    this.height = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height / 2),
        // Adjust the radius as needed
        boxShadow: const [
          BoxShadow(
            color: Colors.grey, // Shadow color
            blurRadius: 1, // Spread radius
            offset: Offset(2, 2), // Offset in x and y direction
          ),
        ],
      ),
      child: LinearProgressIndicator(
        value: progress,
        backgroundColor: accentBackground,
        minHeight: height,
        borderRadius: BorderRadius.all(
          Radius.circular(height / 2),
        ),
        color: accent,
      ),
    );
  }
}
