import 'package:flutter/material.dart';
import 'package:helpwave_theme/constants.dart';

/// A [Widget] for content while its loading
class PulsingContainer extends StatefulWidget {
  /// The [Color] of the container defaults to onBackground
  final Color? color;

  /// Minimum opacity of the containers color
  final double minOpacity;

  /// Maximum opacity of the containers color
  final double maxOpacity;

  /// The [Duration] from [minOpacity] to [maxOpacity] or vice versa
  final Duration duration;

  /// The constraints of the [Container] overwritten by [height] an [width]
  final BoxConstraints boxConstraints;

  /// The height of the [Container]
  final double? height;

  /// The width of the [Container]
  final double? width;

  /// The border radius of the [Container]
  final BorderRadiusGeometry? borderRadius;

  const PulsingContainer({
    super.key,
    this.color,
    this.minOpacity = 0.2,
    this.maxOpacity = 0.4,
    this.duration = const Duration(seconds: 1),
    this.boxConstraints = const BoxConstraints.expand(height: 16),
    this.width,
    this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(borderRadiusMedium)),
  });

  @override
  createState() => _PulsingContainerState();
}

class _PulsingContainerState extends State<PulsingContainer> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _opacityAnimation = Tween<double>(
      begin: widget.maxOpacity,
      end: widget.minOpacity,
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
    Color baseColor = widget.color ?? Theme.of(context).colorScheme.onSurface;

    return AnimatedBuilder(
      animation: _opacityAnimation,
      builder: (context, child) {
        // Interpolate the color's opacity using the _opacityAnimation value
        return Container(
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            color: baseColor.withOpacity(_opacityAnimation.value),
          ),
          constraints: widget.boxConstraints.copyWith(
            minWidth: widget.width,
            maxWidth: widget.width,
            minHeight: widget.height,
            maxHeight: widget.height,
          ),
        );
      },
    );
  }
}
