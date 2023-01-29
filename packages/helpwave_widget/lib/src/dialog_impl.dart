import 'package:flutter/material.dart';

/// Dialog for accepting or declining
class AcceptDialog<V> extends StatelessWidget {
  /// Text for a positive answer
  final String? yesText;

  /// Text for a negative answer
  final String? noText;

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
    this.yesText,
    this.noText,
    this.titleText,
    this.title,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title ?? Text(titleText ?? ""),
      content: content,
      actions: [
        TextButton(
          child: Text(yesText ?? "Yes"),
          onPressed: () => Navigator.of(context).pop(true),
        ),
        TextButton(
          child: Text(noText ?? "No"),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ],
    );
  }
}
