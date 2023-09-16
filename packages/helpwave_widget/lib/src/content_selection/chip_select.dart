import 'package:flutter/material.dart';

/// A Component for selecting an option with [ActionChip]s
class SingleChipSelect extends StatefulWidget {
  const SingleChipSelect({
    super.key,
    required this.options,
    required this.onChange,
    this.initialSelection,
  });

  /// The value of the initial selection
  final String? initialSelection;

  /// The list of all options
  final List<String> options;

  /// Callback for changes
  final void Function(String) onChange;

  @override
  State<StatefulWidget> createState() => _SingleChipSelectState();
}

class _SingleChipSelectState extends State<SingleChipSelect> {
  String? selectedOption;

  @override
  void initState() {
    if (widget.initialSelection != null) {
      assert (widget.options.contains(widget.initialSelection));
      setState(() {
        selectedOption = widget.initialSelection;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: widget.options.map((option) =>
          ChoiceChip(
            label: Text(option),
            selected: option == selectedOption,
            onSelected: (value) {
              setState(() {
                selectedOption = option;
              });
              widget.onChange(option);
            },)
      ).toList(),
    );
  }
}
