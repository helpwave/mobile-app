import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:tasks/screens/organization_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  // TaskScreen should be the default
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget screenForCurrentIndex() {
    // TODO add other screen
    switch (_selectedIndex) {
      case 1:
        return const OrganizationScreen();
      default:
        // TODO Replace with home screen as default
        return const OrganizationScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO update later with new Color Scheme
    Color activeColor = Theme.of(context).colorScheme.primary;
    Color inactiveColor = activeColor.withOpacity(0.6);

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.medical_information),
            label: context.localization!.station,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.task),
            label: context.localization!.tasks,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: context.localization!.settings,
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: activeColor,
        unselectedItemColor: inactiveColor,
      ),
      body: screenForCurrentIndex(),
    );
  }
}
