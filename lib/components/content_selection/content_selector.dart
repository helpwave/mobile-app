import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:helpwave/components/content_selection/list_entry.dart';
import 'package:helpwave/components/content_selection/list_search.dart';
import 'package:helpwave/styling/constants.dart';

class ContentSelector<V> extends StatefulWidget {
  final String title;
  final Icon icon;
  final Map<String, V> initialValues;
  final void Function(Map<String, V> map) changedList;
  final double columLeftPadding;
  final String? selectionLabelText;
  final List<V> selectionItems;
  final String? searchTitle;
  final List<String>? searchIgnoreList;
  final List<String>? searchOptions;
  final Widget Function(BuildContext context, String result)?
      searchResultTileBuilder;
  final Future<List<String>> Function(String searched, List<String> ignoreList)?
      loadAsyncSearchOptions;
  final V? selectionDefaultValue;
  final bool allowSelectAnyWay;
  final String Function(V value)? valueToString;
  final double? selectWidth;
  final DropdownMenuItem<V> Function(V value, String name)?
      selectValueItemBuilder;
  final String? searchElementName;

  const ContentSelector({
    super.key,
    required this.title,
    required this.icon,
    required this.selectionItems,
    required this.changedList,
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
    this.searchOptions,
    this.searchResultTileBuilder,
    this.loadAsyncSearchOptions,
    this.searchElementName,
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
    assert(
        widget.selectValueItemBuilder != null || widget.valueToString != null);
    List<Widget> children = <Widget>[];
    if (isExpanded) {
      currentSelection.forEach(
        (key, value) => children.add(
          ListEntry(
            labelText: widget.selectionLabelText ?? "",
            name: key,
            value: value,
            allValues: widget.selectionItems,
            valueToString: widget.valueToString,
            selectWidthCustom: widget.selectWidth,
            selectValueItemBuilder: widget.selectValueItemBuilder,
            deleteClicked: (deletedValue) {
              setState(() {
                currentSelection.remove(deletedValue);
              });
              widget.changedList(currentSelection);
            },
            changedSelection: (name, value) {
              setState(() {
                currentSelection.update(name, (_) => value,
                    ifAbsent: () => value);
              });
              widget.changedList(currentSelection);
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
                  ignoreList:
                      widget.searchIgnoreList ?? currentSelection.keys.toList(),
                  items: widget.searchOptions ?? [],
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
              widget.changedList(currentSelection);
            });
          },
          icon: const Icon(Icons.add),
        ),
      );
    }

    return Column(
      children: [
        ListTile(
          title: Text(widget.title),
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
