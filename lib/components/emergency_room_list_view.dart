import 'package:flutter/material.dart';
import '../styling/constants.dart';
import 'emergency_room_bottom_sheet.dart';
import 'emergency_room_list_view_card.dart';

/// A [ListView] from which the User can select a Emergency Room
///
/// The displayed [EmergencyRoomListViewCard] allows to get more information
/// about the [EmergencyRoom] or to start a navigation to its location
class EmergencyRoomListView extends StatefulWidget {
  const EmergencyRoomListView({super.key});

  @override
  State<StatefulWidget> createState() => _EmergencyRoomListViewState();
}

class _EmergencyRoomListViewState extends State<EmergencyRoomListView>
    with SingleTickerProviderStateMixin {
  late Future<List<Map<String, dynamic>>> future;

  /// Function to load Emergency Rooms to Display
  Future<List<Map<String, dynamic>>> getEmergencyRooms() async {
    // TODO Remove when Backend-integration implemented
    return [
      {
        'location': '0.0,0.0',
        'displayableAddress': 'Ger, Münster, Münster Straße 2',
        'name': 'Uniklinikum',
        'open': false,
        'utilization': 1,
        'facilities': <MapEntry<String, Color>>[
          const MapEntry("Facility 1", Color.fromARGB(255, 120, 140, 255)),
          const MapEntry("Facility 2", Color.fromARGB(255, 10, 140, 80)),
          const MapEntry("Facility 3", Color.fromARGB(255, 120, 200, 40)),
          const MapEntry("Facility 4", Color.fromARGB(255, 250, 140, 255)),
          const MapEntry("Facility 5", Color.fromARGB(255, 250, 70, 30)),
          const MapEntry("Facility 6", Color.fromARGB(255, 120, 140, 255)),
          const MapEntry("Facility 7", Color.fromARGB(255, 250, 70, 30)),
        ],
      },
      {
        'location': '0.0,0.0',
        'displayableAddress': 'Ger, Münster, Hafenweg 209',
        'name': 'Anderes Klinikum',
        'open': true,
        'utilization': 5,
        'facilities': <MapEntry<String, Color>>[],
      },
      {
        'location': '0.0,0.0',
        'displayableAddress': 'Ger, Rheine, Weitweg Straße 24',
        'name': 'Mathiasspital',
        'open': true,
        'utilization': 2,
        'facilities': <MapEntry<String, Color>>[],
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
            title: RichText(
              text: TextSpan(
                text: "Text Text Text",
                style: Theme.of(context).textTheme.headlineSmall,
                children: const <TextSpan>[
                  TextSpan(
                      text: " TEXT TEXT",
                      style: TextStyle(color: positiveColor)),
                  TextSpan(text: " Text Text."),
                ],
              ),
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
