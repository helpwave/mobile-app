import 'package:flutter/material.dart';
import 'package:helpwave_service/src/introduction_preference.dart';

/// Model for Introduction Settings
///
/// Notifies about changes to the introduction level the user had
class IntroductionModel extends ChangeNotifier {
  /// Flag whether the user has seen the Introduction page or not
  bool _hasSeenIntroduction = false;
  bool _isInitialized = false;

  final IntroductionPreferences _preferences = IntroductionPreferences();

  bool get hasSeenIntroduction => _hasSeenIntroduction;

  bool get isInitialized => _isInitialized;

  IntroductionModel() {
    getPreferences();
  }

  setHasSeenIntroduction({bool hasSeenIntroduction = true}) {
    _hasSeenIntroduction = hasSeenIntroduction;
    _preferences.setIntroduction(value: hasSeenIntroduction);
    notifyListeners();
  }

  getPreferences() async {
    _hasSeenIntroduction = await _preferences.getIntroductionValue();
    _isInitialized = true;
    notifyListeners();
  }
}
