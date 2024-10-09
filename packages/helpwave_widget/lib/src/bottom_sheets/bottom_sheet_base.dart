import 'package:flutter/material.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_theme/util.dart';
import 'package:helpwave_widget/navigation.dart';

extension PushModalContextExtension<T> on BuildContext {
  Future<T?> pushModal({
    required BuildContext context,
    required Widget Function(BuildContext context) builder,
    Duration animationDuration = const Duration(milliseconds: 500),
    Duration reverseDuration = const Duration(milliseconds: 250),
  }) async {
    T? value = await Navigator.of(context).push<T>(
      PageRouteBuilder(
        barrierColor: Colors.black.withOpacity(0.4),
        barrierDismissible: true,
        transitionDuration: animationDuration,
        reverseTransitionDuration: reverseDuration,
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

class BottomSheetAction {
  final IconData icon;
  final Function() onPressed;

  BottomSheetAction({required this.icon, required this.onPressed});

  static BottomSheetAction navigationForBottomSheetPage(BuildContext context) {
    StackController<Widget> controller = NavigationStackController.of(context);

    return BottomSheetAction(
      icon: controller.isAtNavigationStart ? Icons.close : Icons.chevron_left_rounded,
      onPressed: () {
        if (controller.canPop) {
          controller.pop();
        } else {
          Navigator.pop(context);
        }
      },
    );
  }
}

class BottomSheetHeader extends StatelessWidget {
  /// A [BottomSheetAction] leading before the [title]
  ///
  /// Defaults to a closing button
  final BottomSheetAction? leading;

  /// A [BottomSheetAction] trailing after the [title]
  final BottomSheetAction? trailing;

  /// The title of the [BottomSheetHeader] displayed in the center
  ///
  /// Overwrites [titleText]
  final Widget? title;

  /// The title text of the [BottomSheetHeader] displayed in the center
  ///
  /// Overwritten by [title]
  final String? titleText;

  /// Whether the drag handler widget should be shown
  final bool isShowingDragHandler;

  /// An additional padding for the [BottomSheetHeader]
  ///
  /// Be aware that the [BottomSheetBase] **already provides a padding** to all sides.
  ///
  /// You most likely want to change the bottom padding to create spacing between [BottomSheetHeader] and content of
  /// the [BottomSheetBase].
  final EdgeInsets padding;

  const BottomSheetHeader({
    super.key,
    this.leading,
    this.trailing,
    this.title,
    this.titleText,
    this.isShowingDragHandler = false,
    this.padding = const EdgeInsets.only(bottom: paddingSmall),
  });

  factory BottomSheetHeader.navigation(
    BuildContext context, {
    BottomSheetAction? trailing,
    Widget? title,
    String? titleText,
    bool isShowingDragHandler = false,
    EdgeInsets padding = const EdgeInsets.only(bottom: paddingSmall),
  }) {
    return BottomSheetHeader(
      leading: BottomSheetAction.navigationForBottomSheetPage(context),
      trailing: trailing,
      title: title,
      titleText: titleText,
      isShowingDragHandler: isShowingDragHandler,
      padding: padding,
    );
  }

  BottomSheetHeader copyWith({
    BottomSheetAction? leading,
    BottomSheetAction? trailing,
    Widget? title,
    String? titleText,
    bool? isShowingDragHandler,
    EdgeInsets? padding,
  }) {
    return BottomSheetHeader(
      leading: leading ?? this.leading,
      trailing: trailing ?? this.trailing,
      title: title ?? this.title,
      titleText: titleText ?? this.titleText,
      isShowingDragHandler: isShowingDragHandler ?? this.isShowingDragHandler,
      padding: padding ?? this.padding,
    );
  }

  @override
  Widget build(BuildContext context) {
    BottomSheetAction usedLeading =
        leading ?? BottomSheetAction(icon: Icons.close_rounded, onPressed: () => Navigator.maybePop(context));

    const double iconSize = iconSizeSmall;

    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: isShowingDragHandler,
            child: Padding(
              padding: const EdgeInsets.only(bottom: paddingSmall),
              child: Center(
                child: Container(
                  height: 5,
                  width: 30,
                  decoration: BoxDecoration(
                    color: context.theme.colorScheme.onBackground.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: iconSize,
                height: iconSize,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: iconSize,
                  onPressed: usedLeading.onPressed,
                  icon: Icon(usedLeading.icon),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: paddingSmall),
                  child: title ??
                      Text(
                        titleText ?? "",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: iconSizeTiny,
                          fontFamily: "SpaceGrotesk",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                ),
              ),
              SizedBox(
                width: iconSize,
                height: iconSize,
                child: trailing != null
                    ? IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: iconSize,
                        onPressed: trailing!.onPressed,
                        icon: Icon(trailing!.icon),
                      )
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A [BottomSheet] with a titlebar
class BottomSheetBase extends StatefulWidget {
  /// The function to call when closing the [BottomSheetBase]
  final void Function() onClosing;

  /// The main [Widget] of the [BottomSheetBase]
  final Widget child;

  /// A header [Widget] above the builder content
  ///
  /// Defaults to the [BottomSheetHeader]
  final Widget? header;

  /// The bottom [Widget] below the [builder]
  final Widget? bottomWidget;

  /// The [Padding] of the builder [Widget]
  final EdgeInsetsGeometry padding;

  final MainAxisSize mainAxisSize;

  const BottomSheetBase({
    super.key,
    required this.onClosing,
    required this.child,
    this.padding = const EdgeInsets.all(paddingMedium),
    this.bottomWidget,
    this.header,
    this.mainAxisSize = MainAxisSize.min,
  });

  @override
  State<StatefulWidget> createState() => _BottomSheetBase();
}

class _BottomSheetBase extends State<BottomSheetBase> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BottomSheet(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
        animationController: BottomSheet.createAnimationController(this),
        enableDrag: false,
        onClosing: widget.onClosing,
        builder: (context) {
          return Padding(
            padding: widget.padding,
            child: Column(
              mainAxisSize: widget.mainAxisSize,
              children: [
                widget.header ?? const SizedBox(),
                widget.child,
                widget.bottomWidget ?? const SizedBox(),
              ],
            ),
          );
        },
      ),
    );
  }
}
