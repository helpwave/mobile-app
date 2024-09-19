import 'package:flutter/material.dart';
import 'package:helpwave_widget/src/navigation/index.dart';
import 'package:provider/provider.dart';

/// A navigation [Widget] which can be used withing the flutter [Navigator]
///
/// Provided with an [initialValue]
class NavigationStack<T> extends StatelessWidget {
  final T initialValue;

  /// Whether the flutter default [Navigator] should be disabled.
  ///
  /// True: All pop events are intercepted and only if the last page is shown will the pop happen
  ///
  /// False: The pop events are propagated to the flutter [Navigator] and the page is popped
  final bool disableNavigator;

  /// A custom handler that specifies how the generic values of the [NavigationStackState] are mapped
  /// to a [Widget]
  final Widget Function(BuildContext context, StackController<T> navigationController) builder;

  const NavigationStack({
    super.key,
    required this.initialValue,
    required this.builder,
    this.disableNavigator = true,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StackController<T>(
        initialValue: initialValue,
      ),
      builder: (context, child) => Consumer<StackController<T>>(
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

/// A wrapper for the [NavigationStack] that allows the stacking of arbitrary many [Widget]s
class NavigationOutlet extends NavigationStack<Widget> {
  NavigationOutlet({super.key, required super.initialValue, super.disableNavigator})
      : super(builder: (context, navigationController) => navigationController.currentItem);
}
