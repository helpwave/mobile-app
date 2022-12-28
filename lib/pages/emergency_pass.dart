import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:language_picker/language_picker_dialog.dart';
import 'package:language_picker/languages.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:helpwave/services/language_model.dart';
import 'package:helpwave/styling/constants.dart';
import 'package:helpwave/components/blood_type_select.dart';
import 'package:helpwave/components/medication_form.dart';
import 'package:helpwave/enums/dosage.dart';
import 'package:helpwave/components/content_selection/content_selector.dart';
import 'package:helpwave/enums/severity.dart';

class EmergencyPass extends StatefulWidget {
  const EmergencyPass({super.key});

  @override
  State<EmergencyPass> createState() => _EmergencyPassState();
}

class _EmergencyPassState extends State<EmergencyPass> {
  final TextEditingController _controllerBirthdate = TextEditingController();
  final TextEditingController _controllerOrganDonor = TextEditingController();
  final TextEditingController _controllerPrimaryLanguage =
      TextEditingController();

  Widget _buildDialogItem(Language language) {
    return Row(
      children: <Widget>[
        Text("${language.name} (${language.isoCode})"),
      ],
    );
  }

  void _openLanguagePickerDialog() => showDialog(
      context: context,
      builder: (context) => LanguagePickerDialog(
          titlePadding: const EdgeInsets.all(8.0),
          searchInputDecoration:
              InputDecoration(hintText: AppLocalizations.of(context)!.search),
          isSearchable: true,
          title: Text(AppLocalizations.of(context)!.selectLanguage),
          onValuePicked: (Language language) => setState(() {
                _controllerPrimaryLanguage.text = language.name;
              }),
          itemBuilder: _buildDialogItem));

  @override
  Widget build(BuildContext context) {
    const OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(borderRadiusMedium),
      ),
    );
    const Widget distanceHolder = SizedBox(height: distanceDefault);

    return Consumer<LanguageModel>(
        builder: (_, LanguageModel languageNotifier, __) {
      return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.emergencyPass),
        ),
        body: ListView(
          children: [
            distanceHolder,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: distanceMedium),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                      border: outlineInputBorder,
                      prefixIcon: const Icon(Icons.person),
                      labelText: AppLocalizations.of(context)!.name,
                      hintText: AppLocalizations.of(context)!.name,
                    ),
                  ),
                  distanceHolder,
                  TextField(
                    controller: _controllerPrimaryLanguage,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: outlineInputBorder,
                      prefixIcon: const Icon(Icons.language),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _controllerPrimaryLanguage.clear();
                        },
                      ),
                      labelText: AppLocalizations.of(context)!.primaryLanguage,
                      hintText: AppLocalizations.of(context)!.primaryLanguage,
                    ),
                    onTap: _openLanguagePickerDialog,
                  ),
                  distanceHolder,
                  TextField(
                    readOnly: true,
                    controller: _controllerBirthdate,
                    onTap: () async {
                      DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now()
                            .subtract(const Duration(days: 365 * 100)),
                        lastDate: DateTime.now(),
                      );
                      setState(() {
                        if (selectedDate != null) {
                          _controllerBirthdate.text =
                              DateFormat('dd.MM.yyyy').format(selectedDate);
                        }
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.calendar_month),
                      border: outlineInputBorder,
                      labelText: AppLocalizations.of(context)!.dateOfBirth,
                      hintText: AppLocalizations.of(context)!.dateOfBirth,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _controllerBirthdate.clear();
                        },
                      ),
                    ),
                  ),
                  distanceHolder,
                  TextField(
                      readOnly: true,
                      controller: _controllerOrganDonor,
                      decoration: InputDecoration(
                        border: outlineInputBorder,
                        prefixIcon: const Icon(Icons.favorite),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _controllerOrganDonor.clear();
                          },
                        ),
                        labelText: AppLocalizations.of(context)!.organDonor,
                        hintText: AppLocalizations.of(context)!.organDonor,
                      ),
                      onTap: () => {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(AppLocalizations.of(context)!
                                        .organDonor),
                                    actions: [
                                      TextButton(
                                        child: Text(
                                            AppLocalizations.of(context)!.yes),
                                        onPressed: () {
                                          setState(() {
                                            _controllerOrganDonor.text =
                                                AppLocalizations.of(context)!
                                                    .yes;
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text(
                                            AppLocalizations.of(context)!.no),
                                        onPressed: () {
                                          setState(() {
                                            _controllerOrganDonor.text =
                                                AppLocalizations.of(context)!
                                                    .no;
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                })
                          }),
                  distanceHolder,
                  TextField(
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(3),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: outlineInputBorder,
                        prefixIcon: const Icon(Icons.monitor_weight),
                        labelText: AppLocalizations.of(context)!.weight,
                        hintText: AppLocalizations.of(context)!.weight,
                        suffixText: "kg"),
                  ),
                  distanceHolder,
                  TextField(
                    maxLengthEnforcement: MaxLengthEnforcement.values[1],
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(3),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: outlineInputBorder,
                        prefixIcon: const Icon(Icons.height),
                        labelText: AppLocalizations.of(context)!.height,
                        hintText: AppLocalizations.of(context)!.height,
                        suffixText: "cm"),
                  ),
                ],
              ),
            ),
            distanceHolder,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: distanceMedium),
              child: BloodTypeSelect(
                changedBloodType: (bloodType) {
                  // TODO save bloodType
                },
                changedRhesusFactor: (rhesusFactor) {
                  // TODO save rhesusFactor
                },
              ),
            ),
            distanceHolder,
            MedicationForm(
              initialMedications: const <String, Dosage>{
                "Coffein": Dosage.daily5Times,
                "Medication Name": Dosage.weekly,
              },
              changedMedicationList: (medications) {
                // TODO save medications
              },
            ),
            ContentSelector<Severity>(
              initialValues: const {},
              searchTitle: AppLocalizations.of(context)!.allergies,
              onChangedList: (map) {
                // TODO save allergyList
              },
              selectionItems: Severity.values,
              selectionDefaultValue: Severity.light,
              selectionLabelText: AppLocalizations.of(context)!.severity,
              selectWidth: 120,
              valueToString: (value) {
                switch (value) {
                  case Severity.light:
                    return AppLocalizations.of(context)!.light;
                  case Severity.severe:
                    return AppLocalizations.of(context)!.severe;
                }
              },
              searchElementName: AppLocalizations.of(context)!.allergy,
              icon: const Icon(Icons.warning_outlined),
              title: AppLocalizations.of(context)!.allergies,
              loadAsyncSearchOptions: (searched, ignoreList) async {
                // TODO fetch form backend
                List<String> items = [
                  "Nuts",
                  "Shellfish",
                  "Peanut",
                  "Pollen",
                  "House dust",
                  "Animal fur",
                  "Bee sting",
                  "Wasp sting"
                ];
                items.retainWhere((element) => !ignoreList.contains(element));
                List<String> result = [];
                for (var element in items) {
                  if (!items.contains(searched) &&
                      element
                          .toLowerCase()
                          .startsWith(searched.toLowerCase())) {
                    result.add(element);
                  }
                }
                return result;
              },
            ),
            distanceHolder,
          ],
        ),
      );
    });
  }
}
