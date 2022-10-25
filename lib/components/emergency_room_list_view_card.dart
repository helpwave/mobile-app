import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:helpwave/pages/emergency_room_detail.dart';
import 'package:helpwave/styling/constants.dart';

class EmergencyRoomListViewCard extends StatelessWidget {
  final Map<String, dynamic> emergencyRoom;

  const EmergencyRoomListViewCard(this.emergencyRoom, {super.key});

  @override
  Widget build(BuildContext context) {
    const double cardBorderRadius = borderRadiusBig;
    const double cardMargin = paddingMedium;
    const double cardInnerPadding = paddingSmall;

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
              style: Theme.of(context).textTheme.headline6,
            ),
            const Divider(),
            Text("Location: ${emergencyRoom["location"]}"),
            Text("Address: ${emergencyRoom["displayableAddress"]}"),
            Text("Is open: ${(emergencyRoom["open"] ? "open" : "closed")}"),
            Text("Utilization: ${emergencyRoom["utilization"].toString()}"),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          EmergencyRoomDetailPage(emergencyRoom),
                    ),
                  ),
                  child: Text(AppLocalizations.of(context)!.more),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(AppLocalizations.of(context)!.route),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
