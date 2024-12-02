import 'package:flutter/material.dart';
import 'package:helpwave_theme/src/theme/theme.dart';
import '../constants.dart';

const primaryColor = Color.fromARGB(255, 105, 75, 180);
const onPrimaryColor = Colors.white;
const inversePrimaryColor = Color.fromARGB(255, 150, 130, 200);
const secondaryColor = Color.fromARGB(255, 75, 160, 240);
const onSecondaryColor = Colors.white;
const tertiary = Color.fromARGB(255, 90, 90, 90);
const onTertiary = Colors.white;

const backgroundColor = Color.fromARGB(255, 237, 237, 237);
const onBackgroundColor = Colors.black;

const surface = Color.fromARGB(255, 255, 255, 255);
const onSurface = Colors.black;
const surfaceVariant = Color.fromARGB(255, 170, 170, 170);
const onSurfaceVariant = Colors.black;
const inverseSurface = Color.fromARGB(255, 90, 90, 90);
const onInverseSurface = Colors.white;

const primaryContainer = Color.fromARGB(255, 105, 75, 180);
const onPrimaryContainer = Colors.white;
const secondaryContainer =  Color.fromARGB(255, 75, 160, 240);
const onSecondaryContainer = Colors.white;
const tertiaryContainer = Color.fromARGB(255, 255, 255, 255);
const onTertiaryContainer = Color.fromARGB(255, 0, 0, 0);

const shadow = Color.fromARGB(255, 60, 60, 60);
const outline = Color.fromARGB(255, 30, 30, 30);
const disabledColor = Color.fromARGB(255, 100, 100, 100);
const onDisabledColor = Color.fromARGB(255, 255, 255, 255);
const focusedColor = Color.fromARGB(255, 30, 30, 30);
const defaultColor = Color.fromARGB(255, 120, 120, 120);

/// Theme data for Light-Theme
ThemeData lightTheme = makeTheme(
  // main colors
  primaryColor: primaryColor,
  onPrimaryColor: onPrimaryColor,
  inversePrimaryColor: inversePrimaryColor,
  secondaryColor: secondaryColor,
  onSecondaryColor: onSecondaryColor,
  tertiary: tertiary,
  onTertiary: onTertiary,
  errorColor: errorColor,
  onErrorColor: onErrorColor,

  // background color
  backgroundColor: backgroundColor,
  onBackgroundColor: onBackgroundColor,

  // surface
  surface: surface,
  onSurface: onSurface,
  surfaceVariant: surfaceVariant,
  onSurfaceVariant: onSurfaceVariant,
  inverseSurface: inverseSurface,
  onInverseSurface: onInverseSurface,

  // container
  primaryContainer: primaryContainer,
  onPrimaryContainer: onPrimaryContainer,
  secondaryContainer: secondaryContainer,
  onSecondaryContainer: onSecondaryContainer,
  tertiaryContainer: tertiaryContainer,
  onTertiaryContainer: onTertiaryContainer,
  errorContainer: errorColor,
  onErrorContainer: onErrorColor,

  // other
  shadow: shadow,
  outline: outline,
  disabledColor: disabledColor,
  onDisabledColor: onDisabledColor,
  focusedColor: focusedColor,
  defaultColor: defaultColor,

  // additional
  brightness: Brightness.light,

  // flutter themes
  appBarTheme: sharedAppBarTheme.copyWith(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
  ),

  // text
  primaryTextColor: Colors.black,
);
