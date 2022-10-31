import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:helpwave/components/street_map.dart';
import '../styling/constants.dart';

class EmergencyRoomBottomSheet extends StatelessWidget {
  final Widget? title;
  final Map<String, dynamic> emergencyRoom;

  const EmergencyRoomBottomSheet(this.emergencyRoom, {super.key, this.title});

  static show(
      {required context,
      required Map<String, dynamic> emergencyRoom,
      TickerProvider? tickerProvider,
      Duration animationDuration = bottomSheetOpenDuration,
      Widget? title}) {
    showBottomSheet(
      context: context,
      transitionAnimationController: tickerProvider == null
          ? null
          : AnimationController(
              duration: const Duration(seconds: 0), vsync: tickerProvider),
      builder: (context) =>
          EmergencyRoomBottomSheet(emergencyRoom, title: title),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    const double topBannerHeightPercentage = 0.15;
    const double mainTopBorder = distanceSmall;
    const double mapIconDistance = distanceDefault;
    const double mapIconSize = iconSizeSmall;
    const double sectionDistance = distanceDefault;
    Color mainBackgroundColor = Theme.of(context).colorScheme.inversePrimary;
    const double mainWidthPercentage = 0.90;
    const double mainPaddingPercentage = (1 - mainWidthPercentage) / 2;
    ButtonStyle tableButtonStyle = ButtonStyle(
      backgroundColor: MaterialStatePropertyAll(mainBackgroundColor),
      textStyle: const MaterialStatePropertyAll(TextStyle(fontSize: 14)),
      alignment: Alignment.centerLeft,
    );
    Map<String, Color> facilities =
        emergencyRoom["facilities"]! as Map<String, Color>;
    String emergencyNumber = "112";
    String helpNumber = "116 177";
    const tableButtonSize = iconSizeTiny;

    return Column(
      children: [
        SizedBox(
          height:
              title != null ? mediaQuery.height * topBannerHeightPercentage : 0,
          child: title,
        ),
        Expanded(
          child: Stack(
            children: [
              Positioned(
                child: StreetMap(
                  border: 0,
                  width: mediaQuery.width,
                  height: mediaQuery.height,
                ),
              ),
              Positioned(
                bottom: mapIconDistance,
                right: mapIconDistance,
                child: Material(
                  color: Colors.transparent,
                  child: Center(
                    child: Ink(
                      decoration: const ShapeDecoration(
                        color: positiveColor,
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.navigation,
                          size: mapIconSize,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: mediaQuery.width,
                  height: mainTopBorder,
                  decoration: BoxDecoration(
                    color: mainBackgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(mainTopBorder),
                      topRight: Radius.circular(mainTopBorder),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(
            right: mediaQuery.width * mainPaddingPercentage,
            left: mediaQuery.width * mainPaddingPercentage,
          ),
          decoration: BoxDecoration(
            color: mainBackgroundColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: distanceSmall, bottom: distanceSmall),
                child: Text(
                  emergencyRoom["name"],
                  textAlign: TextAlign.left,
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: Theme.of(context).colorScheme.primary),
                ),
              ),
              SizedBox(
                width: mediaQuery.width,
                height: 35,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: facilities.length,
                  itemBuilder: (context, index) => Transform(
                    transform: Matrix4.identity()..scale(0.9),
                    child: Chip(
                      padding: const EdgeInsets.all(2),
                      label: SizedBox(
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          facilities.keys.toList()[index],
                          style: const TextStyle(fontSize: fontSizeTiny),
                        ),
                      ),
                      backgroundColor:
                          facilities[facilities.keys.toList()[index]],
                    ),
                  ),
                ),
              ),
              Container(
                height: sectionDistance,
              ),
              Text(
                AppLocalizations.of(context)!.address,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Theme.of(context).colorScheme.secondary),
              ),
              Text(
                " ${emergencyRoom["displayableAddress"]}",
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(
                height: sectionDistance,
              ),
              Text(
                AppLocalizations.of(context)!.otherFunctions,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Theme.of(context).colorScheme.secondary),
              ),
              Table(
                children: [
                  TableRow(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.home,
                          size: tableButtonSize,
                        ),
                        label: Text(AppLocalizations.of(context)!.giveDetails),
                        style: tableButtonStyle,
                      ),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.phone,
                          size: tableButtonSize,
                        ),
                        label: Text(
                            "$emergencyNumber ${AppLocalizations.of(context)!.call}",
                            style: const TextStyle(color: negativeColor)),
                        style: tableButtonStyle,
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.location_on_outlined,
                          size: tableButtonSize,
                        ),
                        label: Text(
                            AppLocalizations.of(context)!.searchDoctorsOffices),
                        style: tableButtonStyle,
                      ),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.phone,
                          size: tableButtonSize,
                        ),
                        label: Text(
                          "$helpNumber ${AppLocalizations.of(context)!.call}",
                          style: const TextStyle(color: negativeColor),
                        ),
                        style: tableButtonStyle,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          color: mainBackgroundColor,
          width: mediaQuery.width,
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  fixedSize: MaterialStatePropertyAll<Size>(
                    Size(mediaQuery.width * 0.9, 40),
                  ),
                  backgroundColor:
                      const MaterialStatePropertyAll(positiveColor),
                ),
                child: Text(AppLocalizations.of(context)!.notify),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all<Size>(
                    Size(mediaQuery.width * 0.9, 40),
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).colorScheme.secondary),
                ),
                child: Text(AppLocalizations.of(context)!.otherEmergencyRooms),
              ),
            ],
          ),
        ),
        Container(
          width: mediaQuery.width,
          height: sectionDistance,
          color: mainBackgroundColor,
        )
      ],
    );
  }
}
