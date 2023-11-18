import 'package:flutter/material.dart';
import 'package:helpwave_theme/constants.dart';

/// A [Widget] for content while its loading
class PulsingContainer extends StatefulWidget {
  /// The [Color] of the container
  final Color color;

  /// Minimum opacity of the containers color
  final double minOpacity;

  /// Maximum opacity of the containers color
  final double maxOpacity;

  /// The [Duration] from [minOpacity] to [maxOpacity] or vice versa
  final Duration duration;

  /// The height of the [Container]
  final double height;

  /// The width of the [Container]
  final double width;

  /// The border radius of the [Container]
  final BorderRadiusGeometry? borderRadius;

  const PulsingContainer({
    super.key,
    this.color = Colors.grey,
    this.minOpacity = 0.3,
    this.maxOpacity = 0.8,
    this.duration = const Duration(seconds: 1),
    this.height = 16,
    this.width = 48,
    this.borderRadius = const BorderRadius.all(Radius.circular(borderRadiusMedium)),
  });

  @override
  createState() => _PulsingContainerState();
}

class _PulsingContainerState extends State<PulsingContainer> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _colorAnimation = ColorTween(
      begin: widget.color.withOpacity(widget.maxOpacity),
      end: widget.color.withOpacity(widget.minOpacity),
    ).animate(_controller);

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            color: _colorAnimation.value,
          ),
          width: widget.width,
          height: widget.height,
        );
      },
    );
  }
}
