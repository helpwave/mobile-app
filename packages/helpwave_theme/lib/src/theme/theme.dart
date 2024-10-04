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
  required Color shadow,
  required Color outline,
  required Color disabledColor,
  required Color onDisabledColor,
  required Color focusedColor,
  required Color defaultColor,

  // additional parameters
  required Brightness brightness,

  // flutter themes
  AppBarTheme appBarTheme = sharedAppBarTheme,

  // text
  required Color primaryTextColor,
}) {
  return ThemeData(
    useMaterial3: true,
    disabledColor: disabledColor,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: secondaryColor,
      selectionHandleColor: secondaryColor,
    ),
    scaffoldBackgroundColor: backgroundColor,
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: backgroundColor,
      modalBackgroundColor: backgroundColor,
      constraints: null,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(16),
      fillColor: surface,
      filled: true,
      focusColor: focusedColor,
      focusedBorder: defaultOutlineInputBorder.copyWith(borderSide: BorderSide.none),
      enabledBorder: defaultOutlineInputBorder.copyWith(borderSide: BorderSide.none),
      errorBorder: defaultOutlineInputBorder.copyWith(borderSide: BorderSide.none),
      focusedErrorBorder: defaultOutlineInputBorder.copyWith(borderSide: BorderSide.none),
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
      backgroundColor: surface,
    ),
    listTileTheme: ListTileThemeData(
      iconColor: primaryColor,
    ),
    appBarTheme: appBarTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: buttonStyleSmall.copyWith(
        backgroundColor: resolveByStates(
          defaultValue: primaryColor,
          disabled: disabledColor,
        ),
        foregroundColor: resolveByStates(
          defaultValue: onPrimaryColor,
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
      style: buttonStyleSmall,
    ),
    iconTheme: IconThemeData(
      size: iconSizeSmall,
      color: primaryTextColor,
    ),
    chipTheme: chipTheme.copyWith(
      selectedColor: primaryColor,
      secondaryLabelStyle: TextStyle(color: onPrimaryColor),
      // The TextStyle for selection
      labelStyle: TextStyle(color: primaryTextColor),
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
      textColor: primaryTextColor,
      iconColor: primaryTextColor,
    ),
    dividerTheme: DividerThemeData(color: primaryTextColor.withOpacity(0.4), space: 1, thickness: 1),
    hintColor: primaryTextColor.withOpacity(0.7),
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontWeight: FontWeight.bold, fontFamily: "SpaceGrotesk", fontSize: 22),
      titleMedium: TextStyle(fontWeight: FontWeight.w700, fontFamily: "SpaceGrotesk", fontSize: 18),
      titleSmall: TextStyle(fontWeight: FontWeight.w700, fontFamily: "SpaceGrotesk", fontSize: 16),
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
