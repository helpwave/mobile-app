import 'package:shared_preferences/shared_preferences.dart';

/// Service for reading and writing the Language Preference
class LanguagePreferences {
  /// Key of the Shared Preference
  final String sharedPreferencesLanguageKey = "language";

  clear() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove(sharedPreferencesLanguageKey);
  }

  setLanguage(String locale) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(sharedPreferencesLanguageKey, locale);
  }

  getLanguage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(sharedPreferencesLanguageKey);
  }
}
