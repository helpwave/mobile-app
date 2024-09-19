import 'package:flutter/material.dart';
import 'package:helpwave_theme/src/theme_preferences.dart';
import 'package:helpwave_theme/src/util/context_extension.dart';

/// Model for the Color Theme
///
/// Notifies about changes in light or dark theme preference
class ThemeModel extends ChangeNotifier {
  bool? _isDark;
  final ThemePreferences _preferences = ThemePreferences();

  ThemeModel() {
    getPreferences();
  }

  bool? get isDark => _isDark;

  set isDark(bool? value) {
    if (value == null) {
      _preferences.clearTheme();
    } else {
      _preferences.setTheme(value);
    }
    _isDark = value;
    notifyListeners();
  }

  bool get isUsingSystemTheme => isDark == null;

  /// Get the [ThemeMode] of based on the given preference
  ThemeMode get themeMode {
    ThemeMode themeMode = ThemeMode.system;
    if (!isUsingSystemTheme) {
      themeMode = isDark! ? ThemeMode.dark : ThemeMode.light;
    }
    return themeMode;
  }

  /// A NullSafe Variant of getting the current dark/light mode
  ///
  /// Uses the [BuildContext] to determine the [Theme]'s brightness, which
  /// corresponds to the System setting
  bool getIsDarkNullSafe(BuildContext context) =>
      isDark ?? context.theme.brightness == Brightness.dark;

  /// Load the preferences with the [ThemePreferences]
  getPreferences() async {
    _isDark = await _preferences.getTheme();
    notifyListeners();
  }
}
