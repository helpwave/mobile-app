import 'package:flutter/material.dart';
import 'package:helpwave_util/time.dart';

/// A [TextFormField] with a timer to trigger, when no changes were made in some seconds
class TextFormFieldWithTimer extends StatefulWidget {
  final String? initialValue;
  final void Function(String value)? onChanged;
  final void Function(String value)? onUpdate;
  final Duration timerDuration;
  final TextStyle? style;
  final TextAlign textAlign;
  final int? maxLines;
  final InputDecoration? decoration;
  final FocusNode? focusNode;
  final bool autofocus;
  final TextInputAction? textInputAction;

  const TextFormFieldWithTimer(
      {super.key,
      required this.initialValue,
      this.onChanged,
      this.onUpdate,
      this.timerDuration = const Duration(seconds: 3),
      this.style,
      this.textAlign = TextAlign.left,
      this.maxLines,
      this.decoration,
      this.focusNode,
      this.autofocus = false,
      this.textInputAction});

  @override
  State<StatefulWidget> createState() => _TextFormFieldWithTimerState();
}

class _TextFormFieldWithTimerState extends State<TextFormFieldWithTimer> {
  late final FocusNode _focusNode;
  TimedValueUpdater<String>? valueUpdater;

  @override
  void initState() {
    _focusNode = widget.focusNode ?? FocusNode();

    if (widget.onUpdate != null) {
      valueUpdater = TimedValueUpdater(
        widget.initialValue ?? "",
        callback: (value) {
          widget.onUpdate!(value);
          _focusNode.unfocus();
        },
        timeToCallback: widget.timerDuration,
      );
      _focusNode.addListener(() {
        if (!_focusNode.hasFocus) {
          valueUpdater!.cancelTimer(isNotifying: true);
        }
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    valueUpdater?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: _focusNode,
      initialValue: valueUpdater?.value ?? widget.initialValue,
      onChanged: (value) {
        valueUpdater?.value = value;
        if (widget.onChanged != null) {
          widget.onChanged!(value);
        }
      },
      style: widget.style,
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
      decoration: widget.decoration,
      autofocus: widget.autofocus,
      textInputAction: widget.textInputAction ?? (widget.maxLines == 1 ? TextInputAction.done : null),
    );
  }
}
