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
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: paddingSmall),
                          child: TextField(
                            readOnly: true,
                            onTap: () async {
                              DateTime? selectedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now()
                                    .subtract(const Duration(days: 365 * 100)), // 100 years max age
                                lastDate: DateTime.now(),
                              );
                              setState(() {
                                if (selectedDate != null) {
                                  birthDate = selectedDate;
                                }
                              });
                            },
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.calendar_month),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(borderRadiusMedium)),
                              ),
                              labelText: AppLocalizations.of(context)!.dateOfBirth,
                              hintText: birthDate != null ? DateFormat.yMd(languageNotifier.shortname).format(birthDate!) : AppLocalizations.of(context)!.dateOfBirth,
                            ),
                          ),
                        ),
                        Padding(padding: const EdgeInsets.symmetric(vertical: paddingSmall),
                          child: TextField(
                            readOnly: true,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(borderRadiusMedium)),
                              ),
                              prefixIcon: const Icon(Icons.favorite),
                              labelText: AppLocalizations.of(context)!.organDonor,
                              hintText: organDonor ? AppLocalizations.of(context)!.yes : AppLocalizations.of(context)!.no,
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
                                              organDonor = true;
                                            });
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text(AppLocalizations.of(context)!.no),
                                          onPressed: () {
                                            setState(() {
                                              organDonor = false;
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
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.monitor_weight),
                              labelText: AppLocalizations.of(context)!.weight,
                              hintText: AppLocalizations.of(context)!.weight,
                            ),
                          ),
                        ),
                        Padding(padding: const EdgeInsets.symmetric(vertical: paddingSmall),
                          child: TextField(
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.height),
                              labelText: AppLocalizations.of(context)!.height,
                              hintText: AppLocalizations.of(context)!.height,
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
