import 'package:flutter/material.dart';

/// A Component for selecting an option with [ActionChip]s
class SingleChipSelect<T> extends StatefulWidget {
  const SingleChipSelect(
      {super.key,
      required this.options,
      required this.onChange,
      required this.labeling,
      this.initialSelection,
      this.allowDeselection = false});

  /// The value of the initial selection
  final T? initialSelection;

  /// The list of all options
  final List<T> options;

  /// Labeling function for the chips
  final String Function(T value) labeling;

  /// Callback for changes
  final void Function(T? value) onChange;

  /// Whether the user can deselect a chip
  final bool allowDeselection;

  @override
  State<StatefulWidget> createState() => _SingleChipSelectState<T>();
}

class _SingleChipSelectState<T> extends State<SingleChipSelect<T>> {
  T? selectedOption;

  @override
  void initState() {
    if (widget.initialSelection != null) {
      assert(widget.options.contains(widget.initialSelection));
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
      children: widget.options
          .map((option) => ChoiceChip(
                label: option == selectedOption
                    // TODO do this more elegantly
                    ? Text(
                        widget.labeling(option),
                        style: const TextStyle(color: Colors.white),
                      )
                    : Text(widget.labeling(option)),
                selected: option == selectedOption,
                onSelected: (value) {
                  if (value) {
                    setState(() {
                      selectedOption = option;
                    });
                    widget.onChange(option);
                  } else if (selectedOption == option &&
                      widget.allowDeselection) {
                    setState(() {
                      selectedOption = null;
                    });
                  }
                },
              ))
          .toList(),
    );
  }
}

/// A Component for selecting multiple options with [ActionChip]s
class MultipleChipSelect<T> extends StatefulWidget {
  const MultipleChipSelect({
    super.key,
    required this.options,
    required this.onChange,
    required this.labeling,
    this.initialSelection = const [],
  });

  /// The value of the initial selection
  final List<T> initialSelection;

  /// The list of all options
  final List<T> options;

  /// Labeling function for the chips
  final String Function(T) labeling;

  /// Callback for changes
  final void Function(List<T>) onChange;

  @override
  State<StatefulWidget> createState() => _MultipleChipSelectState();
}

class _MultipleChipSelectState<T> extends State<MultipleChipSelect<T>> {
  List<T> selection = [];

  @override
  void initState() {
    if (widget.initialSelection.isNotEmpty) {
      assert(widget.initialSelection
          .every((element) => widget.options.contains(element)));
      setState(() {
        selection = widget.initialSelection;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: widget.options
          .map((option) => ChoiceChip(
                label: Text(widget.labeling(option)),
                selected: option == selection,
                onSelected: (value) {
                  List<T> newSelection = [];
                  if (value && !selection.contains(option)) {
                    newSelection = [...selection, option];
                  } else {
                    newSelection = selection
                        .where((element) => element != option)
                        .toList();
                  }
                  setState(() {
                    selection = newSelection;
                  });
                  widget.onChange(newSelection);
                },
              ))
          .toList(),
    );
  }
}
