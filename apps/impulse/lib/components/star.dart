import 'package:flutter/material.dart';
import 'dart:math';

import 'package:helpwave_theme/constants.dart';
import 'package:impulse/theming/colors.dart';

/// A [Clipper] that makes a polygon of a star with four peaks
class StarPolygonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final double width = size.width;
    final double height = size.height;
    final double midX = width / 2;
    final double midY = height / 2;
    final double radius = width / 2;
    final double innerRadius = radius * 0.4; // the radius to which the valleys of the star go

    final Path path = Path();

    path.moveTo(midX, 0);
    for (int i = 0; i < 9; i++) {
      double angle = i * 2 * pi / 8;
      double radiusForThisPoint = i % 2 == 0 ? radius : innerRadius;
      path.lineTo(midX + radiusForThisPoint * cos(angle), midY + radiusForThisPoint * sin(angle));
    }
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

/// A Star with four peaks
class Star extends StatelessWidget {
  /// The size of the [Star]
  final double size;

  /// The [Color] of the [Star]
  final Color color;

  const Star({super.key, this.size = iconSizeSmall, this.color = primary});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: StarPolygonClipper(),
      child: Container(
        width: iconSizeSmall,
        height: iconSizeSmall,
        color: color,
      ),
    );
  }
}
