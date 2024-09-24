import 'package:flutter/material.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_widget/navigation.dart';
import '../../bottom_sheets.dart';

/// A wrapper for a [BottomSheetBase] to ensure uniform styling among these
///
/// These pages rely on a [NavigationStackController] to be navigated to and **can only be used** when a
/// **[NavigationStackController] is provided** or the header is overwritten
class BottomSheetPage extends StatelessWidget {
  /// The header of the [BottomSheetBase],
  ///
  /// Defaults to [BottomSheetHeader.navigation]
  final Widget? header;

  final Widget child;

  final Widget? bottom;

  const BottomSheetPage({
    super.key,
    this.header,
    required this.child,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return BottomSheetBase(
      onClosing: () {},
      header: header ?? BottomSheetHeader.navigation(context),
      bottomWidget: bottom,
      mainAxisSize: MainAxisSize.max,
      padding: const EdgeInsets.all(paddingMedium).copyWith(bottom: 0),
      child: child,
    );
  }
}
