import 'package:flutter/material.dart';
import '../styling/constants.dart';
import 'emergency_room_bottom_sheet.dart';
import 'emergency_room_list_view_card.dart';

class EmergencyRoomListView extends StatefulWidget {
  const EmergencyRoomListView({super.key});

  @override
  State<StatefulWidget> createState() => _EmergencyRoomListViewState();
}

class _EmergencyRoomListViewState extends State<EmergencyRoomListView>
    with SingleTickerProviderStateMixin {
  late Future<List<Map<String, dynamic>>> future;

  // TODO Remove when Backend-integration implemented
  Future<List<Map<String, dynamic>>> getEmergencyRooms() async {
    return [
      {
        'location': '0.0,0.0',
        'displayableAddress': 'Ger, Münster, Münster Straße 2',
        'name': 'Uniklinikum',
        'open': false,
        'utilization': 1,
        'facilities': {
          "Facility 1": const Color.fromARGB(255, 120, 140, 255),
          "Facility 3": const Color.fromARGB(255, 10, 140, 80),
          "Facility 2": const Color.fromARGB(255, 120, 200, 40),
          "Facility 5": const Color.fromARGB(255, 250, 140, 255),
          "Facility 4": const Color.fromARGB(255, 250, 70, 30),
          "Facility 7": const Color.fromARGB(255, 250, 70, 30),
          "Facility 9": const Color.fromARGB(255, 250, 70, 30),
        },
      },
      {
        'location': '0.0,0.0',
        'displayableAddress': 'Ger, Münster, Hafenweg 209',
        'name': 'Anderes Klinikum',
        'open': true,
        'utilization': 5,
        'facilities': <String, Color>{},
      },
      {
        'location': '0.0,0.0',
        'displayableAddress': 'Ger, Rheine, Weitweg Straße 24',
        'name': 'Mathiasspital',
        'open': true,
        'utilization': 2,
        'facilities': <String, Color>{},
      }
    ];
  }

  @override
  void initState() {
    future = getEmergencyRooms();
    future.then(
      (value) {
        if (value.isNotEmpty) {
          EmergencyRoomBottomSheet.show(
            context: context,
            emergencyRoom: value[0],
            tickerProvider: this,
            animationDuration: zeroDuration,
            title: Text(
              "vjidfoibn",
              style: Theme.of(context).textTheme.headline5,
            ),
          );
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const double indicatorTextDistance = distanceDefault;
    const double indicatorSize = iconSizeBig;

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: future,
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
              size: indicatorSize,
            ),
            const SizedBox(height: indicatorTextDistance),
            Text('Error: ${snapshot.error}'),
          ];
        } else {
          children = const <Widget>[
            SizedBox(
              width: indicatorSize,
              height: indicatorSize,
              child: CircularProgressIndicator(),
            ),
            SizedBox(height: indicatorTextDistance),
            Text('Awaiting result...'),
          ];
        }
        return Center(
          child: ListView(
            children: children,
          ),
        );
      },
    );
  }
}
