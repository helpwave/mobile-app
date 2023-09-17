import 'package:flutter/material.dart';
import 'package:helpwave_theme/constants.dart';

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
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: widget.options.length,
      separatorBuilder: (_, __) => Container(
        width: distanceSmall,
      ),
      itemBuilder: (context, index) => ChoiceChip(
        label: widget.options[index] == selectedOption
            // TODO do this more elegantly
            ? Text(
                widget.labeling(widget.options[index]),
                style: const TextStyle(color: Colors.white),
              )
            : Text(widget.labeling(widget.options[index])),
        selected: widget.options[index] == selectedOption,
        onSelected: (value) {
          if (value) {
            setState(() {
              selectedOption = widget.options[index];
            });
            widget.onChange(widget.options[index]);
          } else if (selectedOption == widget.options[index] &&
              widget.allowDeselection) {
            setState(() {
              selectedOption = null;
            });
          }
        },
      ),
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
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: widget.options.length,
      separatorBuilder: (_, __) => Container(
        width: distanceSmall,
      ),
      itemBuilder: (context, index) => ChoiceChip(
        label: Text(widget.labeling(widget.options[index])),
        selected: selection.contains(widget.options[index]),
        onSelected: (value) {
          List<T> newSelection = [];
          if (value && !selection.contains(widget.options[index])) {
            newSelection = [...selection, widget.options[index]];
          } else {
            newSelection = selection
                .where((element) => element != widget.options[index])
                .toList();
          }
          setState(() {
            selection = newSelection;
          });
          widget.onChange(newSelection);
        },
      ),
    );
  }
}
