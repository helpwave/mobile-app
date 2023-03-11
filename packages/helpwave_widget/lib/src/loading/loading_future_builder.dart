import 'package:flutter/cupertino.dart';
import 'package:helpwave_widget/loading.dart';

/// A Wrapper for the standard [FutureBuilder] to easily distinguish the three
/// cases error, loading, then
class LoadingFutureBuilder<T> extends StatelessWidget {
  /// The [Future] to load
  final Future<T> future;

  /// The Builder for the [Widget] upon an successful [Future]
  final Widget Function(BuildContext context, T data) thenWidgetBuilder;

  /// The String to show beneath the default [loadingWidget] which is a [LoadingSpinner]
  ///
  /// Overwritten by [errorWidget]
  final String? loadingWidgetText;

  /// The Builder for the [Widget] when loading the [Future]
  final Widget? loadingWidget;

  /// The String to show beneath the default [errorWidget] which is a [LoadErrorWidget]
  ///
  /// Overwritten by [errorWidget]
  final String? errorWidgetText;

  /// The [Widget] for an error containing [Future]
  final Widget? errorWidget;

  const LoadingFutureBuilder({
    super.key,
    required this.future,
    required this.thenWidgetBuilder,
    this.loadingWidget,
    this.loadingWidgetText,
    this.errorWidget,
    this.errorWidgetText,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return errorWidget ?? LoadErrorWidget(errorText: errorWidgetText);
        }
        if (!snapshot.hasData) {
          return loadingWidget ?? LoadingSpinner(text: loadingWidgetText);
        }
        return thenWidgetBuilder(context, snapshot.data as T);
      },
    );
  }
}
