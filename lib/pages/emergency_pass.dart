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
import 'package:helpwave/enums/dosage.dart';
import 'package:helpwave/components/content_selection/content_selector.dart';
import 'package:helpwave/enums/severity.dart';
import 'package:helpwave/data_classes/patient_data.dart';
import 'package:helpwave/services/patient_persistence.dart';

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

  void _openLanguagePickerDialog(PatientData patientData) => showDialog(
      context: context,
      builder: (context) => LanguagePickerDialog(
          titlePadding: const EdgeInsets.all(8.0),
          searchInputDecoration:
              InputDecoration(hintText: AppLocalizations.of(context)!.search),
          isSearchable: true,
          title: Text(AppLocalizations.of(context)!.selectLanguage),
          onValuePicked: (Language language) => setState(() {
                _controllerPrimaryLanguage.text = language.name;
                patientData.language = language.name;
                patientData.save();
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
        body: FutureBuilder(
          future: PatientPersistenceService().load(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Theme.of(context).colorScheme.error,
                    size: MediaQuery.of(context).size.width * 0.3,
                  ),
                  const SizedBox(height: distanceDefault),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: distanceMedium),
                      child: Text('${snapshot.error}')),
                ],
              );
            } else if (!snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.width * 0.3,
                      child: const CircularProgressIndicator(),
                    ),
                  ),
                ],
              );
            }
            PatientData patient = snapshot.data!;

            if (patient.isOrganDonor != null) {
              _controllerOrganDonor.text = patient.isOrganDonor!
                  ? AppLocalizations.of(context)!.yes
                  : AppLocalizations.of(context)!.no;
            }
            if (patient.birthDate != null) {
              _controllerBirthdate.text =
                  DateFormat('dd.MM.yyyy').format(patient.birthDate!);
            }
            if (patient.language != null) {
              _controllerPrimaryLanguage.text = patient.language!;
            }

            return ListView(
              children: [
                distanceHolder,
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: distanceMedium),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          border: outlineInputBorder,
                          prefixIcon: const Icon(Icons.person),
                          labelText: AppLocalizations.of(context)!.name,
                          hintText: AppLocalizations.of(context)!.name,
                        ),
                        onChanged: (value) {
                          patient.name = value;
                          patient.save();
                        },
                        initialValue: patient.name,
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
                              patient.language = null;
                              patient.save();
                            },
                          ),
                          labelText:
                              AppLocalizations.of(context)!.primaryLanguage,
                          hintText:
                              AppLocalizations.of(context)!.primaryLanguage,
                        ),
                        onTap: () => _openLanguagePickerDialog(patient),
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
                            patient.birthDate = selectedDate;
                            patient.save();
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
                              patient.birthDate = null;
                              patient.save();
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
                              patient.isOrganDonor = null;
                              patient.save();
                            },
                          ),
                          labelText: AppLocalizations.of(context)!.organDonor,
                          hintText: AppLocalizations.of(context)!.organDonor,
                        ),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                      AppLocalizations.of(context)!.organDonor),
                                  actions: [
                                    TextButton(
                                      child: Text(
                                          AppLocalizations.of(context)!.yes),
                                      onPressed: () {
                                        setState(() {
                                          _controllerOrganDonor.text =
                                              AppLocalizations.of(context)!.yes;
                                          patient.isOrganDonor = true;
                                          patient.save();
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
                                              AppLocalizations.of(context)!.no;
                                          patient.isOrganDonor = false;
                                          patient.save();
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                        },
                      ),
                      distanceHolder,
                      TextFormField(
                        initialValue: patient.height,
                        onChanged: (value) {
                          patient.height = value;
                          patient.save();
                        },
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
                      TextFormField(
                        initialValue: patient.weight,
                        onChanged: (value) {
                          patient.weight = value;
                          patient.save();
                        },
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
                      distanceHolder,
                    ],
                  ),
                ),
                BloodTypeSelect(
                  initialBloodType: patient.bloodType,
                  initialRhesusFactor: patient.rhesusFactor,
                  changedBloodType: (bloodType) {
                    patient.bloodType = bloodType;
                    patient.save();
                  },
                  changedRhesusFactor: (rhesusFactor) {
                    patient.rhesusFactor = rhesusFactor;
                    patient.save();
                  },
                ),
                ContentSelector<Dosage>(
                  title: AppLocalizations.of(context)!.medications,
                  isMultiSelect: true,
                  initialValues: patient.medication,
                  onChangedList: (map) {
                    patient.medication = map;
                    patient.save();
                  },
                  valueToString: (dosage) {
                    Map<Dosage, String> translation = {
                      Dosage.daily: AppLocalizations.of(context)!.daily,
                      Dosage.daily3Times:
                          AppLocalizations.of(context)!.daily3Times,
                      Dosage.daily2Times:
                          AppLocalizations.of(context)!.daily2Times,
                      Dosage.daily5Times:
                          AppLocalizations.of(context)!.daily5Times,
                      Dosage.weekly: AppLocalizations.of(context)!.weekly,
                      Dosage.weekly2Times:
                          AppLocalizations.of(context)!.weekly2Times,
                      Dosage.weekly4Times:
                          AppLocalizations.of(context)!.weekly4Times,
                      Dosage.monthly: AppLocalizations.of(context)!.monthly,
                    };
                    return translation[dosage]!;
                  },
                  selectionItems: Dosage.values,
                  selectionLabelText: AppLocalizations.of(context)!.dosage,
                  selectionDefaultValue: Dosage.daily,
                  icon: const Icon(Icons.medication),
                  searchElementName: AppLocalizations.of(context)!.medication,
                  searchTitle: AppLocalizations.of(context)!.medicationSearch,
                  searchItems: const [
                    "Coffein",
                    "Medication Name",
                    "Aspirin",
                    "Duozol",
                    "Diamannden"
                  ],
                ),
                ContentSelector<Severity>(
                  initialValues: patient.allergies,
                  isMultiSelect: true,
                  searchTitle: AppLocalizations.of(context)!.allergies,
                  onChangedList: (map) {
                    patient.allergies = map;
                    patient.save();
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
                  searchAsyncItems: (searched) async {
                    // TODO fetch form backend
                    return [
                      "Nuts",
                      "Shellfish",
                      "Peanut",
                      "Pollen",
                      "House dust",
                      "Animal fur",
                      "Bee sting",
                      "Wasp sting"
                    ];
                  },
                ),
                distanceHolder,
              ],
            );
          },
        ),
      );
    });
  }
}
