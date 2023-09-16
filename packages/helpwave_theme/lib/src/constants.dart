import 'package:flutter/material.dart';

/// Button attributes and
const double buttonWidth = 250;
const double buttonHeight = 50;
const BorderSide buttonBorderSide = BorderSide(width: 1);
const TextStyle buttonTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w500,
);
ButtonStyle buttonStyle = ButtonStyle(
  minimumSize:
      const MaterialStatePropertyAll<Size>(Size(buttonWidth, buttonHeight)),
  shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadiusMedium),
    ),
  ),
  textStyle: const MaterialStatePropertyAll<TextStyle>(buttonTextStyle),
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

const errorColor = Color.fromARGB(255, 255, 51, 51);

/// Animation
const Duration zeroDuration = Duration.zero;
const Duration bottomSheetOpenDuration = Duration(milliseconds: 100);

/// Font size
const double fontSizeTiny = 12;
const double fontSizeSmall = 14;
const double fontSizeMedium = 16;
const double fontSizeBig = 20;

/// Column-Padding
const double columnPadding = paddingMedium;
const double columnPaddingBottomPercent = 0.07;
const double menuColumnPaddingTopPercent = 0.2;
const double menuColumnDistanceBetweenPercent = 0.05;
