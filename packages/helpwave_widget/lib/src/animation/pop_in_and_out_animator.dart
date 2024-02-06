import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

/// A Animator for letting a [Widget] pop in by expanding and pop out
/// by shrinking and being hidden
class PopInAndOutAnimator extends StatefulWidget {
  /// The [Widget] to animate
  final Widget child;

  /// The current state whether the [child] is visible
  ///
  /// Changing this start the pop in or pop out animation
  final bool visible;

  /// The time for the pop in animation
  final Duration popInDuration;

  /// The time for the pop out animation
  final Duration popOutDuration;

  const PopInAndOutAnimator({
    super.key,
    required this.child,
    required this.visible,
    this.popInDuration = const Duration(milliseconds: 300),
    this.popOutDuration = const Duration(milliseconds: 300),
  });

  @override
  PopInAndOutAnimatorState createState() => PopInAndOutAnimatorState();
}

class PopInAndOutAnimatorState extends State<PopInAndOutAnimator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.popInDuration,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Cubic(0.4, 0.885, 0.5, 1.2),
      ),
    );

    _controller.addListener(() {
      setState(() {});
    });

    if(widget.visible){
      start();
    }
  }

  void start() {
    if (widget.visible) {
      _controller.duration = widget.popInDuration;
      _controller.forward();
    } else {
      _controller.duration = widget.popOutDuration;
      _controller.reverse();
    }
  }

  @override
  void didUpdateWidget(covariant PopInAndOutAnimator oldWidget) {
    super.didUpdateWidget(oldWidget);
    start();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _scaleAnimation.value > 0,
      child: Opacity(
        opacity: clampDouble(_scaleAnimation.value, 0, 1),
        child: Transform.scale(
          scale: _scaleAnimation.value,
          child: widget.child,
        ),
      ),
    );
  }
}
