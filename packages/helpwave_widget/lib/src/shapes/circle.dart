import 'package:flutter/material.dart';
import 'package:helpwave_theme/constants.dart';

/// A [Widget] Shaped like a circle
class Circle extends StatelessWidget {
  /// The radius of the circle
  final double diameter;

  /// The [Color] of th circle
  final Color? color;

  const Circle({super.key, this.diameter = distanceSmall, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color ?? Colors.black,
      ),
    );
  }
}
