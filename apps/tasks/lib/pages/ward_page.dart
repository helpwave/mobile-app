import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';

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
    return Scaffold(appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () {

              },
          ),),
          body: Column(
            children: [
              Padding(padding:const EdgeInsets.all(distanceDefault),
                child: TextField(decoration: InputDecoration(
                    hintText: context.localization!.search,
                    suffixIcon: IconButton(onPressed: () {},
                        icon: const Icon(Icons.search))),),
              ),
            ],
          ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items:  [
          BottomNavigationBarItem(
            activeIcon: const Icon(Icons.door_back_door,
              color: Colors.white,),
            icon: const Icon(Icons.door_back_door,
                color: Colors.grey),
            label: context.localization!.rooms,
          ),
          BottomNavigationBarItem(
            activeIcon: const Icon(Icons.person,
              color: Colors.white,),
            icon: const Icon(Icons.person,
                color: Colors.grey),
            label: context.localization!.patients,
          ),
          BottomNavigationBarItem(
            activeIcon: const Icon(Icons.bed,
              color: Colors.white,),
            icon: const Icon(Icons.bed,
                color: Colors.grey),
            label: context.localization!.beds,
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
