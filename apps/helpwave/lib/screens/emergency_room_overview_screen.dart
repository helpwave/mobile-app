import 'package:flutter/material.dart';
import 'package:helpwave/components/emergency_room_list_view.dart';

/// Screen for displaying possible Emergency Rooms near the Patient
class EmergencyRoomOverviewScreen extends StatelessWidget {
  const EmergencyRoomOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("helpwave"),
      ),
      body: const EmergencyRoomListView(),
    );
  }
}
