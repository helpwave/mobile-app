import 'package:flutter/material.dart';

/// A function to create a [MaterialStateProperty] by assigning each state a value
MaterialStateProperty<T> resolveByStates<T>({
  /// Used when no value is given for the other states
  required T defaultValue,
  T? disabled,
  T? error,
  T? selected,
  T? focused,
  T? pressed,
  T? dragged,
  T? hovered,
  T? scrolledUnder,
}) {
  return MaterialStateProperty.resolveWith((states) {
    if (states.contains(MaterialState.disabled)) {
      return disabled ?? defaultValue;
    }
    if (states.contains(MaterialState.error)) {
      return error ?? defaultValue;
    }
    if (states.contains(MaterialState.dragged)) {
      return dragged ?? defaultValue;
    }
    if (states.contains(MaterialState.hovered)) {
      return hovered ?? defaultValue;
    }
    if (states.contains(MaterialState.selected)) {
      return selected ?? defaultValue;
    }
    if (states.contains(MaterialState.focused)) {
      return focused ?? defaultValue;
    }
    if (states.contains(MaterialState.pressed)) {
      return pressed ?? defaultValue;
    }
    if (states.contains(MaterialState.scrolledUnder)) {
      return scrolledUnder ?? defaultValue;
    }

    return defaultValue;
  });
}
