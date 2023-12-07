import 'package:flutter/material.dart';
import 'constants.dart';

const primaryColor = Color.fromARGB(255, 0, 0, 0);
const onPrimaryColor = Color.fromARGB(255, 255, 255, 255);
const inversePrimaryColor = Color.fromARGB(255, 210, 210, 210);
const secondaryColor = Color.fromARGB(255, 105, 75, 180);
const onSecondaryColor = Color.fromARGB(255, 255, 255, 255);
const tertiary = Color.fromARGB(255, 180, 180, 180);
const onTertiary = Color.fromARGB(255, 0, 0, 0);

const backgroundColor = Color.fromARGB(255, 230, 230, 230);
const onBackgroundColor = Color.fromARGB(255, 0, 0, 0);

const surface = Color.fromARGB(255, 210, 210, 210);
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
const focusedColor = Color.fromARGB(255, 30, 30, 30);
const defaultColor = Color.fromARGB(255, 120, 120, 120);

/// Theme data for Light-Theme
ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  disabledColor: disabledColor,
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Colors.blue,
    selectionHandleColor: Colors.blueAccent,
  ),
  scaffoldBackgroundColor: backgroundColor,
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: backgroundColor,
    modalBackgroundColor: backgroundColor,
  ),
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: const TextStyle(color: Color.fromARGB(255, 100, 100, 100)),
    focusColor: focusedColor,
    focusedBorder: defaultOutlineInputBorder.copyWith(borderSide: const BorderSide(color: focusedColor)),
    enabledBorder: defaultOutlineInputBorder.copyWith(borderSide: const BorderSide(color: defaultColor)),
    errorBorder: defaultOutlineInputBorder.copyWith(borderSide: const BorderSide(color: errorColor)),
    focusedErrorBorder: defaultOutlineInputBorder.copyWith(borderSide: const BorderSide(color: errorColor)),
    iconColor: MaterialStateColor.resolveWith((states) {
      if (states.contains(MaterialState.focused)) {
        return focusedColor;
      } else {
        return defaultColor;
      }
    }),
    suffixIconColor: MaterialStateColor.resolveWith((states) {
      if (states.contains(MaterialState.focused)) {
        return focusedColor;
      } else {
        return defaultColor;
      }
    }),
    labelStyle: MaterialStateTextStyle.resolveWith((states) {
      if (states.contains(MaterialState.focused)) {
        return const TextStyle(color: focusedColor);
      } else {
        return const TextStyle(color: defaultColor);
      }
    }),
    floatingLabelStyle: MaterialStateTextStyle.resolveWith((states) {
      if (states.contains(MaterialState.focused)) {
        return const TextStyle(color: focusedColor);
      } else {
        return const TextStyle(color: defaultColor);
      }
    }),
  ),
  listTileTheme: const ListTileThemeData(
    iconColor: focusedColor,
  ),
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    foregroundColor: primaryColor,
    backgroundColor: Colors.transparent,
    shadowColor: Colors.transparent,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: buttonStyle.copyWith(
      backgroundColor: const MaterialStatePropertyAll(secondaryColor),
      foregroundColor: const MaterialStatePropertyAll(onSecondaryColor),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: buttonStyle.copyWith(
      backgroundColor: const MaterialStatePropertyAll(backgroundColor),
      side: MaterialStatePropertyAll(
        buttonBorderSide.copyWith(color: focusedColor),
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: buttonStyle.copyWith(
      backgroundColor: const MaterialStatePropertyAll(secondaryColor),
      foregroundColor: const MaterialStatePropertyAll(onSecondaryColor),
    ),
  ),
  iconTheme: const IconThemeData(
    size: iconSizeSmall,
    color: primaryColor,
  ),
  chipTheme: chipTheme.copyWith(
    selectedColor: secondaryColor,
    secondaryLabelStyle: const TextStyle(color: onSecondaryColor), // The TextStyle for selection
    labelStyle: const TextStyle(color: primaryColor),
  ),
  cardTheme: CardTheme(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadiusMedium),
    ),
  ),
  searchBarTheme: searchBarTheme,
  expansionTileTheme: const ExpansionTileThemeData(textColor: Colors.white, iconColor: Colors.white),
  colorScheme: const ColorScheme(
    // General
    brightness: Brightness.dark,
    outline: outline,
    shadow: shadow,
    //Basic Colors
    primary: primaryColor,
    inversePrimary: inversePrimaryColor,
    onPrimary: onPrimaryColor,
    background: backgroundColor,
    onBackground: onBackgroundColor,
    secondary: secondaryColor,
    onSecondary: onSecondaryColor,
    tertiary: tertiary,
    onTertiary: onTertiary,
    error: errorColor,
    onError: onErrorColor,
    // Surface
    surfaceTint: surfaceTint,
    surface: surface,
    onSurface: onSurface,
    surfaceVariant: surfaceVariant,
    onSurfaceVariant: onSurfaceVariant,
    inverseSurface: inverseSurface,
    onInverseSurface: onInverseSurface,
    // Container
    primaryContainer: primaryContainer,
    onPrimaryContainer: onPrimaryContainer,
    secondaryContainer: secondaryContainer,
    onSecondaryContainer: onSecondaryContainer,
    tertiaryContainer: tertiaryContainer,
    onTertiaryContainer: onTertiaryContainer,
    errorContainer: errorColor,
    onErrorContainer: onErrorColor,
  ),
);
