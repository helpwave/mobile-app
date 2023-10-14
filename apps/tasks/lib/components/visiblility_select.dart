import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:tasks/dataclasses/task.dart';

/// A [Widget] for changing the Visibility of a [Task]
class VisibilitySelect extends StatelessWidget {
  /// The initial value
  final bool isPublicVisible;

  /// The callback when the value is changed
  final Function(bool value) onChanged;

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
    return PopupMenuButton(
      initialValue: isPublicVisible,
      enabled: isCreating || !isPublicVisible,
      onSelected: (value) => {
        if (value != isPublicVisible) {onChanged(value)}
      },
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            value: true,
            child: Text(
              context.localization!.public,
              style: textStyle,
            ),
          ),
          PopupMenuItem(
            value: false,
            child: Text(
              context.localization!.private,
              style: textStyle,
            ),
          ),
        ];
      },
      child: Text(
        isPublicVisible ? context.localization!.public : context.localization!.private,
        style: textStyle,
      ),
    );
  }
}
