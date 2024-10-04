import 'package:flutter/material.dart';
import 'package:helpwave_theme/src/util/context_extension.dart';
import 'package:helpwave_util/material_state.dart';

/// Resolves the background [Color] based on the [MaterialState] and the [ThemeData]
MaterialStateProperty<Color> resolveByStatesAndContextBackground({
  required BuildContext context,
  Color? defaultValue,
  Color? disabled,
  Color? error,
  Color? selected,
  Color? focused,
  Color? pressed,
  Color? dragged,
  Color? hovered,
  Color? scrolledUnder,
}) {
  ThemeData theme = context.theme;
  ColorScheme colorScheme = theme.colorScheme;
  return resolveByStates<Color>(
    defaultValue: defaultValue ?? colorScheme.primary,
    disabled: disabled ?? theme.disabledColor,
    error: error ?? colorScheme.error,
    selected: selected ?? colorScheme.primary,
    focused: focused ?? colorScheme.primary,
    pressed: pressed ?? colorScheme.primary,
    dragged: dragged ?? colorScheme.primary,
    hovered: hovered ?? colorScheme.primary,
    scrolledUnder: scrolledUnder ?? colorScheme.primary,
  );
}

/// Resolves the foreground [Color] based on the [MaterialState] and the [ThemeData]
MaterialStateProperty<Color> resolveByStatesAndContextForeground({
  required BuildContext context,
  Color? defaultValue,
  Color? disabled,
  Color? error,
  Color? selected,
  Color? focused,
  Color? pressed,
  Color? dragged,
  Color? hovered,
  Color? scrolledUnder,
}) {
  ThemeData theme = context.theme;
  ColorScheme colorScheme = theme.colorScheme;
  return resolveByStates<Color>(
    defaultValue: defaultValue ?? colorScheme.onPrimary,
    disabled: disabled ?? colorScheme.onPrimary, // TODO replace with onDisabled once it exists
    error: error ?? colorScheme.onError,
    selected: selected ?? colorScheme.onPrimary,
    focused: focused ?? colorScheme.onPrimary,
    pressed: pressed ?? colorScheme.onPrimary,
    dragged: dragged ?? colorScheme.onPrimary,
    hovered: hovered ?? colorScheme.onPrimary,
    scrolledUnder: scrolledUnder ?? colorScheme.onPrimary,
  );
}
