import 'package:flutter/material.dart';
import 'package:helpwave_theme/src/theme/theme.dart';
import '../constants.dart';

const primaryColor = Color.fromARGB(255, 0, 0, 0);
const onPrimaryColor = Color.fromARGB(255, 255, 255, 255);
const inversePrimaryColor = Color.fromARGB(255, 210, 210, 210);
const secondaryColor = Color.fromARGB(255, 105, 75, 180);
const onSecondaryColor = Color.fromARGB(255, 255, 255, 255);
const tertiary = Color.fromARGB(255, 180, 180, 180);
const onTertiary = Color.fromARGB(255, 0, 0, 0);

const backgroundColor = Color.fromARGB(255, 242, 242, 242);
const onBackgroundColor = Color.fromARGB(255, 0, 0, 0);

const surface = Color.fromARGB(255, 220, 220, 220);
const onSurface = Color.fromARGB(255, 0, 0, 0);
const surfaceVariant = Color.fromARGB(255, 170, 170, 170);
const onSurfaceVariant = Color.fromARGB(255, 0, 0, 0);
const inverseSurface = Color.fromARGB(255, 120, 120, 120);
const onInverseSurface = Color.fromARGB(255, 255, 255, 255);

const primaryContainer = Color.fromARGB(255, 200, 200, 200);
const onPrimaryContainer = Color.fromARGB(255, 0, 0, 0);
const secondaryContainer = Color.fromARGB(255, 160, 160, 160);
const onSecondaryContainer = Color.fromARGB(255, 0, 0, 0);
const tertiaryContainer = Color.fromARGB(255, 120, 120, 120);
const onTertiaryContainer = Color.fromARGB(255, 255, 255, 255);

const surfaceTint = Colors.transparent;
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
  surfaceTint: surfaceTint,
  shadow: shadow,
  outline: outline,
  disabledColor: disabledColor,
  onDisabledColor: onDisabledColor,
  focusedColor: focusedColor,
  defaultColor: defaultColor,

  // additional
  brightness: Brightness.dark,

  // flutter themes
  appBarTheme: sharedAppBarTheme.copyWith(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
  )
);
