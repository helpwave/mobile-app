import 'package:flutter/cupertino.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_util/loading.dart';
import 'package:helpwave_widget/loading.dart';

/// A [Widget] to show different [Widget]s depending on the [LoadingState]
class LoadingAndErrorWidget extends StatelessWidget {
  /// The [LoadingState] is used to determine the shown [Widget]
  final LoadingState state;

  /// The [Widget] to show in normal cases
  final Widget child;

  /// The [Widget] to show when loading
  final Widget loadingWidget;

  /// The [Widget] for an error
  final Widget errorWidget;

  /// The [Widget] when the component isn't initialized
  final Widget initialWidget;

  /// The [Widget] for an [LoadingState.unspecified]
  final Widget? unspecifiedWidget;

  const LoadingAndErrorWidget({
    super.key,
    required this.state,
    required this.child,
    this.loadingWidget = const LoadingSpinner(),
    this.errorWidget = const LoadErrorWidget(),
    this.initialWidget = const SizedBox(),
    this.unspecifiedWidget,
  });

  factory LoadingAndErrorWidget.pulsing({
    Key? key,
    required LoadingState state,
    required Widget child,
    Widget loadingWidget = const PulsingContainer(),
    Widget errorWidget = const PulsingContainer(
      maxOpacity: 1,
      minOpacity: 1,
      color: negativeColor,
    ),
    Widget? unspecifiedWidget,
  }) =>
      LoadingAndErrorWidget(
        key: key,
        state: state,
        loadingWidget: loadingWidget,
        errorWidget: errorWidget,
        unspecifiedWidget: unspecifiedWidget,
        child: child,
      );

  @override
  Widget build(BuildContext context) {
    if (state == LoadingState.error) {
      return Center(child: errorWidget);
    }
    if (state == LoadingState.loading) {
      return Center(child: loadingWidget);
    }
    if (state == LoadingState.initializing) {
      return Center(child: initialWidget);
    }
    if (state == LoadingState.unspecified) {
      return unspecifiedWidget ?? child;
    }
    return child;
  }
}
