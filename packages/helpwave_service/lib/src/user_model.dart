import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:helpwave_service/src/user_preference.dart';
import 'package:impulse/dataclasses/user.dart';
import 'package:helpwave_proto_dart/proto/services/impulse_svc/v1/impulse_svc.pbenum.dart';


/// Model for saving user
///
/// Notifies about changes of the user on registration or update
class UserModel extends ChangeNotifier {
  /// Describes whether the [UserModel] has been initalized yet

  bool _isInitialized = false;
  User _user = User.empty();

  final UserPreferences _preferences = UserPreferences();

  User get user {
    return User(
      id: _user.id,
      height: _user.height,
      weight: _user.weight,
      pal: _user.pal,
      username: _user.username,
      gender: _user.gender,
      birthday: _user.birthday,
    );
  }

  bool get isInitialized => _isInitialized;

  UserModel() {
    getPreferences();
  }

  setUser({required User user}) {
    _user = user;
    _preferences.setUser(value: jsonEncode(user.toJson()));
    notifyListeners();
  }

  getPreferences() async {
    final userData = jsonDecode(await _preferences.getUser());
    User user = User(
      id: userData['id'],
      height: userData['height'],
      weight: userData['weight'],
      pal: userData['pal'],
      username: userData['username'],
      gender: Gender.values[userData['gender']],
      birthday: DateTime.parse(userData['birthday']),
    );

    _user = user;
    _isInitialized = true;
    notifyListeners();
  }
}