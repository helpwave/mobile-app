import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../styling/constants.dart';

class EmergencyRoomDetailPage extends StatelessWidget {
  final Map<String, dynamic> emergencyRoom;

  const EmergencyRoomDetailPage(this.emergencyRoom, {super.key});

  @override
  Widget build(BuildContext context) {
    const double notifyButtonPadding = paddingMedium;
    const double iconSize = iconSizeSmall;
    const double isOpenIconSize = iconSizeTiny;
    const double topDistance = distanceDefault;
    const double sectionDistance = 2 * distanceDefault;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "helpwave",
          textAlign: TextAlign.center,
        ),
      ),
      floatingActionButton: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              Theme.of(context).colorScheme.primaryContainer),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.all(notifyButtonPadding)),
        ),
        onPressed: () {},
        child: Text(AppLocalizations.of(context)!.notifyEmergencyRoom),
      ),
      body: ListView(
        children: [
          Container(
            height: topDistance,
          ),
          Text(
            emergencyRoom["name"],
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6,
          ),
          Container(
            height: sectionDistance,
          ),
          ListTile(
            title: Text(emergencyRoom["displayableAddress"]),
            subtitle: Text(AppLocalizations.of(context)!.address),
            leading: const Icon(
              Icons.map,
              size: iconSize,
            ),
            trailing: const Icon(
              Icons.arrow_forward,
              size: iconSize,
            ),
          ),
          ListTile(
            title: Text(emergencyRoom["open"]
                ? AppLocalizations.of(context)!.open
                : AppLocalizations.of(context)!.closed),
            subtitle: Text(AppLocalizations.of(context)!.availability),
            leading: const Icon(
              Icons.house,
              size: iconSize,
            ),
            trailing: Container(
              width: iconSize,
              height: iconSize,
              decoration: BoxDecoration(
                  color: emergencyRoom["open"] ? positiveColor : negativeColor,
                  shape: BoxShape.circle),
              child: Icon(
                emergencyRoom["open"] ? Icons.check : Icons.close,
                size: isOpenIconSize,
              ),
            ),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.utilization),
            leading: const Icon(
              Icons.more_time,
              size: iconSize,
            ),
            trailing: Text(
              emergencyRoom["utilization"].toString(),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
