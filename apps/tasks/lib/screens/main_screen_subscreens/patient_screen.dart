import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_theme/util.dart';
import 'package:helpwave_widget/bottom_sheets.dart';
import 'package:helpwave_widget/loading.dart';
import 'package:helpwave_widget/navigation.dart';
import 'package:provider/provider.dart';
import 'package:tasks/components/bottom_sheet_pages/patient_bottom_sheet.dart';
import 'package:tasks/components/patient_card.dart';
import 'package:tasks/components/patient_status_chip_select.dart';
import 'package:tasks/components/bottom_sheet_pages/task_bottom_sheet.dart';
import 'package:helpwave_service/tasks.dart';

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
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: paddingSmall, right: paddingSmall, bottom: paddingMedium, top: paddingSmall),
            child: Consumer<WardPatientsController>(builder: (_, patientController, __) {
              return SearchBar(
                hintText: context.localization.searchPatient,
                trailing: [
                  IconButton(
                    onPressed: () {
                      // TODO do something on search press
                    },
                    icon: Icon(
                      Icons.search,
                      size: iconSizeTiny,
                      color: context.theme.searchBarTheme.textStyle!.resolve({WidgetState.selected})!.color,
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
                builder: (_, patientController, __) => PatientStatusChipSelect(
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
                            padding: const EdgeInsets.symmetric(horizontal: paddingSmall),
                            child: Dismissible(
                              key: Key(patient.id!),
                              confirmDismiss: (direction) async {
                                if (direction == DismissDirection.endToStart) {
                                  patientController.discharge(patient.id!);
                                } else if (!patient.isDischarged) {
                                  context
                                      .pushModal(
                                          context: context,
                                          builder: (context) =>
                                              TaskBottomSheet(task: Task.empty(patient.id), patient: patient))
                                      .then((value) => patientController.load());
                                }
                                return false;
                              },
                              direction: patient.isDischarged ? DismissDirection.none : DismissDirection.horizontal,
                              background: Padding(
                                padding: const EdgeInsets.all(paddingTiny),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: context.theme.colorScheme.primary,
                                    borderRadius: BorderRadius.circular(borderRadiusMedium),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: paddingMedium),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      context.localization.addTask,
                                    ),
                                  ),
                                ),
                              ),
                              secondaryBackground: Padding(
                                padding: const EdgeInsets.all(paddingTiny),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(borderRadiusSmall),
                                    color: negativeColor,
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                        padding: const EdgeInsets.only(right: paddingMedium),
                                        child: Text(
                                          context.localization.discharge,
                                        )),
                                  ),
                                ),
                              ),
                              child: PatientCard(
                                onClick: () => context
                                    .pushModal(
                                      context: context,
                                      builder: (context) =>
                                          NavigationOutlet(initialValue: PatientBottomSheet(patentId: patient.id!)),
                                    )
                                    .then((_) => patientController.load()),
                                patient: patient,
                                margin: const EdgeInsets.symmetric(vertical: paddingTiny),
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
    );
  }
}
