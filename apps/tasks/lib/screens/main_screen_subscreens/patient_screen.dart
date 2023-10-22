import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_widget/loading.dart';
import 'package:provider/provider.dart';
import 'package:tasks/components/patient_bottom_sheet.dart';
import 'package:tasks/components/patient_card.dart';
import 'package:tasks/components/patient_status_chip_select.dart';
import 'package:tasks/components/task_bottom_sheet.dart';
import 'package:tasks/components/user_header.dart';
import 'package:tasks/controllers/ward_patients_controller.dart';
import 'package:tasks/dataclasses/patient.dart';
import 'package:tasks/dataclasses/task.dart';

/// A screen for showing a all [Patient]s by certain user-selectable filter properties
///
/// Filters: discharge, active, unassigned, matches search
class PatientScreen extends StatefulWidget {
  const PatientScreen({super.key});

  @override
  State<StatefulWidget> createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WardPatientsController(),
      child: Scaffold(
        appBar: const UserHeader(),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: paddingSmall,
                  right: paddingSmall,
                  bottom: paddingMedium),
              child: Consumer<WardPatientsController>(
                  builder: (_, patientController, __) {
                return SearchBar(
                  hintText: context.localization!.searchPatient,
                  trailing: [
                    IconButton(
                      onPressed: () {
                        // TODO do something on search press
                      },
                      icon: Icon(
                        Icons.search,
                        size: iconSizeTiny,
                        color: Theme.of(context)
                            .searchBarTheme
                            .textStyle!
                            .resolve({MaterialState.selected})!.color,
                      ),
                    ),
                  ],
                  onChanged: (value) => setState(() {
                    patientController.searchedText = value;
                  }),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: paddingSmall),
              child: SizedBox(
                height: 40,
                child: Consumer<WardPatientsController>(
                  builder: (_, patientController, __) =>
                      PatientStatusChipSelect(
                    // TODO fix this to allow for an select all button working as intended
                    initialSelection: patientController.selectedPatientStatus,
                    onChange: (value) => setState(() {
                      patientController.selectedPatientStatus = value;
                    }),
                  ),
                ),
              ),
            ),
            Container(
              height: distanceDefault,
            ),
            Consumer<WardPatientsController>(
              builder: (context, patientController, __) {
                return LoadingAndErrorWidget(
                  state: patientController.state,
                  child: Flexible(
                    child: ListView(
                      children: patientController.filtered
                          .map(
                            (patient) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: paddingSmall),
                              child: Dismissible(
                                key: Key(patient.id),
                                background: Padding(
                                  padding: const EdgeInsets.all(paddingTiny),
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.circular(
                                            borderRadiusMedium),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: paddingMedium),
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            context.localization!.addTask,
                                          ))),
                                ),
                                secondaryBackground: Padding(
                                  padding: const EdgeInsets.all(paddingTiny),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          borderRadiusSmall),
                                      color: negativeColor,
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: paddingMedium),
                                          child: Text(
                                            context.localization!.discharge,
                                          )),
                                    ),
                                  ),
                                ),
                                onDismissed:
                                    (DismissDirection direction) async {
                                  if (direction ==
                                      DismissDirection.endToStart) {
                                    patientController.discharge(patient.id);
                                  } else {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) => TaskBottomSheet(
                                        task: Task.empty,
                                        patient: patient,
                                      ),
                                    );
                                  }
                                },
                                child: PatientCard(
                                  onClick: () => showModalBottomSheet(
                                    context: context,
                                    builder: (context) => PatientBottomSheet(
                                        patentId: patient.id),
                                  ),
                                  patient: patient,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: paddingTiny),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
