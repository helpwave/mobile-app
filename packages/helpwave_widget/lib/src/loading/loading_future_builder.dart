import 'package:flutter/cupertino.dart';
import 'package:helpwave_widget/loading.dart';

/// A Wrapper for the standard [FutureBuilder] to easily distinguish the three
/// cases error, loading, then
class LoadingFutureBuilder<T> extends StatelessWidget {
  /// The [Future] to load
  final Future<T> future;

  /// The Builder for the [Widget] upon an successful [Future]
  final Widget Function(BuildContext context, T data) thenWidgetBuilder;

  /// The Builder for the [Widget] when loading the [Future]
  final Widget loadingWidget;

  /// The [Widget] for an error containing [Future]
  final Widget errorWidget;

  const LoadingFutureBuilder({
    super.key,
    required this.future,
    required this.thenWidgetBuilder,
    this.loadingWidget = const LoadingSpinner(),
    this.errorWidget = const LoadErrorWidget(),
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: errorWidget);
        }
        if (!snapshot.hasData) {
          return Center(child:loadingWidget);
        }
        return thenWidgetBuilder(context, snapshot.data as T);
      },
    );
  }
}
