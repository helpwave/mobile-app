import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:language_picker/language_picker_dialog.dart';
import 'package:language_picker/languages.dart';
import 'package:provider/provider.dart';
import 'package:helpwave/services/language_model.dart';
import 'package:helpwave/styling/constants.dart';
import 'package:helpwave/components/blood_type_select.dart';
import 'package:helpwave/enums/dosage.dart';
import 'package:helpwave/components/content_selection/content_selector.dart';
import 'package:helpwave/enums/severity.dart';
import 'package:helpwave/data_classes/patient_data.dart';
import 'package:helpwave/services/patient_persistence.dart';

/// Page to see and edit the [PatientData]
class EmergencyPassPage extends StatefulWidget {
  const EmergencyPassPage({super.key});

  @override
  State<EmergencyPassPage> createState() => _EmergencyPassPageState();
}

class _EmergencyPassPageState extends State<EmergencyPassPage> {
  final TextEditingController _controllerBirthdate = TextEditingController();
  final TextEditingController _controllerOrganDonor = TextEditingController();
  final TextEditingController _controllerPrimaryLanguage = TextEditingController();

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
          searchInputDecoration: InputDecoration(hintText: context.localization.search),
          isSearchable: true,
          title: Text(context.localization.selectLanguage),
          onValuePicked: (Language language) => setState(() {
                _controllerPrimaryLanguage.text = language.name;
                patientData.language = language.name;
                patientData.save();
              }),
          itemBuilder: _buildDialogItem));

  @override
  Widget build(BuildContext context) {
    const Widget distanceHolder = SizedBox(height: distanceDefault);

    return Consumer<LanguageModel>(builder: (_, LanguageModel languageNotifier, __) {
      return Scaffold(
        appBar: AppBar(
          title: Text(context.localization.emergencyPass),
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
                      padding: const EdgeInsets.symmetric(horizontal: distanceMedium),
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
              _controllerOrganDonor.text =
                  patient.isOrganDonor! ? context.localization!.yes : context.localization!.no;
            }
            if (patient.birthDate != null) {
              _controllerBirthdate.text = DateFormat('dd.MM.yyyy').format(patient.birthDate!);
            }
            if (patient.language != null) {
              _controllerPrimaryLanguage.text = patient.language!;
            }

            return ListView(
              children: [
                distanceHolder,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: distanceMedium),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person),
                          labelText: context.localization!.name,
                          hintText: context.localization!.name,
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
                          prefixIcon: const Icon(Icons.language),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              _controllerPrimaryLanguage.clear();
                              patient.language = null;
                              patient.save();
                            },
                          ),
                          labelText: context.localization!.primaryLanguage,
                          hintText: context.localization!.primaryLanguage,
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
                            firstDate: DateTime.now().subtract(const Duration(days: 365 * 100)),
                            lastDate: DateTime.now(),
                          );
                          setState(() {
                            if (selectedDate != null) {
                              _controllerBirthdate.text = DateFormat('dd.MM.yyyy').format(selectedDate);
                            }
                            patient.birthDate = selectedDate;
                            patient.save();
                          });
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.calendar_month),
                          labelText: context.localization!.dateOfBirth,
                          hintText: context.localization!.dateOfBirth,
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
                          prefixIcon: const Icon(Icons.favorite),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              _controllerOrganDonor.clear();
                              patient.isOrganDonor = null;
                              patient.save();
                            },
                          ),
                          labelText: context.localization!.organDonor,
                          hintText: context.localization!.organDonor,
                        ),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(context.localization!.organDonor),
                                  actions: [
                                    TextButton(
                                      child: Text(context.localization!.yes),
                                      onPressed: () {
                                        setState(() {
                                          _controllerOrganDonor.text = context.localization!.yes;
                                          patient.isOrganDonor = true;
                                          patient.save();
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text(context.localization!.no),
                                      onPressed: () {
                                        setState(() {
                                          _controllerOrganDonor.text = context.localization!.no;
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
                            prefixIcon: const Icon(Icons.monitor_weight),
                            labelText: context.localization!.weight,
                            hintText: context.localization!.weight,
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
                            prefixIcon: const Icon(Icons.height),
                            labelText: context.localization!.height,
                            hintText: context.localization!.height,
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
                  title: context.localization!.medications,
                  isMultiSelect: true,
                  initialValues: patient.medication,
                  onChangedList: (map) {
                    patient.medication = map;
                    patient.save();
                  },
                  valueToString: (dosage) {
                    Map<Dosage, String> translation = {
                      Dosage.daily: context.localization!.daily,
                      Dosage.daily3Times: context.localization!.daily3Times,
                      Dosage.daily2Times: context.localization!.daily2Times,
                      Dosage.daily5Times: context.localization!.daily5Times,
                      Dosage.weekly: context.localization!.weekly,
                      Dosage.weekly2Times: context.localization!.weekly2Times,
                      Dosage.weekly4Times: context.localization!.weekly4Times,
                      Dosage.monthly: context.localization!.monthly,
                    };
                    return translation[dosage]!;
                  },
                  selectionItems: Dosage.values,
                  selectionLabelText: context.localization!.dosage,
                  selectionDefaultValue: Dosage.daily,
                  icon: const Icon(Icons.medication),
                  searchElementName: context.localization!.medication,
                  searchTitle: context.localization!.medicationSearch,
                  searchItems: const ["Coffein", "Medication Name", "Aspirin", "Duozol", "Diamannden"],
                ),
                ContentSelector<Severity>(
                  initialValues: patient.allergies,
                  isMultiSelect: true,
                  searchTitle: context.localization!.allergies,
                  onChangedList: (map) {
                    patient.allergies = map;
                    patient.save();
                  },
                  selectionItems: Severity.values,
                  selectionDefaultValue: Severity.light,
                  selectionLabelText: context.localization!.severity,
                  selectWidth: 120,
                  valueToString: (value) {
                    switch (value) {
                      case Severity.light:
                        return context.localization!.light;
                      case Severity.severe:
                        return context.localization!.severe;
                    }
                  },
                  searchElementName: context.localization!.allergy,
                  icon: const Icon(Icons.warning_outlined),
                  title: context.localization!.allergies,
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
