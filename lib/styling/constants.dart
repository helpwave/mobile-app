import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

// Buttons
const double buttonWidth = 250;
const double buttonHeight = 50;
const BorderSide buttonBorderSide = BorderSide(width: 1);
const TextStyle buttonTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w500,
);
ButtonStyle buttonStyle = ButtonStyle(
  fixedSize:
      MaterialStateProperty.all<Size>(const Size(buttonWidth, buttonHeight)),
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadiusMedium),
    ),
  ),
  textStyle: MaterialStateProperty.all<TextStyle>(buttonTextStyle),
);

// Paddings/Distances
const double distanceTiny = 6;
const double distanceSmall = 10;
const double distanceDefault = 20;
const double distanceBig = 40;
const double paddingSmall = 10;
const double paddingMedium = distanceDefault;
const double paddingBig = 40;

// Icon
const double iconSizeVeryTiny = 16;
const double iconSizeTiny = 24;
const double iconSizeSmall = 32;
const double iconSizeMedium = 48;
const double iconSizeBig = 64;
const double iconSizeVeryBig = 128;

// Border Radius
const double borderRadiusTiny = 3;
const double borderRadiusSmall = 5;
const double borderRadiusMedium = 10;
const double borderRadiusBig = 15;
const double borderRadiusVeryBig = 20;

// Colors
const positiveColor = Color.fromARGB(255, 52, 199, 89);
const negativeColor = Color.fromARGB(255, 255, 51, 51);

// Animation
const Duration zeroDuration = Duration.zero;
const Duration bottomSheetOpenDuration = Duration(milliseconds: 100);

// Font size
const double fontSizeTiny = 12;
const double fontSizeSmall = 14;
const double fontSizeMedium = 16;
const double fontSizeBig = 20;

// OpenStreetMap
MapController mapController = MapController(
  initMapWithUserPosition: false,
  initPosition: GeoPoint(
    latitude: 51.9582531914801,
    longitude: 7.614308513084836,
  ),
  areaLimit: BoundingBox(
    east: 7.868367326136183,
    north: 52.05926850228487,
    south: 51.815854199654915,
    west: 7.459126643491313,
  ),
);
