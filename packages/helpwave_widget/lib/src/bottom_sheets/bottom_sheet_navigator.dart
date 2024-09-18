import 'package:flutter/material.dart';
import 'package:helpwave_widget/navigation.dart';
import '../../bottom_sheets.dart';

class BottomSheetNavigator extends StatelessWidget {
  final BottomSheetPageBuilder initialPageBuilder;

  const BottomSheetNavigator({super.key, required this.initialPageBuilder});

  @override
  Widget build(BuildContext context) {
    return SimpleNavigator(
      initialPage: initialPageBuilder,
      builder: (context, navigationController) {
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

        return BottomSheetBase(
          onClosing: () {},
          builder: (context) => page.build(context, navigationController),
          header: header,
          bottomWidget: page.bottomWidgetBuilder(context, navigationController),
          mainAxisSize: MainAxisSize.max,
        );
      },
    );
  }
}
