import 'package:flutter/material.dart';
import 'package:tasks/components/navigation_drawer.dart';

/// The Screen for showing all [Task]'s the [User] has in the current [ ]
class MyTasksScreen extends StatelessWidget{
  const MyTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavigationDrawer(currentPage: NavigationOptions.myTasks),
      appBar: AppBar(),
      body: const Center(child: Text("MyTasksScreen")),
    );
  }
}
