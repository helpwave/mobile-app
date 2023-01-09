import 'package:shared_preferences/shared_preferences.dart';

/// Service for reading and writing the Introduction Preference
class IntroductionPreferences {
  /// Key of the Shared Preference
  final String sharedPreferencesLanguageKey = "introduction";

  setIntroduction({bool value = true}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(sharedPreferencesLanguageKey, value);
  }

  Future<bool> getLanguage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(sharedPreferencesLanguageKey) ?? false;
  }
}
