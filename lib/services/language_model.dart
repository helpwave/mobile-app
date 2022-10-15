import 'package:flutter/material.dart';
import 'package:helpwave/services/language_preferences.dart';

class LanguageModel extends ChangeNotifier {
  String _language = "de";

  final LanguagePreferences _preferences = LanguagePreferences();
  String get language => _language;

  languageModel() {
    getPreferences();
  }

  set language(String locale) {
    _language = locale;
    _preferences.setLanguage(locale);
    notifyListeners();
  }

  getPreferences() async {
    _language = await _preferences.getLanguage();
    notifyListeners();
  }
}
