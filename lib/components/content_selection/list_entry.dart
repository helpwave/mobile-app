import 'package:flutter/material.dart';
import '../../styling/constants.dart';

class ListEntry<V> extends StatelessWidget {
  final String labelText;
  final String name;
  final V value;
  final List<V> allValues;
  final String Function(V value)? valueToString;
  final DropdownMenuItem<V> Function(V value, String name)?
      selectValueItemBuilder;
  final void Function(String name) deleteClicked;
  final void Function(String name, V value) changedSelection;
  late final double? selectWidth;

  ListEntry({
    super.key,
    required this.labelText,
    required this.name,
    required this.value,
    required this.allValues,
    required this.deleteClicked,
    required this.changedSelection,
    this.valueToString,
    this.selectValueItemBuilder,
    double? selectWidthCustom,
  }) {
    selectWidth = selectWidthCustom ?? 180;
  }

  @override
  Widget build(BuildContext context) {
    assert(selectValueItemBuilder != null || valueToString != null);
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
              SizedBox(
                width: selectWidth,
                child: DropdownButtonFormField<V>(
                  value: value,
                  items: allValues
                      .map((e) => DropdownMenuItem<V>(
                            value: e,
                            child: valueToString != null
                                ? Text(valueToString!(e))
                                : selectValueItemBuilder!(e, name),
                          ))
                      .toList(),
                  onChanged: (value) {
                    changedSelection(name, value as V);
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(
                        left: dropDownVerticalPadding,
                        right: dropDownVerticalPadding),
                    labelText: labelText,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  deleteClicked(name);
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
