import 'package:shared_preferences/shared_preferences.dart';

/// Service for reading and writing the current user
class UserPreferences {
  /// Key of the Shared Preference
  final String sharedPreferencesIntroductionKey = "user";

  setUser({String? value}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("user", value!);
  }

  Future<String> getUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString("user") ?? "";
  }
}
