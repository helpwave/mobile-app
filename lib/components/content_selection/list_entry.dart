import 'package:flutter/material.dart';
import 'package:helpwave/components/content_selection/content_selector.dart';
import '../../styling/constants.dart';

/// The ListEntry used by [ContentSelector]
class ListEntry<V> extends StatelessWidget {
  /// Name in front of the entry
  final String name;

  /// The Value of the Entry
  final V value;

  /// The items of the Selection
  /// IMPORTANT: If omitted or Empty the selection wont be displayed
  final List<V> items;

  /// The LabelText of the Selection Drop-Down
  final String labelText;

  /// Maps the value to a displayable String for the Selection
  /// IMPORTANT: Overwritten by [selectValueItemBuilder]
  final String Function(V value)? valueToString;

  /// A Custom builder for the DropDownItems in the select
  /// IMPORTANT: Overwrites [valueToString]
  final DropdownMenuItem<V> Function(V value, String name)?
      selectValueItemBuilder;

  /// Callback when a Entry is deleted
  final void Function(String name) onDeleteClicked;

  /// Callback when a Entry's Selection is changed
  final void Function(String name, V value) onChangedSelection;

  /// The width of the Select
  late final double? selectWidth;

  ListEntry({
    super.key,
    required this.labelText,
    required this.name,
    required this.value,
    required this.items,
    required this.onDeleteClicked,
    required this.onChangedSelection,
    this.valueToString,
    this.selectValueItemBuilder,
    double? selectWidthCustom,
  }) {
    selectWidth = selectWidthCustom ?? 180;
  }

  @override
  Widget build(BuildContext context) {
    assert(items.isEmpty ||
        selectValueItemBuilder != null ||
        valueToString != null);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: distanceSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              "- $name",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              items.isNotEmpty
                  ? SizedBox(
                      width: selectWidth,
                      child: DropdownButtonFormField<V>(
                        value: value,
                        items: items
                            .map((e) => DropdownMenuItem<V>(
                                  value: e,
                                  child: valueToString != null
                                      ? Text(valueToString!(e))
                                      : selectValueItemBuilder!(e, name),
                                ))
                            .toList(),
                        onChanged: (value) {
                          onChangedSelection(name, value as V);
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                              left: dropDownVerticalPadding,
                              right: dropDownVerticalPadding),
                          labelText: labelText,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    )
                  : const SizedBox(),
              IconButton(
                onPressed: () {
                  onDeleteClicked(name);
                },
                icon: const Icon(
                  Icons.delete,
                  size: iconSizeSmall,
                  color: negativeColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
