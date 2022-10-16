import 'package:flutter/material.dart';
import 'package:helpwave/services/language_preferences.dart';

class LanguageModel extends ChangeNotifier {
  String _shortname = "de";
  String _name = "Deutsch";

  final LanguagePreferences _preferences = LanguagePreferences();
  String get shortname => _shortname;
  String get name => _name;

  languageModel() {
    getPreferences();
  }

  setLanguage(String shortname, String name) {
    _shortname = shortname;
    _name = name;
    notifyListeners();
  }

  getPreferences() async {
    _shortname = await _preferences.getLanguage();
    notifyListeners();
  }
}
