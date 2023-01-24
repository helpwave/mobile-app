import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave/components/emergency_room_bottom_sheet.dart';
import 'package:helpwave/styling/constants.dart';

/// The Widget allows to get more information about the [EmergencyRoom]
///  or to start a navigation to its location
class EmergencyRoomListViewCard extends StatelessWidget {
  /// The [EmergencyRoom] used for Information and Navigation
  final Map<String, dynamic> emergencyRoom;

  const EmergencyRoomListViewCard(this.emergencyRoom, {super.key});

  @override
  Widget build(BuildContext context) {
    const double cardBorderRadius = borderRadiusVeryBig;
    const double cardMargin = paddingMedium;
    const double cardInnerPadding = paddingSmall;
    const double buttonDistance = distanceDefault;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardBorderRadius),
      ),
      margin: const EdgeInsets.all(cardMargin),
      child: Padding(
        padding: const EdgeInsets.all(cardInnerPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              emergencyRoom["name"],
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(),
            Text("${context.localization!.location}: "
                "${emergencyRoom["location"]}"),
            Text("${context.localization!.address}: "
                "${emergencyRoom["displayableAddress"]}"),
            Text("${context.localization!.availability}: "
                " ${(emergencyRoom["open"] ? context.localization!.open : context.localization!.closed)}"),
            Text("${context.localization!.utilization}: "
                " ${emergencyRoom["utilization"].toString()}"),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      EmergencyRoomBottomSheet.show(
                        context: context,
                        emergencyRoom: emergencyRoom,
                      );
                    },
                    child: Text(context.localization!.more),
                  ),
                ),
                Container(
                  width: buttonDistance,
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {},
                    child: Text(context.localization!.route),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
