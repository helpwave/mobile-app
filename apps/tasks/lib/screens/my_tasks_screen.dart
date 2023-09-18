import 'package:flutter/material.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:tasks/components/navigation_drawer.dart';
import 'package:tasks/components/patient_card.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:tasks/components/patient_status_chip_select.dart';
import 'package:tasks/dataclasses/patient.dart';
import 'package:helpwave_proto_dart/proto/services/task_svc/v1/patient_svc.pb.dart';
import 'package:tasks/services/patient_svc.dart';

/// The Screen for showing all [Task]'s the [User] has in the current [ ]
class MyTasksScreen extends StatefulWidget {
  const MyTasksScreen({super.key});

  @override
  State<MyTasksScreen> createState() => _MyTasksScreenState();
}

class _MyTasksScreenState extends State<MyTasksScreen> {
  GetPatientListRequest patientListRequest = GetPatientListRequest();
  String searchedText = "";
  String selectedPatientStatus = "all";
  Future<Map<PatientAssignmentStatus, List<Patient>>> future = PatientService().getPatientList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const TasksNavigationDrawer(
        currentPage: NavigationOptions.myTasks,
      ),
      appBar: AppBar(
        title: Text(context.localization!.myTasks),
      ),
      body: FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          Map<PatientAssignmentStatus, List<Patient>> patientsByAssignment = snapshot.data!;
          List<Patient> patientList = patientsByAssignment[PatientAssignmentStatus.active]! +
              patientsByAssignment[PatientAssignmentStatus.unassigned]! +
              patientsByAssignment[PatientAssignmentStatus.discharged]!;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: paddingSmall, right: paddingSmall, bottom: paddingSmall),
                child: SearchBar(
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
                child: ListView(
                  children: patientList
                      .map(
                        (patient) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: paddingSmall),
                          child: Dismissible(
                            key: Key(patient.id),
                            background: Padding(
                              padding: const EdgeInsets.all(paddingTiny),
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(borderRadiusMedium),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: paddingMedium),
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
                                  borderRadius: BorderRadius.circular(borderRadiusSmall),
                                  color: negativeColor,
                                ),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                      padding: const EdgeInsets.only(right: paddingMedium),
                                      child: Text(
                                        context.localization!.discharge,
                                      )),
                                ),
                              ),
                            ),
                            onDismissed: (DismissDirection direction) {
                              setState(() {
                                // TODO: implement logic
                              });
                            },
                            child: PatientCard(
                              patient: patient,
                              margin: const EdgeInsets.symmetric(vertical: paddingTiny),
                            ),
                          ),
                        ),
                      ).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
