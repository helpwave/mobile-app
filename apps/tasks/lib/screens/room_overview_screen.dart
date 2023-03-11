import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tasks/components/navigation_drawer.dart';
import 'package:tasks/components/bed_card.dart';

/// Screen for showing all [Task]'s within a [Ward] grouped by [Room]'s
class RoomOverviewScreen extends StatelessWidget {
  final Random _random = Random();

  RoomOverviewScreen({super.key});

  int _getRandomNumber({int min = 0, int max = 20}) =>
      min + _random.nextInt(max - min);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.5;
    double height = 100;
    double ratio = width / height;

    return Scaffold(
      drawer: const TasksNavigationDrawer(
        currentPage: NavigationOptions.roomoverview,
      ),
      appBar: AppBar(),
      body: GridView.count(
        childAspectRatio: ratio,
        padding: const EdgeInsets.all(15),
        crossAxisCount: 2,
        children: List.generate(
          _getRandomNumber() + 3,
          (int index) => BedCard(
            patient: PatientDTO(
              id: String.fromCharCode(index * 2 + 65) +
                  String.fromCharCode(index * 2 + 66),
              bed: (index + 1).toString().padLeft(2, "0"),
              tasksUnscheduledCount: _getRandomNumber(),
              tasksInProgressCount: _getRandomNumber(),
              tasksDoneCount: _getRandomNumber(),
            ),
          ),
        ),
      ),
    );
  }
}
