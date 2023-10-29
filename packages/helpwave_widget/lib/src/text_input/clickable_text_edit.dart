import 'package:flutter/material.dart';
import 'package:helpwave_theme/constants.dart';

/// A Widget that is a normal [TextFormField], but has no border
class ClickableTextEdit extends StatelessWidget {
  /// The [Key] when integrating this into a [Form]
  final Key? formKey;

  /// The initial text value
  final String? initialValue;

  /// The callback when the value is changed
  final Function(String value)? onChanged;

  /// The [TextStyle] to be used
  final TextStyle? textStyle;

  /// The [TextAlign] to be used
  final TextAlign textAlign;

  const ClickableTextEdit({
    super.key,
    this.onChanged,
    this.formKey,
    this.initialValue,
    this.textStyle = const TextStyle(
        color: primaryColor, fontSize: 20, fontWeight: FontWeight.w700),
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
      child: TextFormField(
        key: formKey,
        initialValue: initialValue,
        onChanged: onChanged,
        style: textStyle,
        textAlign: textAlign,
      ),
    );
  }
}
