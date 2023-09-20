import 'package:flutter/material.dart';
import 'constants.dart';

const focusedColor = Color.fromARGB(255, 30, 30, 30);
const defaultColor = Color.fromARGB(255, 120, 120, 120);
const backgroundColor = Color.fromARGB(255, 255, 255, 255);

/// Theme data for Light-Theme
ThemeData lightTheme = ThemeData(
  disabledColor: const Color.fromARGB(255, 100, 100, 100),
  scaffoldBackgroundColor: backgroundColor,
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Colors.blue,
    selectionHandleColor: Colors.blueAccent,
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: backgroundColor,
  ),
  inputDecorationTheme: InputDecorationTheme(
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
    backgroundColor: Color.fromARGB(0, 0, 0, 0),
    shadowColor: Color.fromARGB(0, 0, 0, 0),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: buttonStyle.copyWith(
      backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 255, 51, 51)),
      foregroundColor: MaterialStateProperty.all<Color>(
        const Color.fromARGB(255, 255, 255, 255),
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: buttonStyle.copyWith(
      foregroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 0, 0, 0)),
      backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 238, 238, 238)),
      side: MaterialStateProperty.all<BorderSide>(
        buttonBorderSide.copyWith(
          color: const Color.fromARGB(255, 0, 0, 0),
        ),
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 140, 140, 140)),
      foregroundColor: const MaterialStatePropertyAll(Color.fromARGB(255, 255, 255, 255)),
    ),
  ),
  iconTheme: const IconThemeData(
    size: iconSizeSmall,
    color: Color.fromARGB(255, 0, 0, 0),
  ),
  chipTheme: chipTheme,
  searchBarTheme: searchBarTheme,
  colorScheme: const ColorScheme(
    // General
    brightness: Brightness.light,
    outline: Color.fromARGB(255, 30, 30, 30),
    shadow: Color.fromARGB(255, 60, 60, 60),
    //Basic Colors
    primary: Color.fromARGB(255, 255, 255, 255),
    inversePrimary: Color.fromARGB(255, 30, 30, 30),
    onPrimary: Color.fromARGB(255, 0, 0, 0),
    background: Color.fromARGB(255, 153, 153, 153),
    onBackground: Color.fromARGB(255, 0, 0, 0),
    secondary: Color.fromARGB(255, 190, 190, 190),
    onSecondary: Color.fromARGB(255, 0, 0, 0),
    tertiary: Color.fromARGB(255, 153, 153, 153),
    onTertiary: Color.fromARGB(255, 255, 255, 255),
    error: errorColor,
    onError: Color.fromARGB(255, 255, 255, 255),
    // Surface
    surfaceTint: Color.fromARGB(0, 0, 0, 0),
    surface: Color.fromARGB(255, 100, 100, 100),
    onSurface: Color.fromARGB(255, 0, 0, 0),
    surfaceVariant: Color.fromARGB(255, 153, 153, 153),
    onSurfaceVariant: Color.fromARGB(255, 255, 255, 255),
    inverseSurface: Color.fromARGB(255, 153, 153, 153),
    onInverseSurface: Color.fromARGB(255, 0, 0, 0),
    // Container
    primaryContainer: Color.fromARGB(255, 255, 51, 51),
    onPrimaryContainer: Color.fromARGB(255, 255, 255, 255),
    secondaryContainer: Color.fromARGB(255, 85, 85, 85),
    onSecondaryContainer: Color.fromARGB(255, 255, 255, 255),
    tertiaryContainer: Color.fromARGB(255, 0, 0, 0),
    onTertiaryContainer: Color.fromARGB(255, 255, 255, 255),
    errorContainer: errorColor,
    onErrorContainer: Color.fromARGB(255, 255, 255, 255),
  ),
);
