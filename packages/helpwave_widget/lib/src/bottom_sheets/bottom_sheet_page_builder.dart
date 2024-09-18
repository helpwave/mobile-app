import 'package:flutter/cupertino.dart';
import 'package:helpwave_widget/navigation.dart';
import '../../bottom_sheets.dart';

mixin BottomSheetPageBuilder {
  /// The [BottomSheetHeader] of the [BottomSheetPageBuilder]
  ///
  /// The leading icon will always be ignored to
  BottomSheetHeader? headerBuilder(BuildContext context, NavigationController<BottomSheetPageBuilder> controller) {
    return null;
  }

  /// The [BottomSheetBase] bottom widget to display for the [BottomSheetPageBuilder]
  Widget? bottomWidgetBuilder(BuildContext context, NavigationController<BottomSheetPageBuilder> controller) {
    return null;
  }

  /// The builder function call to build the content of the [BottomSheetBase]
  Widget build(BuildContext context, NavigationController<BottomSheetPageBuilder> controller);
}
