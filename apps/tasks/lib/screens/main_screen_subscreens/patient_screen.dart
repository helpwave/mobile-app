import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_proto_dart/proto/services/task_svc/v1/patient_svc.pb.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:tasks/components/patient_card.dart';
import 'package:tasks/components/patient_status_chip_select.dart';
import 'package:tasks/components/user_header.dart';
import 'package:tasks/dataclasses/patient.dart';
import 'package:tasks/services/patient_svc.dart';

/// A screen for showing a all [Patient]s by certain user-selectable filter properties
///
/// Filters: discharge, active, unassigned, matches search
class PatientScreen extends StatefulWidget {
  const PatientScreen({super.key});

  @override
  State<StatefulWidget> createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  GetPatientListRequest patientListRequest = GetPatientListRequest();
  String searchedText = "";
  String selectedPatientStatus = "all";
  Future<Map<PatientAssignmentStatus, List<Patient>>> future =
      PatientService().getPatientList();
  bool isUpdating = false;

  bool searchMatch(Patient patient) {
    String searchCleaned = searchedText.toLowerCase().trim();
    if (patient.name.toLowerCase().contains(searchCleaned)) {
      return true;
    }
    if (patient.bed != null &&
        patient.bed!.name.toLowerCase().contains(searchCleaned)) {
      return true;
    }
    if (patient.room != null &&
        patient.room!.name.toLowerCase().contains(searchCleaned)) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const UserHeader(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: paddingSmall, right: paddingSmall, bottom: paddingMedium),
            child: SearchBar(
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
                searchedText = value;
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: paddingSmall),
            child: SizedBox(
              height: 40,
              child: PatientStatusChipSelect(
                // TODO fix this to allow for an select all button working as intended
                initialSelection: selectedPatientStatus,
                onChange: (value) => setState(() {
                  selectedPatientStatus = value ?? "all";
                }),
              ),
            ),
          ),
          Container(
            height: distanceDefault,
          ),
          Flexible(
            child: isUpdating
                ? const Center(child: CircularProgressIndicator())
                : FutureBuilder(
                    future: future,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      }
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      Map<PatientAssignmentStatus, List<Patient>>
                          patientsByAssignment = snapshot.data!;
                      List<Patient> patientList = [];
                      if (selectedPatientStatus == "all" ||
                          selectedPatientStatus == "active") {
                        patientList += patientsByAssignment[
                                PatientAssignmentStatus.active]!
                            .where(searchMatch)
                            .toList();
                      }
                      if (selectedPatientStatus == "all" ||
                          selectedPatientStatus == "unassigned") {
                        patientList += patientsByAssignment[
                                PatientAssignmentStatus.unassigned]!
                            .where(searchMatch)
                            .toList();
                      }
                      if (selectedPatientStatus == "all" ||
                          selectedPatientStatus == "discharged") {
                        patientList += patientsByAssignment[
                                PatientAssignmentStatus.discharged]!
                            .where(searchMatch)
                            .toList();
                      }
                      return ListView(
                        children: patientList
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
                                    setState(() {
                                      isUpdating = true;
                                    });
                                    if (direction ==
                                        DismissDirection.endToStart) {
                                      PatientService()
                                          .dischargePatient(
                                              patientId: patient.id)
                                          .then((value) => setState(() {
                                                future = PatientService()
                                                    .getPatientList();
                                                isUpdating = false;
                                              }));
                                    } else {
                                      // TODO open patient screen
                                      await Future.delayed(
                                          const Duration(seconds: 1));
                                      setState(() {
                                        future =
                                            PatientService().getPatientList();
                                        isUpdating = false;
                                      });
                                    }
                                  },
                                  child: PatientCard(
                                    patient: patient,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: paddingTiny),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
