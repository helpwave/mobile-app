import 'package:flutter/material.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_theme/util.dart';
import 'package:helpwave_widget/src/text_input/text_form_field_with_timer.dart';

/// A Widget that is a normal [TextFormField], but has no border
class ClickableTextEdit extends StatefulWidget {
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
  /// color: context.theme.colorScheme.primary,
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
  State<StatefulWidget> createState() => _ClickableTextEditState();
}

class _ClickableTextEditState extends State<ClickableTextEdit> {
  final FocusNode _focusNode = FocusNode();
  bool isEditing = false;
  String? currentValue;

  @override
  void initState() {
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() {
          isEditing = false;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const borderTheme = OutlineInputBorder(
      gapPadding: 0,
      borderSide: BorderSide.none,
    );

    TextStyle usedTextStyle = widget.textStyle ??
        TextStyle(
          color: context.theme.colorScheme.primary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        );

    return Theme(
      data: context.theme.copyWith(
        inputDecorationTheme: const InputDecorationTheme(
          contentPadding: EdgeInsets.zero,
          border: borderTheme,
          enabledBorder: borderTheme,
          focusedBorder: borderTheme,
          disabledBorder: borderTheme,
          errorBorder: borderTheme,
          focusedErrorBorder: borderTheme,
        ),
      ),
      child: isEditing
          ? TextFormFieldWithTimer(
              key: widget.formKey,
              initialValue: widget.initialValue,
              onChanged: (value) {
                setState(() => value);
                if (widget.onChanged != null) {
                  widget.onChanged!(value);
                }
              },
              onUpdate: (value) {
                setState(() => value);
                if (widget.onUpdated != null) {
                  widget.onUpdated!(value);
                }
              },
              style: usedTextStyle,
              textAlign: widget.textAlign,
              focusNode: _focusNode,
              autofocus: true,
            )
          : GestureDetector(
              onTap: () => setState(() {
                isEditing = true;
              }),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: distanceTiny),
                    child: SizedBox(width: iconSizeTiny),
                  ),
                  Flexible(
                    child: Text(
                      currentValue ?? widget.initialValue ?? "",
                      style: usedTextStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: distanceTiny),
                    child: Icon(Icons.edit, size: iconSizeTiny),
                  ),
                ],
              ),
            ),
    );
  }
}
