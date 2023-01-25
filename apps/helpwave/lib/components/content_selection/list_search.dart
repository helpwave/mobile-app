import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave/styling/constants.dart';

/// A customizable Search within a List
///
/// Values need to be mapped to String with [elementToString]
///
/// Should be used with
/// [Navigator.push] and [Navigator.pop] with the latter returning the result
class ListSearch<T> extends StatefulWidget {
  /// The Title displayed in the AppBar of the Search
  final String? title;

  /// Function for filtering unwanted items, only keeps values with true
  final bool Function(T value)? filter;

  /// The List of all Options for a search
  ///
  /// Combines with [asyncItems]
  final List<T> items;

  /// This Function returns the list of search items for a search
  ///
  /// Combines with [items]
  final Future<List<T>> Function(String searched)? asyncItems;

  /// Maps Elements to String
  ///
  /// Used by default display of search result
  final String Function(T element) elementToString;

  /// Custom builder for displaying a single search result
  ///
  /// IMPORTANT: This disables navigation pops on clicking a result, but can be implemented in the function
  ///
  /// IMPORTANT: Overwrites default display of search results
  final Widget Function(BuildContext context, T result)? resultTileBuilder;

  /// Allow adding user input, if filtered search items are empty for a given search
  final bool allowSelectAnyway;

  /// The name of the searched elements e.g. Medication, Name or Color
  ///
  /// Displayed when no search entry is found
  final String? searchElementName;

  // Multi Select

  /// Whether [items] are displayed as a Multi-Select
  final bool isMultiSelect;

  /// Subset of [items] that are selected in a Multi-Select ([isMultiSelect] == true)
  final List<T> selected;

  const ListSearch({
    super.key,
    required this.elementToString,
    this.title,
    this.resultTileBuilder,
    this.allowSelectAnyway = false,
    this.filter,
    this.items = const [],
    this.asyncItems,
    this.searchElementName,
    this.isMultiSelect = false,
    this.selected = const [],
  });

  @override
  State<StatefulWidget> createState() => _ListSearchState<T>();
}

class _ListSearchState<T> extends State<ListSearch<T>> {
  final TextEditingController _searchController = TextEditingController();
  List<T> selected = [];

  @override
  initState() {
    if (widget.isMultiSelect) {
      selected.addAll(widget.selected);
    }
    super.initState();
  }

  /// returns the search result and applies [filter]
  Future<List<T>> getSearchResults(String searched) async {
    searched = searched.trim();
    List<T> result = [];
    if (widget.asyncItems != null) {
      await widget.asyncItems!(searched).then((value) => result = value);
    }
    result.addAll(widget.items.where((element) => !result.contains(element)));

    if (widget.filter != null) {
      result = result.where(widget.filter!).toList();
    }
    searched = searched.toLowerCase();
    result = result
        .where(
          (element) => widget.elementToString(element).trim().toLowerCase().startsWith(searched),
        )
        .toList();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.isMultiSelect) {
          Navigator.of(context).pop(selected);
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? context.localization!.searchNoun),
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: distanceSmall,
                  vertical: distanceDefault,
                ),
                child: TextFormField(
                  onChanged: (_) => {setState(() {})},
                  controller: _searchController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () => {
                        setState(() {
                          _searchController.clear();
                        })
                      },
                      icon: const Icon(Icons.close),
                    ),
                    hintText: context.localization!.search,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              FutureBuilder(
                future: getSearchResults(_searchController.text),
                builder: (context, snapshot) {
                  List<Widget> children = [];
                  if (snapshot.hasData) {
                    if (snapshot.data!.isNotEmpty) {
                      if (!widget.isMultiSelect && widget.resultTileBuilder != null) {
                        children =
                            snapshot.data!.map((element) => widget.resultTileBuilder!(context, element)).toList();
                      } else {
                        children = snapshot.data!.map((element) {
                          return ListTile(
                            title: Text(widget.elementToString(element)),
                            trailing: widget.isMultiSelect
                                ? Checkbox(
                                    onChanged: (value) {
                                      setState(() {
                                        if (value!) {
                                          selected.add(element);
                                        } else {
                                          selected.remove(element);
                                        }
                                      });
                                    },
                                    value: selected
                                        .contains(element), // TODO use equal check contains potentially always false
                                  )
                                : const SizedBox(),
                            onTap: () {
                              if (!widget.isMultiSelect) {
                                Navigator.of(context).pop(element);
                                return;
                              }
                              // TODO use equal check contains potentially always false
                              setState(() {
                                if (selected.contains(element)) {
                                  selected.remove(element);
                                } else {
                                  selected.add(element);
                                }
                              });
                            },
                          );
                        }).toList();
                      }
                    } else {
                      children.add(Center(
                        child: Column(
                          children: [
                            const SizedBox(height: distanceBig),
                            Text(
                              "${widget.searchElementName ?? _searchController.text} ${context.localization!.notFound}",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: distanceDefault),
                            widget.allowSelectAnyway
                                ? TextButton(
                                    onPressed: () => Navigator.pop(context, _searchController.text.trim()),
                                    child: Text("${context.localization!.addAnyway}!"),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ));
                    }
                  } else if (snapshot.hasError) {
                    children = <Widget>[
                      Icon(
                        Icons.error_outline,
                        color: Theme.of(context).colorScheme.error,
                        size: iconSizeBig,
                      ),
                      const SizedBox(height: distanceBig),
                      Text('Error: ${snapshot.error}'),
                    ];
                  }
                  return Expanded(
                    child: ListView(
                      children: children,
                    ),
                  );
                },
              )
            ],
          ),
        ),
        floatingActionButton: widget.isMultiSelect
            ? FloatingActionButton(
                onPressed: () => Navigator.of(context).pop(selected),
                backgroundColor: positiveColor,
                child: const Icon(Icons.check))
            : const SizedBox(),
      ),
    );
  }
}
