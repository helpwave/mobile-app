import 'package:flutter/cupertino.dart';
import 'package:impulse/theming/colors.dart';

/// A Wrapper for setting a [Gradient] as background [Color]
class BackgroundGradient extends StatelessWidget {
  /// The child of this component to which the background applies
  final Widget child;

  /// The [Gradient] for the background
  final Gradient gradient;

  const BackgroundGradient({
    super.key,
    required this.child,
    this.gradient = const LinearGradient(
      colors: [Color(0xFFA49AEC), primary],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: [0.0, 1.0],
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
      ),
      child: child,
    );
  }
}
