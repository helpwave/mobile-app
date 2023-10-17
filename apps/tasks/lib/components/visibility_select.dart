import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_widget/bottom_sheets.dart';
import 'package:tasks/dataclasses/task.dart';

/// A [BottomSheet] to change the visibility
class _VisibilityBottomSheet extends StatelessWidget {
  /// The callback when the value is changed
  final Function(bool isPublic) onChange;

  const _VisibilityBottomSheet({required this.onChange});

  @override
  Widget build(BuildContext context) {
    TextStyle style = const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
    );
    return BottomSheetBase(
      onClosing: () {},
      paddingBottom: paddingBig,
      titleText: context.localization!.visibility,
      builder: (context) {
        return Column(
          children: [
            const SizedBox(height: distanceSmall),
            GestureDetector(
              onTap: () {
                onChange(true);
                Navigator.of(context).pop();
              },
              child: Text(context.localization!.public, style: style),
            ),
            const SizedBox(height: distanceSmall),
            GestureDetector(
              onTap: () {
                onChange(false);
                Navigator.of(context).pop();
              },
              child: Text(context.localization!.private, style: style),
            ),
          ],
        );
      },
    );
  }
}

/// A [Widget] for changing the Visibility of a [Task]
class VisibilitySelect extends StatelessWidget {
  /// The initial value
  final bool isPublicVisible;

  /// The callback when the value is changed
  final Function(bool isPublic) onChanged;

  /// Determines whether the value can be changed
  ///
  /// An existing [Task] can only be published but not unpublished
  final bool isCreating;

  /// The [TextStyle] for the [PopupMenuButton] and the [PopupMenuItem]s
  final TextStyle? textStyle;

  const VisibilitySelect({
    super.key,
    required this.isPublicVisible,
    this.isCreating = false,
    required this.onChanged,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        if (isCreating || !isPublicVisible)
          {
            showModalBottomSheet(
              context: context,
              builder: (context) => _VisibilityBottomSheet(
                onChange: onChanged,
              ),
            )
          }
      },
      child: Text(
        isPublicVisible ? context.localization!.public : context.localization!.private,
        style: textStyle,
      ),
    );
  }
}
