import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:helpwave/components/emergency_room_bottom_sheet.dart';
import 'package:helpwave/styling/constants.dart';

class EmergencyRoomListViewCard extends StatelessWidget {
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
            Text("${AppLocalizations.of(context)!.location}: "
                "${emergencyRoom["location"]}"),
            Text("${AppLocalizations.of(context)!.address}: "
                "${emergencyRoom["displayableAddress"]}"),
            Text("${AppLocalizations.of(context)!.availability}: "
                " ${(emergencyRoom["open"] ? AppLocalizations.of(context)!.open : AppLocalizations.of(context)!.closed)}"),
            Text("${AppLocalizations.of(context)!.utilization}: "
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
                    child: Text(AppLocalizations.of(context)!.more),
                  ),
                ),
                Container(
                  width: buttonDistance,
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {},
                    child: Text(AppLocalizations.of(context)!.route),
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
