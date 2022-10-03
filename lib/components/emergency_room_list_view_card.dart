import 'package:flutter/material.dart';

class EmergencyRoomListViewCard extends StatelessWidget {
  final Map<String, dynamic> emergencyRoom;

  const EmergencyRoomListViewCard(this.emergencyRoom, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(emergencyRoom["name"]),
          Text(emergencyRoom["location"]),
          Text(emergencyRoom["displayableAddress"]),
          Text(emergencyRoom["open"]?"open":"closed"),
          Text(emergencyRoom["utilization"].toString()),
        ],
      ),
    );
  }
}
