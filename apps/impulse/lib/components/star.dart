import 'package:flutter/material.dart';
import 'dart:math';

import 'package:helpwave_theme/constants.dart';
import 'package:impulse/theming/colors.dart';

class StarPolygonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final double width = size.width;
    final double height = size.height;
    final double midX = width / 2;
    final double midY = height / 2;
    final double radius = width / 2;
    final double innerRadius = radius / 2.5;

    final Path path = Path();

    path.moveTo(midX, 0);
    for (int i = 0; i < 9; i++) {
      double angle = i * 2 * 3.141592653589793238 / 8;
      double radiusForThisPoint = i % 2 == 0 ? radius : innerRadius;
      path.lineTo(midX + radiusForThisPoint * cos(angle),
          midY + radiusForThisPoint * sin(angle));
    }
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class Star extends StatelessWidget {
  final double size;
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
