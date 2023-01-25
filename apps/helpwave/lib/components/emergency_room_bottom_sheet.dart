import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave/components/street_map.dart';
import 'package:helpwave/styling/constants.dart';

/// Bottom Sheet to display when the user requires more information about the
/// [EmergencyRoom]
///
/// Shows Location and allows Navigation
///
/// The [EmergencyRoom] can be notified of arrival
class EmergencyRoomBottomSheet extends StatefulWidget {
  /// A Custom Widget to display as an header
  final Widget? title;

  /// The [EmergencyRoom] used to display information or to notify
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
          : AnimationController(duration: const Duration(seconds: 0), vsync: tickerProvider),
      builder: (context) => EmergencyRoomBottomSheet(emergencyRoom, title: title),
    );
  }

  @override
  State<StatefulWidget> createState() => _EmergencyRoomBottomSheetState();
}

class _EmergencyRoomBottomSheetState extends State<EmergencyRoomBottomSheet> {
  bool hasNotified = false;
  final double _mainWidthPercentage = 0.90;
  final double _sectionDistance = distanceDefault;

  Color getMainBackGroundColor(BuildContext context) => Theme.of(context).colorScheme.inversePrimary;

  Widget getMapWidget(BuildContext context) {
    const double mainTopBorder = distanceSmall;
    const double mapIconDistance = distanceDefault;
    const double mapIconSize = iconSizeSmall;
    ValueNotifier<bool> trackingNotifier = ValueNotifier(false);
    Size mediaQuery = MediaQuery.of(context).size;

    return Expanded(
      child: Stack(
        children: [
          Positioned(
            child: StreetMap(
              borderRadius: 0,
              width: mediaQuery.width,
              height: mediaQuery.height,
              trackingNotifier: trackingNotifier,
              controller: mapController,
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
                    onPressed: () {
                      if (!trackingNotifier.value) {
                        mapController.currentLocation();
                        mapController.enableTracking();
                      } else {
                        mapController.disabledTracking();
                        trackingNotifier.value = !trackingNotifier.value;
                      }
                    },
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
                color: getMainBackGroundColor(context),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(mainTopBorder),
                  topRight: Radius.circular(mainTopBorder),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getMainContent(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    double mainPaddingPercentage = (1 - _mainWidthPercentage) / 2;
    ButtonStyle tableButtonStyle = ButtonStyle(
      backgroundColor: MaterialStatePropertyAll(getMainBackGroundColor(context)),
      textStyle: const MaterialStatePropertyAll(TextStyle(fontSize: 14)),
      alignment: Alignment.centerLeft,
      elevation: const MaterialStatePropertyAll(0),
    );
    List<MapEntry<String, Color>> facilities = widget.emergencyRoom["facilities"]! as List<MapEntry<String, Color>>;
    String emergencyNumber = "112";
    String helpNumber = "116 177";
    const double tableButtonSize = iconSizeVeryTiny;
    const double chipTransformScale = 0.90;
    const double chipPadding = 2;
    const double chipListviewHeight = 35;

    List<Widget> chipList = [];
    chipList.add(Transform(
      transform: Matrix4.identity()..scale(chipTransformScale),
      child: Chip(
        padding: const EdgeInsets.all(chipPadding),
        label: Text(
          widget.emergencyRoom["open"] ? context.localization!.open : context.localization!.closed,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: fontSizeTiny),
        ),
        backgroundColor: widget.emergencyRoom["open"] ? positiveColor : negativeColor,
      ),
    ));

    chipList.addAll(
      facilities.map(
        (MapEntry<String, Color> e) => Transform(
          transform: Matrix4.identity()..scale(chipTransformScale),
          child: Chip(
            padding: const EdgeInsets.all(chipPadding),
            label: Text(
              e.key,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: fontSizeTiny),
            ),
            backgroundColor: e.value,
          ),
        ),
      ),
    );

    return Container(
      padding: EdgeInsets.only(
        right: mediaQuery.width * mainPaddingPercentage,
        left: mediaQuery.width * mainPaddingPercentage,
      ),
      decoration: BoxDecoration(
        color: getMainBackGroundColor(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: distanceSmall, bottom: distanceSmall),
            child: Text(
              widget.emergencyRoom["name"],
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          SizedBox(
            width: mediaQuery.width,
            height: chipListviewHeight,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: chipList,
            ),
          ),
          Container(
            height: _sectionDistance,
          ),
          Text(
            context.localization!.address,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.secondary),
          ),
          Text(
            "${widget.emergencyRoom["displayableAddress"]}",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
          SizedBox(
            height: _sectionDistance,
          ),
          Text(
            context.localization!.otherFunctions,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.secondary),
          ),
          SizedBox(
            height: _sectionDistance,
          ),
          Table(
            children: [
              TableRow(
                children: [
                  SizedBox(
                    height: iconSizeSmall,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.home,
                        size: tableButtonSize,
                      ),
                      label: Text(context.localization!.giveDetails),
                      style: tableButtonStyle,
                    ),
                  ),
                  SizedBox(
                    height: iconSizeSmall,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.phone,
                        size: tableButtonSize,
                      ),
                      label: Text("$emergencyNumber ${context.localization!.call}",
                          style: const TextStyle(color: negativeColor)),
                      style: tableButtonStyle,
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  SizedBox(
                    height: iconSizeSmall,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.location_on_outlined,
                        size: tableButtonSize,
                      ),
                      label: Text(context.localization!.searchDoctorsOffices),
                      style: tableButtonStyle,
                    ),
                  ),
                  SizedBox(
                    height: iconSizeSmall,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.phone,
                        size: tableButtonSize,
                      ),
                      label: Text(
                        "$helpNumber ${context.localization!.call}",
                        style: const TextStyle(color: negativeColor),
                      ),
                      style: tableButtonStyle,
                    ),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget getBottomButtons(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    ButtonStyle buttonStyleBase = ButtonStyle(
      fixedSize: MaterialStatePropertyAll<Size>(
        Size(mediaQuery.width * 0.70, 40),
      ),
    );
    ButtonStyle buttonStylePositive = buttonStyleBase.copyWith(
      backgroundColor: const MaterialStatePropertyAll(positiveColor),
    );
    ButtonStyle buttonStyleNegative = buttonStyleBase.copyWith(
      backgroundColor: const MaterialStatePropertyAll(negativeColor),
    );
    ButtonStyle buttonStyleNeutral = buttonStyleBase.copyWith(
      backgroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.tertiary),
    );

    return Container(
      color: getMainBackGroundColor(context),
      width: mediaQuery.width,
      child: Column(
        children: [
          SizedBox(
            height: _sectionDistance,
          ),
          hasNotified
              ? ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      hasNotified = false;
                    });
                  },
                  style: buttonStyleNegative,
                  icon: const Icon(Icons.close),
                  label: Text(context.localization!.notifyCancel),
                )
              : ElevatedButton(
                  onPressed: () {
                    setState(() {
                      hasNotified = true;
                    });
                  },
                  style: buttonStylePositive,
                  child: Text(context.localization!.notify),
                ),
          Container(
            margin: const EdgeInsets.all(marginSmall),
            child: hasNotified
                ? ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.navigation),
                    style: buttonStylePositive,
                    label: Text(context.localization!.startNavigation),
                  )
                : ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: buttonStyleNeutral,
                    child: Text(context.localization!.otherEmergencyRooms),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    const double topBannerHeightPercentage = 0.15;

    return Column(
      children: [
        SizedBox(
          height: widget.title != null ? mediaQuery.height * topBannerHeightPercentage : 0,
          child: widget.title,
        ),
        getMapWidget(context),
        getMainContent(context),
        getBottomButtons(context),
        Container(
          width: mediaQuery.width,
          height: _sectionDistance,
          color: getMainBackGroundColor(context),
        )
      ],
    );
  }
}
