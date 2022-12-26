import 'package:flutter/material.dart';
import 'package:helpwave/styling/constants.dart';
import '../enums/dosage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MedicationFormEntry extends StatelessWidget {
  final String name;
  final Dosage dosage;
  final void Function(String) deleteClicked;
  final void Function(String, Dosage) changedDosage;

  const MedicationFormEntry({
    super.key,
    required this.name,
    required this.dosage,
    required this.deleteClicked,
    required this.changedDosage,
  });

  @override
  Widget build(BuildContext context) {
    const double selectMaxWidth = 180; // Pixel

    return Container(
      padding: const EdgeInsets.only(bottom: distanceSmall, top: distanceTiny),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              "- $name",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: selectMaxWidth),
                  child: DropdownButtonFormField<Dosage>(
                    value: dosage,
                    items:
                        Dosage.values.map<DropdownMenuItem<Dosage>>((dosage) {
                      String itemName = "";
                      switch (dosage) {
                        case Dosage.daily:
                          itemName = AppLocalizations.of(context)!.daily;
                          break;
                        case Dosage.daily2Times:
                          itemName = AppLocalizations.of(context)!.daily2Times;
                          break;
                        case Dosage.daily3Times:
                          itemName = AppLocalizations.of(context)!.daily3Times;
                          break;
                        case Dosage.daily5Times:
                          itemName = AppLocalizations.of(context)!.daily5Times;
                          break;
                        case Dosage.weekly:
                          itemName = AppLocalizations.of(context)!.weekly;
                          break;
                        case Dosage.weekly2Times:
                          itemName = AppLocalizations.of(context)!.weekly2Times;
                          break;
                        case Dosage.weekly4Times:
                          itemName = AppLocalizations.of(context)!.weekly4Times;
                          break;
                        case Dosage.monthly:
                          itemName = AppLocalizations.of(context)!.monthly;
                          break;
                      }
                      return DropdownMenuItem(
                        value: dosage,
                        child: Text(itemName),
                      );
                    }).toList(),
                    onChanged: (dosage) {
                      changedDosage(name, dosage!);
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(
                          left: dropDownVerticalPadding,
                          right: dropDownVerticalPadding),
                      labelText: AppLocalizations.of(context)!.dosage,
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
          ),
        ],
      ),
    );
  }
}
