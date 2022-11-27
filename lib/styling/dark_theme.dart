import 'package:flutter/material.dart';
import 'constants.dart';

ThemeData darkTheme = ThemeData(
  disabledColor: const Color.fromARGB(255, 100, 100, 100),
  primaryColor: const Color.fromARGB(255, 68, 68, 255),
  scaffoldBackgroundColor: const Color.fromARGB(255, 27, 27, 27),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Color.fromARGB(255, 27, 27, 27),
  ),
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    backgroundColor: Color.fromARGB(0, 0, 0, 0),
    shadowColor: Color.fromARGB(0, 0, 0, 0),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: buttonStyle.copyWith(
      backgroundColor: MaterialStateProperty.all<Color>(
          const Color.fromARGB(255, 255, 51, 51)),
      foregroundColor: MaterialStateProperty.all<Color>(
        const Color.fromARGB(255, 255, 255, 255),
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: buttonStyle.copyWith(
      backgroundColor: MaterialStateProperty.all<Color>(
          const Color.fromARGB(255, 27, 27, 27)),
      side: MaterialStateProperty.all<BorderSide>(
        buttonBorderSide.copyWith(
          color: const Color.fromARGB(255, 255, 255, 255),
        ),
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(
          const Color.fromARGB(255, 153, 153, 153)),
    ),
  ),
  iconTheme: const IconThemeData(
    size: iconSizeSmall,
    color: Color.fromARGB(255, 255, 255, 255),
  ),
  colorScheme: const ColorScheme(
    // General
    brightness: Brightness.dark,
    outline: Color.fromARGB(255, 255, 255, 255),
    shadow: Color.fromARGB(255, 60, 60, 60),
    //Basic Colors
    primary: Color.fromARGB(255, 255, 255, 255),
    inversePrimary: Color.fromARGB(255, 30, 30, 30),
    onPrimary: Color.fromARGB(255, 0, 0, 0),
    background: Color.fromARGB(255, 153, 153, 153),
    onBackground: Color.fromARGB(255, 255, 255, 255),
    secondary: Color.fromARGB(255, 238, 238, 238),
    onSecondary: Color.fromARGB(255, 0, 0, 0),
    tertiary: Color.fromARGB(255, 153, 153, 153),
    onTertiary: Color.fromARGB(255, 255, 255, 255),
    error: Color.fromARGB(255, 255, 51, 51),
    onError: Color.fromARGB(255, 255, 255, 255),
    // Surface
    surfaceTint: Color.fromARGB(0, 0, 0, 0),
    surface: Color.fromARGB(255, 85, 85, 85),
    onSurface: Color.fromARGB(255, 255, 255, 255),
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
    errorContainer: Color.fromARGB(255, 255, 51, 51),
    onErrorContainer: Color.fromARGB(255, 255, 255, 255),
  ),
);
