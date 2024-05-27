import 'package:flutter/material.dart';
import 'package:helpwave_theme/constants.dart';

extension PushModalContextExtension<T> on BuildContext {
  Future<T?> pushModal({
    required BuildContext context,
    required Widget Function(BuildContext context) builder,
    Duration animationDuration = const Duration(milliseconds: 500),
  }) async {
    T? value = await Navigator.of(context).push<T>(
      PageRouteBuilder(
        barrierColor: Colors.black.withOpacity(0.3),
        barrierDismissible: true,
        transitionDuration: animationDuration,
        reverseTransitionDuration: animationDuration,
        opaque: false,
        // Set to false to make the route semi-transparent
        pageBuilder: (BuildContext context, _, __) {
          return _ModalWrapper(
            builder: builder,
          );
        },
        transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutQuart;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
    return value;
  }
}

class _ModalWrapper extends StatefulWidget {
  final Widget Function(BuildContext context) builder;

  const _ModalWrapper({
    required this.builder,
  });

  @override
  _ModalWrapperState createState() => _ModalWrapperState();
}

class _ModalWrapperState extends State<_ModalWrapper> with TickerProviderStateMixin {
  double touchPositionY = 0;
  ValueNotifier<double> offset = ValueNotifier(0);
  double velocityY = 0;

  Future<void> returnToNormalSize() async {
    const Duration duration = Duration(milliseconds: 100);
    Tween<double> tween = Tween(begin: offset.value, end: 0);

    // Use an AnimationController for the animation
    final AnimationController controller = AnimationController(duration: duration, vsync: this);
    final Animation<double> animation = CurvedAnimation(parent: controller, curve: Curves.easeInOut);

    // Listen for updates to the animation value
    animation.addListener(() {
      offset.value = tween.evaluate(animation);
    });

    // Start the animation
    await controller.forward();

    // Dispose of the animation controller when done
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //double backgroundDim = 0.3 * max(0, 1 - offset / 300);

    return GestureDetector(
      onVerticalDragUpdate: (details) {
        double velocity = details.primaryDelta ?? 0;
        double newOffset = offset.value += velocity;
        if (newOffset < 0) {
          newOffset = 0;
        }
        
        offset.value = newOffset;

        touchPositionY = details.globalPosition.dy;
        velocityY = velocity;
      },
      onVerticalDragEnd: (details) {
        double velocityThreshold = 2;
        if (MediaQuery.of(context).size.height - touchPositionY < 100 || velocityY > velocityThreshold) {
          Navigator.pop(context);
          return;
        }
        if (velocityY < -velocityThreshold) {
          returnToNormalSize();
        }
      },
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ValueListenableBuilder<double>(
            valueListenable: offset,
            child: Material(
              color: Colors.transparent,
              child: widget.builder(context),
            ),
            builder: (context, offsetValue, child) {
              return Transform.translate(
              offset: Offset(0, offsetValue),
                child: child,
              );
            },
          ),
      ),
    );
  }
}

/// A [BottomSheet] with a titlebar
class BottomSheetBase extends StatefulWidget {
  /// The function to call when closing the [BottomSheetBase]
  final void Function() onClosing;

  /// The builder function call to build the content of the [BottomSheetBase]
  final Widget Function(BuildContext context) builder;

  /// The title of the titlebar
  ///
  /// Overwrites [titleText]
  final Widget? title;

  /// The title text of the titlebar
  ///
  /// Overwritten by [title]
  final String titleText;

  /// The bottom [Widget] below the [builder]
  ///
  /// Overwrites [titleText]
  final Widget? bottomWidget;

  /// The [Padding] of the builder [Widget]
  final EdgeInsetsGeometry padding;

  const BottomSheetBase({
    super.key,
    required this.onClosing,
    required this.builder,
    this.title,
    this.titleText = "",
    this.padding = const EdgeInsets.all(paddingMedium),
    this.bottomWidget,
  });

  @override
  State<StatefulWidget> createState() => _BottomSheetBase();
}

class _BottomSheetBase extends State<BottomSheetBase> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      animationController: BottomSheet.createAnimationController(this),
      enableDrag: false,
      onClosing: widget.onClosing,
      builder: (context) {
        return Padding(
          padding: widget.padding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: paddingSmall),
                child: Center(
                  child: Container(
                    height: 5,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: iconSizeTiny,
                    height: iconSizeTiny,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: iconSizeTiny,
                      onPressed: () => Navigator.maybePop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: paddingSmall),
                      child: widget.title ??
                          Text(
                            widget.titleText,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: iconSizeTiny,
                              fontFamily: "SpaceGrotesk",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                    ),
                  ),
                  const SizedBox(width: iconSizeTiny),
                ],
              ),
              SingleChildScrollView(
                child: widget.builder(context),
              ),
              widget.bottomWidget ?? const SizedBox(),
            ],
          ),
        );
      },
    );
  }
}
