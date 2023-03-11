import 'package:flutter/material.dart';
import 'package:helpwave_theme/constants.dart';

/// The Spinner to show when Loading data
class LoadingSpinner extends StatelessWidget {
  /// Text below the Spinner
  final String? text;

  /// Size of the Spinner
  final double size;

  /// Size of the Spinner stroke
  final double width;

  /// Color of the Spinner
  final Color? color;

  const LoadingSpinner({
    super.key,
    this.text,
    this.size = iconSizeBig,
    this.width = 4,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: size,
            width: size,
            child: CircularProgressIndicator(
              strokeWidth: width,
              semanticsLabel: text ?? "Loading",
              color: color,
            ),
          ),
          const SizedBox(height: distanceBig),
          Text(text ?? "Loading"),
        ],
      ),
    );
  }
}
