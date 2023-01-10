import 'package:flutter/material.dart';
import 'package:helpwave/components/emergency_room_list_view.dart';

/// Page for displaying possible Emergency Rooms near the Patient
class EmergencyRoomOverviewPage extends StatelessWidget {
  const EmergencyRoomOverviewPage({super.key});

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
