import 'package:flutter/material.dart';

/// A function to create a [WidgetStateProperty] by assigning each state a value
WidgetStateProperty<T> resolveByStates<T>({
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
  return WidgetStateProperty.resolveWith((states) {
    if (states.contains(WidgetState.disabled)) {
      return disabled ?? defaultValue;
    }
    if (states.contains(WidgetState.error)) {
      return error ?? defaultValue;
    }
    if (states.contains(WidgetState.dragged)) {
      return dragged ?? defaultValue;
    }
    if (states.contains(WidgetState.hovered)) {
      return hovered ?? defaultValue;
    }
    if (states.contains(WidgetState.selected)) {
      return selected ?? defaultValue;
    }
    if (states.contains(WidgetState.focused)) {
      return focused ?? defaultValue;
    }
    if (states.contains(WidgetState.pressed)) {
      return pressed ?? defaultValue;
    }
    if (states.contains(WidgetState.scrolledUnder)) {
      return scrolledUnder ?? defaultValue;
    }

    return defaultValue;
  });
}
