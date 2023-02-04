import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';

class WardPage extends StatefulWidget{
  const WardPage({super.key});

  @override
  State<StatefulWidget> createState()  => WardPageState();

}

class WardPageState extends State<WardPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items:  [
          BottomNavigationBarItem(
            activeIcon: const Icon(Icons.local_hospital,
              color: Colors.white,),
            icon: const Icon(Icons.local_hospital,
                color: Colors.grey),
            label: context.localization!.organisations,
          ),
          BottomNavigationBarItem(
            activeIcon: const Icon(Icons.medical_information,
              color: Colors.white,),
            icon: const Icon(Icons.medical_information,
                color: Colors.grey),
            label: context.localization!.station,
          ),
          BottomNavigationBarItem(
            activeIcon: const Icon(Icons.task,
              color: Colors.white,),
            icon: const Icon(Icons.task,
                color: Colors.grey),
            label: context.localization!.tasks,
          ),
          BottomNavigationBarItem(
            activeIcon: const Icon(Icons.settings,
              color: Colors.white,),
            icon: const Icon(Icons.settings,
              color: Colors.grey,),
            label: context.localization!.settings,
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

}