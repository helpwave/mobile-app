import 'package:shared_preferences/shared_preferences.dart';

/// Service for reading and writing the Theme Preference
class ThemePreferences {
  /// Key of the Shared Preference
  final String sharedPreferencesThemeKey = "is_dark_theme";

  setTheme(bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(sharedPreferencesThemeKey, value);
  }

  getTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(sharedPreferencesThemeKey) ?? false;
  }
}
