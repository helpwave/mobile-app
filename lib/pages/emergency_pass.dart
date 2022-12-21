import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helpwave/services/language_model.dart';
import 'package:helpwave/styling/constants.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmergencyPass extends StatefulWidget {
  const EmergencyPass({super.key});

  @override
  State<EmergencyPass> createState() => _EmergencyPassState();
}



class _EmergencyPassState extends State<EmergencyPass> {
  final TextEditingController _controllerBirthdate = TextEditingController();
  final TextEditingController _controllerOrganDonor = TextEditingController();

  DateTime? birthDate;
  bool organDonor = false;

  @override
  Widget build(BuildContext context) {

    return  Consumer<LanguageModel>(
        builder: (_, LanguageModel languageNotifier, __) {
          return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.emergencyPass),),
              body: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: paddingMedium),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextField(
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(borderRadiusMedium)),
                            ),
                            prefixIcon: const Icon(Icons.person),
                            labelText: AppLocalizations.of(context)!.name,
                            hintText: AppLocalizations.of(context)!.name,
                          ),
                        ),
                        Padding(padding: const EdgeInsets.symmetric(vertical: paddingSmall), child: TextField(
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.language),
                            labelText: AppLocalizations.of(context)!.primaryLanguage,
                            hintText: AppLocalizations.of(context)!.primaryLanguage,
                          ),
                        ),),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: paddingSmall),
                          child: TextField(
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
                                _controllerBirthdate.text =
                                    DateFormat('dd.MM.yyyy').format(selectedDate!);
                              });
                            },
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.calendar_month),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(borderRadiusMedium)),
                              ),
                              labelText: AppLocalizations.of(context)!.dateOfBirth,
                            ),
                          ),
                        ),
                        Padding(padding: const EdgeInsets.symmetric(vertical: paddingSmall),
                          child: TextField(
                            readOnly: true,
                            controller: _controllerOrganDonor,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(borderRadiusMedium)),
                              ),
                              prefixIcon: const Icon(Icons.favorite),
                              labelText:  AppLocalizations.of(context)!.organDonor ,
                            ),
                            onTap: () => {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(AppLocalizations.of(context)!.organDonor),
                                      actions: [
                                        TextButton(
                                          child: Text(AppLocalizations.of(context)!.yes),
                                          onPressed: () {
                                            setState(() {
                                              _controllerOrganDonor.text = AppLocalizations.of(context)!.yes;
                                            });
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text(AppLocalizations.of(context)!.no),
                                          onPressed: () {
                                            setState(() {
                                              _controllerOrganDonor.text =
                                                  AppLocalizations.of(context)!.no;
                                            });
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  })
                            }
                          ),
                        ),
                        Padding(padding: const EdgeInsets.symmetric(vertical: paddingSmall),
                          child: TextField(
                            inputFormatters: <TextInputFormatter>[
                              LengthLimitingTextInputFormatter(3),
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.monitor_weight),
                              labelText: AppLocalizations.of(context)!.weight,
                              hintText: AppLocalizations.of(context)!.weight,
                              suffixText: "kg"
                            ),
                          ),
                        ),
                        Padding(padding: const EdgeInsets.symmetric(vertical: paddingSmall),
                          child: TextField(
                            maxLengthEnforcement: MaxLengthEnforcement.values[1],
                            inputFormatters: <TextInputFormatter>[
                              LengthLimitingTextInputFormatter(3),
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.height),
                              labelText: AppLocalizations.of(context)!.height,
                              hintText: AppLocalizations.of(context)!.height,
                              suffixText: "cm"
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
              )
          );
        });
  }
}
