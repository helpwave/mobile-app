import 'package:flutter/material.dart';
import 'package:helpwave_theme/src/theme/theme.dart';
import '../constants.dart';

const primaryColor = Color.fromARGB(255, 255, 255, 255);
const onPrimaryColor = Color.fromARGB(255, 0, 0, 0);
const inversePrimaryColor = Color.fromARGB(255, 30, 30, 30);
const secondaryColor = Color.fromARGB(255, 150, 129, 205);
const onSecondaryColor = Color.fromARGB(255, 255, 255, 255);
const tertiary = Color.fromARGB(255, 180, 180, 180);
const onTertiary = Color.fromARGB(255, 0, 0, 0);

const backgroundColor = Color.fromARGB(255, 27, 27, 27);
const onBackgroundColor = Color.fromARGB(255, 255, 255, 255);

const surface = Color.fromARGB(255, 50, 50, 50);
const onSurface = Color.fromARGB(255, 255, 255, 255);
const surfaceVariant = Color.fromARGB(255, 80, 80, 80);
const onSurfaceVariant = Color.fromARGB(255, 255, 255, 255);
const inverseSurface = Color.fromARGB(255, 180, 180, 180);
const onInverseSurface = Color.fromARGB(255, 0, 0, 0);

const primaryContainer = Color.fromARGB(255, 180, 180, 180);
const onPrimaryContainer = Color.fromARGB(255, 0, 0, 0);
const secondaryContainer = Color.fromARGB(255, 140, 140, 140);
const onSecondaryContainer = Color.fromARGB(255, 0, 0, 0);
const tertiaryContainer = Color.fromARGB(255, 80, 80, 80);
const onTertiaryContainer = Color.fromARGB(255, 255, 255, 255);

const surfaceTint = Colors.transparent;
const shadow = Color.fromARGB(255, 60, 60, 60);
const outline = Color.fromARGB(255, 255, 255, 255);
const disabledColor = Color.fromARGB(255, 100, 100, 100);
const onDisabledColor = Color.fromARGB(255, 255, 255, 255);
const focusedColor = Color.fromARGB(255, 255, 255, 255);
const defaultColor = Color.fromARGB(255, 150, 150, 150);

/// Theme data for Dark-Theme
ThemeData darkTheme = makeTheme(
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
);
