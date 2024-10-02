import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:helpwave_util/loading.dart';
import 'package:helpwave_widget/loading.dart';

/// A Wrapper for the standard [FutureBuilder] to easily distinguish the three
/// cases error, loading, then
class LoadingFutureBuilder<T> extends StatelessWidget {
  /// The [FutureOr] to load
  final FutureOr<T> data;

  /// The Builder for the [Widget] upon an successful [FutureOr]
  final Widget Function(BuildContext context, T data) thenBuilder;

  /// The Builder for the [Widget] when loading the [FutureOr]
  final Widget loadingWidget;

  /// The [Widget] for an error containing [FutureOr]
  final Widget errorWidget;

  const LoadingFutureBuilder({
    super.key,
    required this.data,
    required this.thenBuilder,
    this.loadingWidget = const LoadingSpinner(),
    this.errorWidget = const LoadErrorWidget(),
  });

  @override
  Widget build(BuildContext context) {
    if(data is Future){
      return FutureBuilder(
        future: data as Future<T>,
        builder: (context, snapshot) {
          LoadingState state = LoadingState.loaded;
          if (snapshot.hasError) {
            state = LoadingState.error;
          }
          if (!snapshot.hasData || snapshot.data == null) {
            state = LoadingState.loading;
          }
          return LoadingAndErrorWidget(
            state: state,
            errorWidget: Center(child: errorWidget),
            loadingWidget: Center(child: loadingWidget),
            // Safety check because typecast may fail otherwise
            child: snapshot.data != null ? thenBuilder(context, snapshot.data as T) : const SizedBox(),
          );
        },
      );
    }
    return thenBuilder(context, data as T);
  }
}
