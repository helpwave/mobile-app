import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:helpwave_widget/src/bottom_sheets/bottom_sheet_base.dart';

mixin BottomSheetPageBuilder {
  /// The [BottomSheetHeader] of the [BottomSheetPageBuilder]
  ///
  /// The leading icon will always be ignored to
  BottomSheetHeader? headerBuilder(BuildContext context, NestedBottomSheetNavigationController controller) {
    return null;
  }

  /// The [BottomSheetBase] bottom widget to display for the [BottomSheetPageBuilder]
  Widget? bottomWidgetBuilder(BuildContext context, NestedBottomSheetNavigationController controller) {
    return null;
  }

  /// The builder function call to build the content of the [BottomSheetBase]
  Widget build(BuildContext context, NestedBottomSheetNavigationController controller);
}

class NestedBottomSheetNavigationController extends ChangeNotifier {
  List<BottomSheetPageBuilder> stack = [];

  BottomSheetPageBuilder get currentPage => stack.last;

  bool get canPop => stack.length > 1;

  bool get isInitialPage => stack.length == 1;

  NestedBottomSheetNavigationController({
    required BottomSheetPageBuilder initialPageBuilder,
  }) {
    stack.add(initialPageBuilder);
  }

  void push(BottomSheetPageBuilder page) {
    stack.add(page);
    notifyListeners();
  }

  void pop() {
    stack.removeLast();
    notifyListeners();
  }
}

class NestedBottomSheetNavigator extends StatelessWidget {
  final BottomSheetPageBuilder initialPageBuilder;

  const NestedBottomSheetNavigator({super.key, required this.initialPageBuilder});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NestedBottomSheetNavigationController(
        initialPageBuilder: initialPageBuilder,
      ),
      child: Consumer<NestedBottomSheetNavigationController>(
        builder: (context, navigationController, child) {
          BottomSheetPageBuilder page = navigationController.currentPage;

          BottomSheetHeader? computedHeader = page.headerBuilder(context, navigationController);

          BottomSheetHeader header = BottomSheetHeader(
            title: computedHeader?.title,
            titleText: computedHeader?.titleText,
            isShowingDragHandler: computedHeader?.isShowingDragHandler ?? false,
            trailing: computedHeader?.trailing,
            leading: BottomSheetAction(
              icon: navigationController.isInitialPage ? Icons.close : Icons.chevron_left_rounded,
              onPressed: () {
                if (navigationController.canPop) {
                  navigationController.pop();
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          );

          return PopScope(
            // If the navigation controller cannot pop to another bottom sheet, a normal pop is correct
            canPop: !navigationController.canPop,
            onPopInvoked: (didPop) {
              if(navigationController.canPop){
                navigationController.pop();
              }
            },
            child: BottomSheetBase(
              onClosing: () {},
              builder: (context) => page.build(context, navigationController),
              header: header,
              bottomWidget: page.bottomWidgetBuilder(context, navigationController),
              mainAxisSize: MainAxisSize.max,
            ),
          );
        },
      ),
    );
  }
}
