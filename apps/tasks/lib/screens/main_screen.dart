import 'dart:async';
import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:tasks/components/patient_bottom_sheet.dart';
import 'package:tasks/screens/main_screen_subscreens/my_tasks_screen.dart';
import 'package:tasks/screens/main_screen_subscreens/patient_screen.dart';

import '../components/task_bottom_sheet.dart';
import '../dataclasses/task.dart';

/// The main screen of the app
///
/// It holds the bottom [NavigationBar] state
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int index = 0;
  bool isShowingActionButton = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, ThemeModel themeNotifier, _) => Scaffold(
        body: [const MyTasksScreen(), const SizedBox(), const PatientScreen()][index],
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: isShowingActionButton ? _TaskPatientFloatingActionButton() : null,
        bottomNavigationBar: NavigationBar(
          indicatorColor: primaryColor,
          backgroundColor: themeNotifier.getIsDarkNullSafe(context) ? Colors.white10 : Colors.white,
          destinations: [
            NavigationDestination(
              selectedIcon: const Icon(
                Icons.check_circle_outline,
                color: Colors.white,
              ),
              icon: const Icon(Icons.check_circle_outline),
              label: context.localization!.myTasks,
            ),
            NavigationDestination(
              selectedIcon: const Icon(
                Icons.add_circle_outline,
                color: Colors.white,
              ),
              icon: const Icon(Icons.add_circle_outline),
              label: context.localization!.addTask,
            ),
            NavigationDestination(
              selectedIcon: const Icon(
                Icons.person,
                color: Colors.white,
              ),
              icon: const Icon(Icons.person),
              label: context.localization!.patients,
            ),
          ],
          selectedIndex: index,
          onDestinationSelected: (value) {
            _timer?.cancel();
            setState(() {
              isShowingActionButton = value == 1;
              index = isShowingActionButton ? index : value;
              if (isShowingActionButton) {
                _timer = Timer(
                  const Duration(seconds: 3),
                  () {
                    setState(() {
                      isShowingActionButton = false;
                    });
                  },
                );
              }
            });
          },
        ),
      ),
    );
  }
}

/// A [FloatingActionButton] shown when the user wants to create a new [Task] of [Patient]
///
/// Shows the two options and onClick opens the corresponding modal
class _TaskPatientFloatingActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double chipWidth = 50;
    double chipHeight = 25;
    double componentHeight = chipHeight + 2 * paddingSmall;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(componentHeight / 2),
        color: primaryColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: paddingSmall),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ActionChip(
              label: SizedBox(
                width: chipWidth,
                height: chipHeight,
                child: Center(child: Text(context.localization!.task)),
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => TaskBottomSheet(task: Task.empty),
                  isScrollControlled: true,
                );
              },
            ),
            const SizedBox(
              width: distanceSmall,
            ),
            ActionChip(
              label: SizedBox(
                width: chipWidth,
                height: chipHeight,
                child: Center(child: Text(context.localization!.patient)),
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => const PatientBottomSheet(patentId: ""),
                  isScrollControlled: true,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
