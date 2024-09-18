import 'package:flutter/material.dart';
import 'package:helpwave_util/material_state.dart';
import '../../constants.dart';

// A function to map incoming colors to a theme
ThemeData makeTheme({
  // main colors
  required Color primaryColor,
  required Color onPrimaryColor,
  required Color inversePrimaryColor,
  required Color secondaryColor,
  required Color onSecondaryColor,
  required Color tertiary,
  required Color onTertiary,
  required Color errorColor,
  required Color onErrorColor,

  // background
  required Color backgroundColor,
  required Color onBackgroundColor,

  // surfaces
  required Color surface,
  required Color onSurface,
  required Color surfaceVariant,
  required Color onSurfaceVariant,
  required Color inverseSurface,
  required Color onInverseSurface,

  // container
  required Color primaryContainer,
  required Color onPrimaryContainer,
  required Color secondaryContainer,
  required Color onSecondaryContainer,
  required Color tertiaryContainer,
  required Color onTertiaryContainer,
  required Color errorContainer,
  required Color onErrorContainer,

  // other
  required Color surfaceTint,
  required Color shadow,
  required Color outline,
  required Color disabledColor,
  required Color onDisabledColor,
  required Color focusedColor,
  required Color defaultColor,

  // additional parameters
  required Brightness brightness,

  // Flutter Themes
  AppBarTheme appBarTheme = sharedAppBarTheme,
}) {
  return ThemeData(
    useMaterial3: true,
    disabledColor: disabledColor,
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.blue,
      selectionHandleColor: Colors.blueAccent,
    ),
    scaffoldBackgroundColor: backgroundColor,
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: backgroundColor,
      modalBackgroundColor: backgroundColor,
      constraints: null,
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: const TextStyle(color: Color.fromARGB(255, 100, 100, 100)),
      focusColor: focusedColor,
      focusedBorder: defaultOutlineInputBorder.copyWith(borderSide: BorderSide(color: focusedColor)),
      enabledBorder: defaultOutlineInputBorder.copyWith(borderSide: BorderSide(color: defaultColor)),
      errorBorder: defaultOutlineInputBorder.copyWith(borderSide: BorderSide(color: errorColor)),
      focusedErrorBorder: defaultOutlineInputBorder.copyWith(borderSide: BorderSide(color: errorColor)),
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
          return TextStyle(color: focusedColor);
        } else {
          return TextStyle(color: defaultColor);
        }
      }),
      floatingLabelStyle: MaterialStateTextStyle.resolveWith((states) {
        if (states.contains(MaterialState.focused)) {
          return TextStyle(color: focusedColor);
        } else {
          return TextStyle(color: defaultColor);
        }
      }),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: backgroundColor,
    ),
    listTileTheme: ListTileThemeData(
      iconColor: focusedColor,
    ),
    appBarTheme: appBarTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: buttonStyleSmall.copyWith(
        backgroundColor: resolveByStates(
          defaultValue: secondaryColor,
          disabled: disabledColor,
        ),
        foregroundColor: resolveByStates(
          defaultValue: onSecondaryColor,
          disabled: onDisabledColor,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: buttonStyleSmall.copyWith(
        backgroundColor: resolveByStates(
          defaultValue: Colors.transparent,
          disabled: disabledColor,
        ),
        foregroundColor: resolveByStates(
          defaultValue: focusedColor,
          disabled: onDisabledColor,
        ),
        side: resolveByStates(
          defaultValue: BorderSide(color: focusedColor),
          disabled: BorderSide(color: onDisabledColor),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: buttonStyleSmall.copyWith(
        backgroundColor: resolveByStates(
          defaultValue: secondaryColor,
          disabled: disabledColor,
        ),
        foregroundColor: resolveByStates(
          defaultValue: onSecondaryColor,
          disabled: onDisabledColor,
        ),
      ),
    ),
    iconTheme: IconThemeData(
      size: iconSizeSmall,
      color: primaryColor,
    ),
    chipTheme: chipTheme.copyWith(
      selectedColor: secondaryColor,
      secondaryLabelStyle: TextStyle(color: onSecondaryColor),
      // The TextStyle for selection
      labelStyle: TextStyle(color: primaryColor),
    ),
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadiusMedium),
      ),
    ),
    // in light mode the highlight color for the initial value is barely visible
    popupMenuTheme: PopupMenuThemeData(
      color: surface,
      textStyle: TextStyle(color: onSurface),
      labelTextStyle: MaterialStatePropertyAll(TextStyle(color: onSurface)),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(borderRadiusMedium))),
    ),
    searchBarTheme: searchBarTheme,
    expansionTileTheme: ExpansionTileThemeData(
      textColor: primaryColor,
      iconColor: primaryColor,
    ),
    colorScheme: ColorScheme(
      // General
      brightness: brightness,
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
      errorContainer: errorContainer,
      onErrorContainer: onErrorContainer,
    ),
  );
}
