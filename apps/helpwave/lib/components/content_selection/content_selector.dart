import 'package:flutter/material.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave/components/content_selection/list_entry.dart';
import 'package:helpwave/components/content_selection/list_search.dart';

/// Manages and updates a map of entries with a build in search function
///
/// IMPORTANT: If [selectionItems] is omitted or Empty the selection wont be displayed
///
/// See also [ListEntry],[ListSearch]
///
/// Example with select:
///
/// ```dart
/// ContentSelector(
///   title: "Weather Stations",
///   icon: Icon(Icons.ac_unit),
///   selectionItems: [{"weather": "cold"},{"weather": "warm"}, {"weather": "hot"}],
///   onChangedList: print,
///   equalityCheck: (value1, value2) => value1["weather"] == value2["weather"],
///   valueToString: (value) => value["weather"]!,
///   loadAsyncSearchOptions: (searched, ignoreList) async {
///     String searchInLower = searched.toLowerCase();
///     List < String > result = [];
///     List < String > filteredSearchOptions = ["Louisiana","New York","Tokyo","Berlin"];
///     filteredSearchOptions
///       .retainWhere((element) => !ignoreList.contains(element));
///     for (var element in filteredSearchOptions) {
///       if (!filteredSearchOptions.contains(searched) &&
///           element.toLowerCase().startsWith(searchInLower)) {
///         result.add(element);
///       }
///     }
///     return result;
///   },
/// )
/// ```
///
/// Example without select:
///  - IMPORTANT: omit [selectionItems] to not display a SelectButton here
///
/// ```dart
/// ContentSelector < int >(
///   selectionDefaultValue:0,
/// )
/// ```
class ContentSelector<V> extends StatefulWidget {
  /// The displayed Title of the expandable Header of the List
  final String? title;

  /// The icon displayed at beginning of the Header
  final Icon? icon;

  /// The Map with the initial values
  final Map<String, V> initialValues;

  /// called when the entries are updated and returns the updated map
  final void Function(Map<String, V> map)? onChangedList;

  /// The Left Indentation of the Entries in regard to the Header
  final double columLeftPadding;

  /// The Default Value for the selection when adding a new Entry
  final V? selectionDefaultValue;

  // -- SEARCH --
  /// The Title displayed in the AppBar of the Search
  final String? searchTitle;

  /// Function for filtering unwanted items, only keeps values with true
  final bool Function(String value)? searchFilter;

  /// The List of all Options for a search
  ///
  /// Combines with [searchAsyncItems]
  final List<String>? searchItems;

  /// This Function returns the list of search items for a search
  ///
  /// Combines with [searchItems]
  final Future<List<String>> Function(String searched)? searchAsyncItems;

  /// Custom builder for displaying a single search result
  ///
  /// IMPORTANT: This disables navigation pops on clicking a result, but can be implemented in the function
  ///
  /// IMPORTANT: Overwrites default display of search results
  final Widget Function(BuildContext context, String result)? searchResultTileBuilder;

  /// Allow adding user input, if filtered search items are empty for a given search
  final bool searchAllowSelectAnyway;

  /// The name of the searched elements e.g. Medication, Name or Color
  ///
  /// Displayed when no search entry is found
  final String? searchElementName;

  /// Whether [searchItems] are displayed as a Multi-Select
  final bool isMultiSelect;

  // -- SELECT --
  /// The items of the Selection
  ///
  /// IMPORTANT: If omitted or Empty the selection wont be displayed
  final List<V> selectionItems;

  /// Maps the value to a displayable String for the Selection
  ///
  /// IMPORTANT: Overwritten by [selectValueItemBuilder]
  final String Function(V value)? valueToString;

  /// The width of the Select
  final double? selectWidth;

  /// A Custom builder for the DropDownItems in the select
  ///
  /// IMPORTANT: Overwrites [valueToString]
  final DropdownMenuItem<V> Function(V value, String name)? selectValueItemBuilder;

  /// The LabelText of the Selection Drop-Down
  final String? selectionLabelText;

  /// Some more Complex Objects cause issues with the native dropDown
  final bool Function(V value1, V value2)? equalityCheck;

