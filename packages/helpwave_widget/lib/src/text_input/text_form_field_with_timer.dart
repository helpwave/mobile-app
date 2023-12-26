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

  const TextFormFieldWithTimer({
    super.key,
    required this.initialValue,
    this.onChanged,
    this.onUpdate,
    this.timerDuration = const Duration(seconds: 3),
    this.style,
    this.textAlign = TextAlign.left,
    this.maxLines,
    this.decoration,
  });

  @override
  State<StatefulWidget> createState() => _TextFormFieldWithTimerState();
}

class _TextFormFieldWithTimerState extends State<TextFormFieldWithTimer> {
  final FocusNode _focusNode = FocusNode();
  TimedValueUpdater<String>? valueUpdater;

  @override
  void initState() {
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
    _focusNode.dispose();
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
    );
  }
}
