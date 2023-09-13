import 'package:flutter/material.dart';
import 'package:tasks/components/navigation_drawer.dart';
import 'package:tasks/components/patient_card.dart';
import 'package:helpwave_localization/localization.dart';
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

  Patient patient = Patient(id: "patient",
    name: "Peter Name",
    room: RoomMinimal(id: "room", name: "Room 1a"),
    bed: BedMinimal(id: "bed", name: "Bed 3"),
    tasks: [],
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const TasksNavigationDrawer(
          currentPage: NavigationOptions.myTasks,
        ),
        appBar: AppBar(title: Text(context.localization!.myTasks),),
        body: ListView(
          children: [
            PatientCard(patient: patient)
          ],
        )
    );
  }
}
