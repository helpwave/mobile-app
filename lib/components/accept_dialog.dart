import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      title: title ??
          Text(titleText ?? AppLocalizations.of(context)!.acceptQuestion),
      content: content,
      actions: [
        TextButton(
          child: Text(AppLocalizations.of(context)!.yes),
          onPressed: () => Navigator.of(context).pop(true),
        ),
        TextButton(
          child: Text(AppLocalizations.of(context)!.no),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ],
    );
  }
}
