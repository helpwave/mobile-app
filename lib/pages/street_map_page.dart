import 'package:flutter/material.dart';
import 'package:helpwave/components/street_map.dart';
import 'package:helpwave/styling/constants.dart';

/// Page for displaying a Map with Emergency Rooms as Markers
///
/// Uses [StreetMap] as a Map
///
/// Tracking of the Patients position can be toggled
class StreetMapPage extends StatelessWidget {
  const StreetMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> trackingNotifier = ValueNotifier(false);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("helpwave"),
      ),
      body: StreetMap(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        trackingNotifier: trackingNotifier,
        controller: mapController,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () async {
          if (!trackingNotifier.value) {
            await mapController.currentLocation();
            await mapController.enableTracking();
          } else {
            await mapController.disabledTracking();
            trackingNotifier.value = !trackingNotifier.value;
          }
        },
        child: ValueListenableBuilder<bool>(
          valueListenable: trackingNotifier,
          builder: (ctx, isTracking, _) {
            if (isTracking) {
              return const Icon(Icons.gps_off_sharp);
            }
            return const Icon(Icons.my_location, color: Colors.white);
          },
        ),
      ),
    );
  }
}
