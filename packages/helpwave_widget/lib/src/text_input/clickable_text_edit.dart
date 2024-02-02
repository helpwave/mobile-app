import 'package:flutter/material.dart';
import 'package:helpwave_widget/src/text_input/text_form_field_with_timer.dart';

/// A Widget that is a normal [TextFormField], but has no border
class ClickableTextEdit extends StatelessWidget {
  /// The [Key] when integrating this into a [Form]
  final Key? formKey;

  /// The initial text value
  final String? initialValue;

  /// The callback when the value is changed
  final Function(String value)? onChanged;

  /// The callback when the value is updated
  final Function(String value)? onUpdated;

  /// The [TextStyle] to be used
  ///
  /// The default uses:
  ///
  /// ```dart
  /// color: Theme.of(context).colorScheme.secondary,
  /// fontSize: 20,
  /// fontWeight: FontWeight.w700
  /// ```
  final TextStyle? textStyle;

  /// The [TextAlign] to be used
  final TextAlign textAlign;

  const ClickableTextEdit({
    super.key,
    this.onChanged,
    this.onUpdated,
    this.formKey,
    this.initialValue,
    this.textStyle,
    this.textAlign = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    const borderTheme = OutlineInputBorder(
      gapPadding: 0,
      borderSide: BorderSide.none,
    );

    return Theme(
      data: ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
            contentPadding: EdgeInsets.zero,
            border: borderTheme,
            enabledBorder: borderTheme,
            focusedBorder: borderTheme,
            disabledBorder: borderTheme,
            errorBorder: borderTheme,
            focusedErrorBorder: borderTheme),
      ),
      child: TextFormFieldWithTimer(
        key: formKey,
        initialValue: initialValue,
        onChanged: onChanged,
        onUpdate: onUpdated,
        style: textStyle ??
            TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 20, fontWeight: FontWeight.w700),
        textAlign: textAlign,
      ),
    );
  }
}
