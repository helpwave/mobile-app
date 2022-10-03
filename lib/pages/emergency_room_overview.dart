import 'package:flutter/material.dart';
import 'package:helpwave/components/emergency_room_list_view.dart';

class EmergencyRoomOverview extends StatelessWidget {
  const EmergencyRoomOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "helpwave",
          ),
        ),
      ),
      body: const EmergencyRoomListView(),
    );
  }
}
