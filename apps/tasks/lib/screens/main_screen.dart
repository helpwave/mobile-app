import 'dart:async';
import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_service/auth.dart';
import 'package:helpwave_service/tasks.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_theme/theme.dart';
import 'package:helpwave_widget/bottom_sheets.dart';
import 'package:helpwave_widget/animation.dart';
import 'package:provider/provider.dart';
import 'package:tasks/components/patient_bottom_sheet.dart';
import 'package:tasks/components/task_bottom_sheet.dart';
import 'package:tasks/components/user_header.dart';
import 'package:tasks/screens/main_screen_subscreens/my_tasks_screen.dart';
import 'package:tasks/screens/main_screen_subscreens/patient_screen.dart';
import 'package:tasks/screens/ward_select_screen.dart';

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
    return Consumer2<ThemeModel, CurrentWardController>(
        builder: (BuildContext context, ThemeModel themeNotifier, CurrentWardController currentWardService, _) {
      if (!currentWardService.isInitialized) {
        return const WardSelectScreen();
      }
      return Scaffold(
        appBar: const UserHeader(),
        body: SafeArea(child: [const MyTasksScreen(), const SizedBox(), const PatientScreen()][index]),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: PopInAndOutAnimator(
          visible: isShowingActionButton,
          child: _TaskPatientFloatingActionButton(),
        ),
        bottomNavigationBar: NavigationBar(
          indicatorColor: Theme.of(context).colorScheme.secondary,
          backgroundColor: themeNotifier.getIsDarkNullSafe(context) ? Colors.white10 : Colors.white,
          destinations: [
            NavigationDestination(
              selectedIcon: Icon(
                Icons.check_circle_outline,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
              icon: const Icon(Icons.check_circle_outline),
              label: context.localization!.myTasks,
            ),
            NavigationDestination(
              selectedIcon: Icon(
                Icons.add_circle_outline,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
              icon: const Icon(Icons.add_circle_outline),
              label: context.localization!.newTaskOrPatient,
            ),
            NavigationDestination(
              selectedIcon: Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.onSecondary,
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
      );
    });
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
        borderRadius: BorderRadius.circular(componentHeight),
        color: Color.alphaBlend(Theme.of(context).colorScheme.secondary.withOpacity(0.7), Colors.black),
      ),
      child: Padding(
        padding: const EdgeInsets.all(paddingSmall),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ActionChip(
              labelPadding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
              side: BorderSide.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(chipHeight), // Adjust the radius as needed
              ),
              label: SizedBox(
                width: chipWidth,
                height: chipHeight,
                child: Center(child: Text(context.localization!.task)),
              ),
              onPressed: () {
                context.pushModal(
                  context: context,
                  builder: (context) => TaskBottomSheet(task: Task.empty("")),
                );
              },
            ),
            const SizedBox(
              width: distanceSmall,
            ),
            ActionChip(
              labelPadding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
              side: BorderSide.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(chipHeight), // Adjust the radius as needed
              ),
              label: SizedBox(
                width: chipWidth,
                height: chipHeight,
                child: Center(child: Text(context.localization!.patient)),
              ),
              onPressed: () {
                context.pushModal(
                  context: context,
                  builder: (context) => const PatientBottomSheet(patentId: ""),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
