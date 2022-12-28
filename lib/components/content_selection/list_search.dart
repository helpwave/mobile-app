import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../styling/constants.dart';

/// A customizable Search within a List
///
/// Values need to be mapped to String with [elementToString]
/// Should be used with
/// [Navigator.push] and [Navigator.pop] with the latter returning the clicked result
class ListSearch<T> extends StatefulWidget {
  /// The Title displayed in the AppBar of the Search
  final String title;

  /// The List of SearchItems that should be ignored
  final List<T> ignoreList;

  /// The List of all Items for the Search
  final List<T> items;

  /// Custom builder for displaying a single search result
  /// IMPORTANT: This disables navigation pops on clicking a result, but can be implemented in the function
  /// IMPORTANT: Overwrites default display of search results
  final Widget Function(BuildContext context, T result)? resultTileBuilder;

  /// This Function returns the list of search results for [searched]
  final Future<List<T>> Function(String searched, List<T> ignoreList)?
      asyncFilteredSearchOptions;

  /// Maps Elements to String
  /// Used by default display of search result
  final String Function(T element) elementToString;

  /// The filtered List of search options [items] without [ignoreList]
  late final List<T> filteredSearchOptions;

  /// Allow adding user input not found in the search list
  final bool allowSelectAnyway;

  /// The name of the searched Elements e.g. Medication, Name or Color
  final String? searchElementName;

  ListSearch({
    super.key,
    required this.title,
    required this.resultTileBuilder,
    required this.elementToString,
    this.allowSelectAnyway = false,
    this.ignoreList = const [],
    this.items = const [],
    this.asyncFilteredSearchOptions,
    this.searchElementName,
  }) {
    List<T> list = [];
    list.addAll(items);
    list.retainWhere((element) => !ignoreList.contains(element));
    filteredSearchOptions = list;
  }

  @override
  State<StatefulWidget> createState() => _ListSearchState<T>();
}

class _ListSearchState<T> extends State<ListSearch<T>> {
  final TextEditingController _searchController = TextEditingController();

  // case insensitive search
  Future<List<T>> getSearchResults(String searched) async {
    String searchInLower = searched.toLowerCase();
    List<T> result = [];
    for (var element in widget.filteredSearchOptions) {
      if (!widget.filteredSearchOptions.contains(searched) &&
          widget
              .elementToString(element)
              .toLowerCase()
              .startsWith(searchInLower)) {
        result.add(element);
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
                onChanged: (value) => {setState(() {})},
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
                  hintText: AppLocalizations.of(context)!.search,
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            FutureBuilder(
              future: widget.asyncFilteredSearchOptions != null
                  ? widget.asyncFilteredSearchOptions!(
                      _searchController.text, widget.ignoreList)
                  : getSearchResults(_searchController.text),
              builder: (context, snapshot) {
                List<Widget> children = [];
                if (snapshot.hasData) {
                  if (snapshot.data!.isNotEmpty) {
                    if (widget.resultTileBuilder != null) {
                      children = snapshot.data!
                          .map((element) =>
                              widget.resultTileBuilder!(context, element))
                          .toList();
                    } else {
                      children = snapshot.data!.map((element) {
                        return ListTile(
                          title: Text(widget.elementToString(element)),
                          onTap: () {
                            Navigator.of(context).pop(element);
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
                            "${widget.searchElementName ?? _searchController.text} ${AppLocalizations.of(context)!.notFound}",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          const SizedBox(height: distanceDefault),
                          widget.allowSelectAnyway
                              ? TextButton(
                                  onPressed: () => Navigator.pop(
                                      context, _searchController.text),
                                  child: Text(
                                      "${AppLocalizations.of(context)!.addAnyway}!"),
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
    );
  }
}
