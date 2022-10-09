import 'package:flutter/material.dart';
import 'package:helpwave/components/emergency_room_list_view.dart';

class EmergencyRoomOverview extends StatelessWidget {
  const EmergencyRoomOverview({super.key});

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
