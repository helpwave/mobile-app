import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:helpwave/styling/constants.dart';

class MedicationSearchPage extends StatefulWidget {
  final List<String> ignoreList;
  final List<String> searchOptions;
  late final List<String> filteredSearchOptions;

  MedicationSearchPage(
      {super.key, this.ignoreList = const [], this.searchOptions = const []}) {
    List<String> list = [];
    list.addAll(searchOptions);
    list.retainWhere((element) => !ignoreList.contains(element));
    filteredSearchOptions = list;
  }

  @override
  State<StatefulWidget> createState() => _MedicationSearchPageState();
}

class _MedicationSearchPageState extends State<MedicationSearchPage> {
  final TextEditingController _searchController = TextEditingController();

  List<String> getSearchResults(String searched) {
    List<String> result = [];
    for (var element in widget.filteredSearchOptions) {
      if (!widget.filteredSearchOptions.contains(searched) &&
          element.toLowerCase().startsWith(searched.toLowerCase())) {
        result.add(element);
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    List<String> searchResults = getSearchResults(_searchController.text);
    List<Widget> elementList = [];

    elementList.add(
      Padding(
        padding: const EdgeInsets.all(distanceSmall),
        child: TextFormField(
          onChanged: (value) => {setState(() {})},
          controller: _searchController,
          decoration: InputDecoration(
            suffixIcon: IconButton(
                onPressed: () => _searchController.clear(),
                icon: const Icon(Icons.close)),
            hintText: AppLocalizations.of(context)!.search,
            border: const OutlineInputBorder(),
          ),
        ),
      ),
    );

    for (var element in searchResults) {
      elementList.add(
        ListTile(
          title: Text(element),
          onTap: () {
            Navigator.pop<String>(context, element);
          },
        ),
      );
    }
    if (searchResults.isEmpty) {
      elementList.add(
        Center(
          child: Column(
            children: [
              const SizedBox(height: distanceBig),
              Text(
                "${AppLocalizations.of(context)!.medication} ${AppLocalizations.of(context)!.notFound}",
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: distanceDefault),
              TextButton(
                onPressed: () => Navigator.pop(context, _searchController.text),
                child: Text("${AppLocalizations.of(context)!.addAnyway}!"),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: ListView(
        children: elementList,
      ),
    );
  }
}
