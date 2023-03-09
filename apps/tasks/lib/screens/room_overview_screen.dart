import 'package:flutter/material.dart';
import 'package:tasks/components/navigation_drawer.dart';

/// Screen for showing all [Task]'s within a [Ward] grouped by [Room]'s
class RoomOverviewScreen extends StatelessWidget{
  const RoomOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavigationDrawer(currentPage: NavigationOptions.roomoverview),
      appBar: AppBar(),
      body: const Center(child: Text("RoomOverviewScreen")),
    );
  }
}
