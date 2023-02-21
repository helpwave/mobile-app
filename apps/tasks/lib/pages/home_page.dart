import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:tasks/pages/organization_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  // TaskPage should be the default
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget pageForCurrentIndex() {
    // TODO add other pages
    switch (_selectedIndex) {
      case 1:
        return const OrganizationPage();
      default:
        // TODO Replace with Homepage as default
        return const OrganizationPage();
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
      body: pageForCurrentIndex(),
    );
  }
}
