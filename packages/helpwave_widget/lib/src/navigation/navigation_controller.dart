import 'package:flutter/cupertino.dart';

class NavigationController<T> extends ChangeNotifier {
  List<T> stack = [];

  T get currentPage => stack.last;

  bool get canPop => stack.length > 1;

  bool get isInitialPage => stack.length == 1;

  NavigationController({
    required T initialPage,
  }) {
    stack.add(initialPage);
  }

  void push(T page) {
    stack.add(page);
    notifyListeners();
  }

  void pop() {
    stack.removeLast();
    notifyListeners();
  }
}
