import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class StackController<T> extends ChangeNotifier {
  List<T> stack = [];

  T get currentItem => stack.last;

  bool get canPop => stack.length > 1;

  bool get isAtNavigationStart => stack.length == 1;

  StackController({
    required T initialValue,
  }) {
    stack.add(initialValue);
  }

  void push(T page) {
    stack.add(page);
    notifyListeners();
  }

  void pop() {
    stack.removeLast();
    notifyListeners();
  }

  static StackController<T> of<T>(BuildContext context) => Provider.of<StackController<T>>(context, listen: false);
}

class NavigationStackController extends StackController<Widget> {
  NavigationStackController({required super.initialValue});

  static StackController<Widget> of(BuildContext context) => Provider.of<StackController<Widget>>(
        context,
        listen: false,
      );
}
