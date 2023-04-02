import 'package:flutter/material.dart';

/// A Clipper that draws an edge from bottom to top on the left
/// and/or right side of its child
class DiagonalClipper extends CustomClipper<Path> {
  /// The indentation of your DiagonalClip
  final double diagonalIndent;

  /// Should the Clip be on the left Side
  final bool onLeft;

  /// Should the Clip be on the right Side
  final bool onRight;

  const DiagonalClipper({
    required this.onLeft,
    required this.onRight,
    this.diagonalIndent = 4,
  });

  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(onLeft ? diagonalIndent : 0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width - (onRight ? diagonalIndent : 0), size.height)
      ..lineTo(0.0, size.height)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
