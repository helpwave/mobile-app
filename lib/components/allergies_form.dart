import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../styling/constants.dart';

class AllergiesForm extends StatefulWidget {
  final List<String> initialSelected;
  final void Function(List<String>) changedSelected;

  const AllergiesForm({
    super.key,
    this.initialSelected = const <String>[],
    required this.changedSelected,
  });

  @override
  State<StatefulWidget> createState() => _AllergiesFormState();
}

class _AllergiesFormState extends State<AllergiesForm> {
  List<String> selected = [];

  @override
  void initState() {
    super.initState();
    selected.addAll(widget.initialSelected);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>.multiSelection(
      asyncItems: getAllAllergies,
      selectedItems: selected,
      onChanged: (list) => widget.changedSelected(list),
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: AppLocalizations.of(context)!.allergies,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(borderRadiusMedium),
            ),
          ),
        ),
      ),
    );
  }

  Future<List<String>> getAllAllergies(String _) async {
    // TODO fetch form backend
    return ["Schalenfrüchte", "Schalentiere", "Erdnüsse", "Pollen"];
  }
}
