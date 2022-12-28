import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:helpwave/components/content_selection/list_entry.dart';
import 'package:helpwave/components/content_selection/list_search.dart';
import 'package:helpwave/styling/constants.dart';

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

  /// The List of SearchItems that should be ignored
  final List<String>? searchIgnoreList;

  /// The List of all Items for the Search
  final List<String>? searchItems;

  /// Custom builder for displaying a single search result
  final Widget Function(BuildContext context, String result)?
      searchResultTileBuilder;

  /// This Function returns the list of search results for [searched]
  final Future<List<String>> Function(String searched, List<String> ignoreList)?
      loadAsyncSearchOptions;

  /// The name of the searched Elements e.g. Medication, Name or Color
  final String? searchElementName;

  /// Allow adding user input not found in the search list
  final bool allowSelectAnyWay;

  // -- SELECT --
  /// Maps the value to a displayable String for the Selection
  /// IMPORTANT: Overwritten by [selectValueItemBuilder]
  final String Function(V value)? valueToString;

  /// The width of the Select
  final double? selectWidth;

  /// A Custom builder for the DropDownItems in the select
  /// IMPORTANT: Overwrites [valueToString]
  final DropdownMenuItem<V> Function(V value, String name)?
      selectValueItemBuilder;

  /// The LabelText of the Selection Drop-Down
  final String? selectionLabelText;

  /// The items of the Selection
  /// IMPORTANT: If omitted or Empty the selection wont be displayed
  final List<V> selectionItems;

  /// Some more Complex Objects cause issues with the native dropDown
  final bool Function(V value1, V value2)? equalityCheck;

  const ContentSelector({
    super.key,
    this.onChangedList,
    this.selectionItems = const [],
    this.title,
    this.icon = const Icon(Icons.list),
    this.selectWidth,
    this.valueToString,
    this.selectionLabelText,
    this.selectionDefaultValue,
    this.selectValueItemBuilder,
    this.allowSelectAnyWay = true,
    this.initialValues = const {},
    this.columLeftPadding = distanceDefault,
    this.searchTitle,
    this.searchIgnoreList,
    this.searchItems,
    this.searchResultTileBuilder,
    this.loadAsyncSearchOptions,
    this.searchElementName,
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

  @override
  Widget build(BuildContext context) {
    assert(widget.selectValueItemBuilder != null ||
        widget.valueToString != null ||
        (widget.selectionItems.isNotEmpty ||
            widget.selectionDefaultValue != null));
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
                currentSelection.update(name, (_) => value,
                    ifAbsent: () => value);
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
                      AppLocalizations.of(context)!.listSearch,
                  ignoreList: widget.searchIgnoreList != null
                      ? widget.searchIgnoreList! +
                          currentSelection.keys.toList()
                      : currentSelection.keys.toList(),
                  items: widget.searchItems ?? [],
                  resultTileBuilder: widget.searchResultTileBuilder,
                  elementToString: (String t) => t,
                  asyncFilteredSearchOptions: widget.loadAsyncSearchOptions,
                  allowSelectAnyway: widget.allowSelectAnyWay,
                  searchElementName: widget.searchElementName,
                ),
              ),
            ).then((newName) {
              setState(() {
                currentSelection.update(newName, (value) => value,
                    ifAbsent: () =>
                        widget.selectionDefaultValue ??
                        widget.selectionItems[0]);
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
          title: Text(widget.title ?? AppLocalizations.of(context)!.list),
          subtitle: Text(
              "${currentSelection.length} ${AppLocalizations.of(context)!.entries}"),
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
        const SizedBox(height: distanceDefault),
      ],
    );
  }
}
