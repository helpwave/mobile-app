import 'package:flutter/material.dart';

// Buttons
const double buttonWidth = 250;
const double buttonHeight = 50;
const BorderSide buttonBorderSide = BorderSide(width: 2);
ButtonStyle buttonStyle = ButtonStyle(
  fixedSize:
      MaterialStateProperty.all<Size>(const Size(buttonWidth, buttonHeight)),
);

// Paddings/Distances
const double distanceDefault = 20;
const double paddingSmall = 10;
const double paddingMedium = distanceDefault;
const double paddingBig = 40;

// Icon
const double iconSizeSmall = 32;
const double iconSizeMedium = 48;
const double iconSizeBig = 64;
const double iconSizeVeryBig = 128;

// Border Radius
const double borderRadiusSmall = 5;
const double borderRadiusMedium = 10;
const double borderRadiusBig = 20;