  const ContentSelector({
    super.key,
    this.title,
    this.icon = const Icon(Icons.list),
    this.initialValues = const {},
    this.onChangedList,
    this.columLeftPadding = distanceDefault,
    this.selectionDefaultValue,
    this.searchTitle,
    this.searchFilter,
    this.searchItems,
    this.searchAsyncItems,
    this.searchResultTileBuilder,
    this.searchAllowSelectAnyway = true,
    this.searchElementName,
    this.isMultiSelect = false,
    this.selectionItems = const [],
    this.valueToString,
    this.selectWidth,
    this.selectValueItemBuilder,
    this.selectionLabelText,
    this.equalityCheck,
  });

  @override
  State<StatefulWidget> createState() => _ContentSelectorState<V>();
}

class _ContentSelectorState<V> extends State<ContentSelector<V>> {
  bool isExpanded = false;
  Map<String, V> currentSelection = <String, V>{};

  @override
  void initState() {
    super.initState();
    widget.initialValues.forEach((key, value) {
      currentSelection.update(key, (_) => value, ifAbsent: () => value);
    });
  }

  List<String> getItems() {
    List<String> items = [];
    if (widget.searchItems != null) {
      items.addAll(widget.searchItems!);
    }
    for (var element in currentSelection.keys) {
      if (!items.contains(element)) {
        items.add(element);
      }
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    assert(widget.selectValueItemBuilder != null ||
        widget.valueToString != null ||
        (widget.selectionItems.isNotEmpty || widget.selectionDefaultValue != null));
    List<Widget> children = <Widget>[];
    if (isExpanded) {
      currentSelection.forEach(
        (key, value) => children.add(
          ListEntry<V>(
            labelText: widget.selectionLabelText ?? "",
            name: key,
            value: value,
            items: widget.selectionItems,
            valueToString: widget.valueToString,
            selectWidthCustom: widget.selectWidth,
            selectValueItemBuilder: widget.selectValueItemBuilder,
            equalityCheck: widget.equalityCheck,
            onDeleteClicked: (deletedValue) {
              setState(() {
                currentSelection.remove(deletedValue);
              });
              if (widget.onChangedList != null) {
                widget.onChangedList!(currentSelection);
              }
            },
            onChangedSelection: (name, value) {
              setState(() {
                currentSelection.update(name, (_) => value, ifAbsent: () => value);
              });
              if (widget.onChangedList != null) {
                widget.onChangedList!(currentSelection);
              }
            },
          ),
        ),
      );
      children.add(
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ListSearch<String>(
                  title: widget.searchTitle ??
                      context.localization!.listSearch,
                  filter: widget.searchFilter,
                  items: getItems(),
                  asyncItems: widget.searchAsyncItems,
                  resultTileBuilder: widget.searchResultTileBuilder,
                  elementToString: (String t) => t,
                  allowSelectAnyway: widget.searchAllowSelectAnyway,
                  searchElementName: widget.searchElementName,
                  isMultiSelect: widget.isMultiSelect,
                  selected: currentSelection.keys.toList(),
                ),
              ),
            ).then((value) {
              if (value == null) {
                return;
              }
              if (!widget.isMultiSelect && value == "") {
                return;
              }
              setState(() {
                List<String> list = [];
                if (widget.isMultiSelect) {
                  if (value.runtimeType == "".runtimeType) {
                    if (value.trim() != "") {
                      setState(() {
                        currentSelection.update(value, (oldValue) => oldValue,
                            ifAbsent: () => widget.selectionDefaultValue ?? widget.selectionItems[0]);
                      });
                    }
                    return;
                  }
                  list = value;
                  currentSelection.removeWhere((key, _) => !list.contains(key));
                } else {
                  list.add(value);
                }
                for (var element in list) {
                  if (!currentSelection.containsKey(element)) {
                    currentSelection.update(element, (value) => value,
                        ifAbsent: () => widget.selectionDefaultValue ?? widget.selectionItems[0]);
                  }
                }
              });
              if (widget.onChangedList != null) {
                widget.onChangedList!(currentSelection);
              }
            });
          },
          icon: const Icon(Icons.add),
        ),
      );
    }

    return Column(
      children: [
        ListTile(
          title: Text(widget.title ?? context.localization!.list),
          subtitle: Text(
              "${currentSelection.length} ${context.localization!.entries}"),
          leading: widget.icon,
          trailing: IconButton(
            icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
            onPressed: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
          ),
        ),
        isExpanded
            ? Padding(
                padding: EdgeInsets.only(left: widget.columLeftPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: children,
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
