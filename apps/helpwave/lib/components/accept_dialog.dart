import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';

/// Dialog for accepting or declining
class AcceptDialog extends StatelessWidget {
  /// String to display as a Title
  ///
  /// Overwritten by [title]
  final String? titleText;

  /// Title to display
  ///
  /// Overwrites [titleText]
  final Widget? title;

  /// Widget that will be displayed between Title and Options
  final Widget? content;

  const AcceptDialog({
    super.key,
    this.titleText,
    this.title,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title ?? Text(titleText ?? context.localization!.acceptQuestion),
      content: content,
      actions: [
        TextButton(
          child: Text(context.localization!.yes),
          onPressed: () => Navigator.of(context).pop(true),
        ),
        TextButton(
          child: Text(context.localization!.no),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ],
    );
  }
}
