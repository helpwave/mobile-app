import 'package:shared_preferences/shared_preferences.dart';

class LanguagePreferences {
  final String sharedPreferencesLanguageKey = "language";

  setLanguage(String locale) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(sharedPreferencesLanguageKey, locale);
  }

  getLanguage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(sharedPreferencesLanguageKey) ?? "de";
  }
}
