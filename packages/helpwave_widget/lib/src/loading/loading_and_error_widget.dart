import 'package:flutter/cupertino.dart';
import 'package:helpwave_widget/loading.dart';

enum LoadingState { initializing, loaded, loading, error }

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

  const LoadingAndErrorWidget({
    super.key,
    required this.state,
    required this.child,
    this.loadingWidget = const LoadingSpinner(),
    this.errorWidget = const LoadErrorWidget(),
    this.initialWidget = const SizedBox(),
  });

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
    return child;
  }
}
