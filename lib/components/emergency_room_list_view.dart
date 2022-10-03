import 'package:flutter/material.dart';

import 'emergency_room_list_view_card.dart';

class EmergencyRoomListView extends StatefulWidget {
  const EmergencyRoomListView({super.key});

  @override
  State<StatefulWidget> createState() => _EmergencyRoomListViewState();
}

class _EmergencyRoomListViewState extends State<EmergencyRoomListView> {
  // TODO Remove when Backend-integration implemented
  Future<List<Map<String, dynamic>>> getEmergencyRooms() async {
    return [
      {
        'location': '0.0,0.0',
        'displayableAddress': 'Ger, Münster, Münster Straße 2',
        'name': 'Uniklinikum',
        'open': false,
        'utilization': 1
      },
      {
        'location': '0.0,0.0',
        'displayableAddress': 'Ger, Münster, Hafenweg 209',
        'name': 'Anderes Klinikum',
        'open': true,
        'utilization': 5
      },
      {
        'location': '0.0,0.0',
        'displayableAddress': 'Ger, Rheine, Weitweg Straße 24',
        'name': 'Mathiasspital',
        'open': true,
        'utilization': 2
      }
    ];
  }

  @override
  Widget build(BuildContext context) {
    // TODO Change datatype below     v here
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: getEmergencyRooms(),
      builder: (context, snapshot) {
        List<Widget> children = [];
        // TODO Change snapshot handling when datatype changed
        if (snapshot.hasData) {
          if (snapshot.data!.isNotEmpty) {
            children = snapshot.data!
                .map((emergencyRoom) {
                  return EmergencyRoomListViewCard(emergencyRoom);
                })
                .toList()
                .cast<Widget>();
          }
        } else if (snapshot.hasError) {
          children = <Widget>[
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
              size: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('Error: ${snapshot.error}'),
            ),
          ];
        } else {
          children = const <Widget>[
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text('Awaiting result...'),
            ),
          ];
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          ),
        );
      },
    );
  }
}
