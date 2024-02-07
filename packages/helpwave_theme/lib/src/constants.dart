import 'package:flutter/material.dart';

/// Button attributes and

const BorderSide buttonBorderSideSmall = BorderSide(width: 1);
const BorderSide buttonBorderSideMedium = BorderSide(width: 1.5);
const BorderSide buttonBorderSideBig = BorderSide(width: 2);

ButtonStyle buttonStyleSmall = ButtonStyle(
  minimumSize: const MaterialStatePropertyAll(Size(50, 20)),
  shape: MaterialStatePropertyAll(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadiusSmall),
    ),
  ),
  textStyle: const MaterialStatePropertyAll(TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
  )),
);

ButtonStyle buttonStyleMedium = ButtonStyle(
  minimumSize: const MaterialStatePropertyAll(Size(120, 40)),
  shape: MaterialStatePropertyAll(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(7),
    ),
  ),
  textStyle: const MaterialStatePropertyAll(TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w500,
  )),
);

ButtonStyle buttonStyleBig = ButtonStyle(
  minimumSize: const MaterialStatePropertyAll(Size(250, 50)),
  shape: MaterialStatePropertyAll(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadiusMedium),
    ),
  ),
  textStyle: const MaterialStatePropertyAll(TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
  )),
);


/// Paddings/Distances
const double distanceTiny = 6;
const double distanceSmall = 10;
const double distanceMedium = 16;
const double distanceDefault = 20;
const double distanceBig = 40;
const double paddingTiny = 6;
const double paddingSmall = 10;
const double paddingMedium = distanceDefault;
const double paddingBig = 40;

const double paddingOffset = 10;

const double dropDownVerticalPadding = 12;

/// margin
const double marginSmall = 10;

/// Icon
const double iconSizeVeryTiny = 16;
const double iconSizeTiny = 24;
const double iconSizeSmall = 32;
const double iconSizeMedium = 48;
const double iconSizeBig = 64;
const double iconSizeVeryBig = 128;

/// Border Radius
const double borderRadiusTiny = 3;
const double borderRadiusSmall = 5;
const double borderRadiusMedium = 10;
const double borderRadiusBig = 15;
const double borderRadiusVeryBig = 20;

const defaultOutlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(
    Radius.circular(borderRadiusMedium),
  ),
);

/// Colors
const positiveColor = Color.fromARGB(255, 52, 199, 89);
const negativeColor = Color(0xFFD67268);
const primaryColor = Color(0xFF694BB4);
const warningColor = Color(0xFFC98D32);

const Color upcomingColor = Color(0xFF5D5FEF);
const Color inProgressColor = Color(0xFFC79345);
const Color doneColor = Color(0xFF7A977E);

const errorColor = Color.fromARGB(255, 255, 51, 51);
const onErrorColor = Color.fromARGB(255, 255, 255, 255);

/// Animation
const Duration zeroDuration = Duration.zero;
const Duration bottomSheetOpenDuration = Duration(milliseconds: 100);

/// Font size
const double fontSizeTiny = 11;
const double fontSizeSmall = 13;
const double fontSizeMedium = 15;
const double fontSizeBig = 22;

/// Column-Padding
const double columnPadding = paddingMedium;
const double columnPaddingBottomPercent = 0.07;
const double menuColumnPaddingTopPercent = 0.2;
const double menuColumnDistanceBetweenPercent = 0.05;

/// Elevation
const double defaultElevation = 4;

/// Common Themes
const searchBarTheme = SearchBarThemeData(
    constraints: BoxConstraints(maxHeight: 40, minHeight: 40),
    backgroundColor: MaterialStatePropertyAll(Color.fromARGB(255, 223, 223, 223)),
    elevation: MaterialStatePropertyAll(0),
    shadowColor: MaterialStatePropertyAll(Colors.transparent),
    textStyle: MaterialStatePropertyAll(TextStyle(color: Colors.black)));

const chipTheme = ChipThemeData(
  elevation: 2,
  pressElevation: 4,
);

/// TextStyles
TextStyle editableValueTextStyle(BuildContext context) =>
    TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 16, fontWeight: FontWeight.bold);
