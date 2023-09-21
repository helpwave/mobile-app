import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:tasks/screens/main_screen_subscreens/create_screen.dart';
import 'package:tasks/screens/main_screen_subscreens/my_tasks_screen.dart';
import 'package:tasks/screens/main_screen_subscreens/patient_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, ThemeModel themeNotifier, _) => Scaffold(
        body: [const MyTasksScreen(), const CreateScreen(), const PatientScreen()][index],
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
          onDestinationSelected: (value) => setState(() {
            index = value;
          }),
        ),
      ),
    );
  }
}
