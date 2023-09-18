import 'package:flutter/material.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:tasks/components/navigation_drawer.dart';
import 'package:tasks/components/patient_card.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:tasks/components/patient_status_chip_select.dart';
import 'package:tasks/dataclasses/bed.dart';
import 'package:tasks/dataclasses/patient.dart';
import 'package:tasks/dataclasses/room.dart';

/// The Screen for showing all [Task]'s the [User] has in the current [ ]
class MyTasksScreen extends StatefulWidget {
  const MyTasksScreen({super.key});

  @override
  State<MyTasksScreen> createState() => _MyTasksScreenState();
}

class _MyTasksScreenState extends State<MyTasksScreen> {
  List<Patient> patients = [
    Patient(
      id: "patient",
      name: "Peter Name",
      room: RoomMinimal(id: "room", name: "Room 1a"),
      bed: BedMinimal(id: "bed", name: "Bed 3"),
      tasks: [],
    )
  ];
  String searchedText = "";
  String selectedPatientStatus = "all";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const TasksNavigationDrawer(
        currentPage: NavigationOptions.myTasks,
      ),
      appBar: AppBar(
        title: Text(context.localization!.myTasks),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: paddingSmall, right: paddingSmall, bottom: paddingMedium),
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
          Column(
            children: patients
                .map((patient) => Dismissible(
                      key: Key(patient.id),
                      background: Padding(
                        padding: const EdgeInsets.all(paddingTiny),
                        child: Container(
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius:
                                  BorderRadius.circular(borderRadiusMedium),
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
                            borderRadius:
                                BorderRadius.circular(borderRadiusSmall),
                            color: negativeColor,
                          ),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                                padding:
                                    const EdgeInsets.only(right: paddingMedium),
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
                      child: PatientCard(patient: patient),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
