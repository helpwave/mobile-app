import 'package:flutter/material.dart';
import 'package:helpwave_widget/src/navigation/index.dart';
import 'package:provider/provider.dart';

/// A navigation widget which can be used withing the flutter [Navigator]
class SimpleNavigator<T> extends StatelessWidget {
  final T initialPage;

  final Widget Function(BuildContext context, NavigationController<T> navigationController) builder;

  const SimpleNavigator({super.key, required this.initialPage, required this.builder});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NavigationController(
        initialPage: initialPage,
      ),
      child: Consumer<NavigationController<T>>(
        builder: (context, navigationController, _) {
          return PopScope(
            // If the navigation controller cannot pop to another bottom sheet, a normal pop is correct
            canPop: !navigationController.canPop,
            onPopInvoked: (didPop) {
              if (navigationController.canPop) {
                navigationController.pop();
              }
            },
            child: builder(context, navigationController),
          );
        },
      ),
    );
  }
}
