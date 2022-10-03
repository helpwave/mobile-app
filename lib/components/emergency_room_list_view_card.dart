import 'package:flutter/material.dart';

class EmergencyRoomListViewCard extends StatelessWidget {
  final Map<String, dynamic> emergencyRoom;

  const EmergencyRoomListViewCard(this.emergencyRoom, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              emergencyRoom["name"],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Text("Location: " + emergencyRoom["location"]),
            Text("Address: " + emergencyRoom["displayableAddress"]),
            Text("Is open: " + (emergencyRoom["open"] ? "open" : "closed")),
            Text("Utilization: " + emergencyRoom["utilization"].toString()),
          ],
        ),
      ),
    );
  }
}
