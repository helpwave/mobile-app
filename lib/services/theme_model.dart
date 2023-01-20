import 'package:flutter/material.dart';
import 'package:helpwave/services/theme_preferences.dart';

/// Model for the Color Theme
///
/// Notifies about changes in light or dark theme preference
class ThemeModel extends ChangeNotifier {
  bool? _isDark;
  final ThemePreferences _preferences = ThemePreferences();

  bool? get isDark => _isDark;

  ThemeModel() {
    getPreferences();
  }

  set isDark(bool? value) {
    if (value == null) {
      _preferences.clearTheme();
    } else {
      _preferences.setTheme(value);
    }
    _isDark = value;
    notifyListeners();
  }

  getPreferences() async {
    _isDark = await _preferences.getTheme();
    notifyListeners();
  }
}
