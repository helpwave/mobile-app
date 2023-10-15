import 'package:flutter/material.dart';
import 'package:helpwave_service/src/user_preference.dart';

/// Model for saving user
///
/// Notifies about changes of the user on registration or update
class UserModel extends ChangeNotifier {
  /// Describes whether the [UserModel] has been initalized yet
  bool _isInitialized = false;
  String _user = "";

  final UserPreferences _preferences = UserPreferences();

  String get user => _user;
  bool get isInitialized => _isInitialized;

  UserModel() {
    getPreferences();
  }

  setUser({String? user}) {
    _user = user!;
    _preferences.setUser(value: user);
    notifyListeners();
  }

  getPreferences() async {
    _user = await _preferences.getUser();
    _isInitialized = true;
    notifyListeners();
  }
}
