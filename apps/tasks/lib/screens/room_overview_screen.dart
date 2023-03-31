import 'package:flutter/material.dart';
import 'package:tasks/components/navigation_drawer.dart';
import 'package:tasks/components/bed_card.dart';
import 'package:helpwave_widget/shapes.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_localization/localization.dart';

// TODO replace all these DTOs with real grpc generated onces
class RoomDTO {
  final String name;
  final List<PatientDTO> patients;

  RoomDTO({
    required this.name,
    required this.patients,
  });
}

class WardDTO {
  final String name;
  final List<RoomDTO> rooms;

  WardDTO({
    required this.name,
    required this.rooms,
  });
}

/// A [Widget] containing a [Room] title bar and the associated [BedCard]'s
class _RoomSection extends StatelessWidget {
  final RoomDTO room;

  const _RoomSection({
    required this.room,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.5;
    const double height = 85;
    double ratio = width / height;

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Container(height: distanceSmall),
        Row(
          children: [
            const Spacer(flex: 1),
            const Circle(
              color: Colors.blue, // TODO replace with primary color
              diameter: 20,
            ),
            const Spacer(flex: 1),
            Text(
              "${context.localization!.room} ${room.name}",
              style: const TextStyle(
                // TODO use SpaceGrotesk here
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const Spacer(flex: 15),
          ],
        ),
        room.patients.isNotEmpty
            ? GridView.count(
                childAspectRatio: ratio,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(paddingSmall),
                crossAxisCount: 2,
                children: room.patients
                    .map((PatientDTO patient) => BedCard(patient: patient))
                    .toList(),
              )
            : Padding(
                padding: const EdgeInsets.only(
                  left: paddingMedium,
                  top: paddingSmall,
                  bottom: paddingSmall,
                ),
                child: Text(
                  context.localization!.noBedAvailable,
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
      ],
    );
  }
}

/// Screen for showing all [Task]'s within a [Ward] grouped by [Room]'s
class RoomOverviewScreen extends StatelessWidget {
  // TODO fetch the ward data using a future builder
  final WardDTO ward = WardDTO(
    name: "ICU II",
    rooms: [
      RoomDTO(
        name: "XY",
        patients: [
          PatientDTO(
            id: "XY",
            bed: "01",
            tasksUnscheduledCount: 10,
            tasksInProgressCount: 7,
            tasksDoneCount: 1,
          ),
          PatientDTO(
            id: "VW",
            bed: "02",
            tasksUnscheduledCount: 1,
            tasksInProgressCount: 7,
            tasksDoneCount: 24,
          ),
          PatientDTO(
            id: "VW",
            bed: "03",
            tasksUnscheduledCount: 1,
            tasksInProgressCount: 7,
            tasksDoneCount: 24,
          ),
        ],
      ),
      RoomDTO(
        name: "XY",
        patients: [], // empty room
      ),
      RoomDTO(
        name: "XY",
        patients: [
          PatientDTO(
            id: "XY",
            bed: "01",
            tasksUnscheduledCount: 10,
            tasksInProgressCount: 7,
            tasksDoneCount: 1,
          ),
          PatientDTO(
            id: "VW",
            bed: "02",
            tasksUnscheduledCount: 1,
            tasksInProgressCount: 7,
            tasksDoneCount: 24,
          ),
          PatientDTO(
            id: "VW",
            bed: "03",
            tasksUnscheduledCount: 1,
            tasksInProgressCount: 7,
            tasksDoneCount: 24,
          ),
        ],
      ),
      RoomDTO(
        name: "XY",
        patients: [
          PatientDTO(
            id: "XY",
            bed: "01",
            tasksUnscheduledCount: 10,
            tasksInProgressCount: 7,
            tasksDoneCount: 1,
          ),
          PatientDTO(
            id: "VW",
            bed: "02",
            tasksUnscheduledCount: 1,
            tasksInProgressCount: 7,
            tasksDoneCount: 24,
          ),
        ],
      ),
      RoomDTO(
        name: "AB",
        patients: [
          PatientDTO(
            id: "XY",
            bed: "01",
            tasksUnscheduledCount: 10,
            tasksInProgressCount: 7,
            tasksDoneCount: 1,
          ),
          PatientDTO(
            id: "VW",
            bed: "02",
            tasksUnscheduledCount: 1,
            tasksInProgressCount: 7,
            tasksDoneCount: 24,
          ),
          PatientDTO(
            id: "VW",
            bed: "02",
            tasksUnscheduledCount: 1,
            tasksInProgressCount: 7,
            tasksDoneCount: 24,
          ),
          PatientDTO(
            id: "VW",
            bed: "02",
            tasksUnscheduledCount: 1,
            tasksInProgressCount: 7,
            tasksDoneCount: 24,
          ),
        ],
      ),
    ],
  );

  RoomOverviewScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const TasksNavigationDrawer(
          currentPage: NavigationOptions.roomoverview,
        ),
        appBar: AppBar(
          title: Text(ward.name),
          actions: [
            IconButton(
              onPressed: () => print("PRESSED"), // TODO open bottom sheet
              icon: const Icon(Icons.sync_alt),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.pink, // TODO use primary color
          child: const Icon(
            Icons.filter_alt,
            color: Colors.white,
          ),
          onPressed: () => print("PRESSED"), // TODO open filter modal
        ),
        body: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(bottom: 25),
          children: ward.rooms
              .map((RoomDTO room) => _RoomSection(room: room))
              .toList(),
        ));
  }
}
