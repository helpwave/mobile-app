import 'package:shared_preferences/shared_preferences.dart';

/// Service for reading and writing the Introduction Preference
class IntroductionPreferences {
  /// Key of the Shared Preference
  final String sharedPreferencesIntroductionKey = "introduction";

  setIntroduction({bool value = true}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(sharedPreferencesIntroductionKey, value);
  }

  Future<bool> getIntroductionValue() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(sharedPreferencesIntroductionKey) ?? false;
  }
}
