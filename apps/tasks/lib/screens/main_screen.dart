import 'dart:async';
import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:tasks/screens/main_screen_subscreens/my_tasks_screen.dart';
import 'package:tasks/screens/main_screen_subscreens/patient_screen.dart';

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
              onPressed: () {},
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
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
