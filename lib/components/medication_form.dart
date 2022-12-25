import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:helpwave/components/medication_form_entry.dart';
import 'package:helpwave/components/medication_search.dart';
import 'package:helpwave/enums/dosage.dart';
import 'package:helpwave/styling/constants.dart';

class MedicationForm extends StatefulWidget {
  final Map<String, Dosage> initialMedications;
  final void Function(Map<String, Dosage>) changedMedicationList;

  const MedicationForm({
    super.key,
    required this.initialMedications,
    required this.changedMedicationList,
  });

  @override
  State<StatefulWidget> createState() => _MedicationFormState();
}

class _MedicationFormState extends State<MedicationForm> {
  bool isExpanded = false;
  Map<String, Dosage> medications = <String, Dosage>{};

  @override
  void initState() {
    super.initState();
    widget.initialMedications.forEach((key, value) {
      medications.update(key, (_) => value, ifAbsent: () => value);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> listElements = <Widget>[];
    const double columLeftPadding = distanceDefault;
    if (isExpanded) {
      medications.forEach((name, dosage) {
        listElements.add(
          MedicationFormEntry(
            name: name,
            dosage: dosage,
            deleteClicked: (deletedMedicationName) {
              setState(() {
                medications.remove(deletedMedicationName);
              });
              widget.changedMedicationList(medications);
            },
            changedDosage: (name, dosage) {
              setState(() {
                medications.update(name, (_) => dosage, ifAbsent: () => dosage);
              });
              widget.changedMedicationList(medications);
            },
          ),
        );
      });
      listElements.add(
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MedicationSearchPage(
                  ignoreList: medications.keys.toList(),
                  searchOptions: const [
                    "Coffein",
                    "Medication Name",
                    "Aspirin",
                    "Duozol",
                    "Diamannden"
                  ],
                ),
              ),
            ).then((newMedicationName) {
              setState(() {
                medications.update(newMedicationName, (value) => value,
                    ifAbsent: () => Dosage.daily);
              });
              widget.changedMedicationList(medications);
            });
          },
          icon: const Icon(Icons.add),
        ),
      );
    }

    return Column(
      children: [
        ListTile(
          title: Text(AppLocalizations.of(context)!.medications),
          subtitle: Text(
              "${medications.length} ${AppLocalizations.of(context)!.entries}"),
          leading: const Icon(Icons.medication),
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
                padding: const EdgeInsets.only(left: columLeftPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: listElements,
                ),
              )
            : const SizedBox(),
        const SizedBox(height: distanceDefault),
      ],
    );
  }
}
