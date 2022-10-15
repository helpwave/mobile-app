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

  set name(String name) {
    _name = name;
    _preferences.setLanguage(name);
    notifyListeners();
  }

  set shortname(String shortname) {
    _shortname = shortname;
    notifyListeners();
  }

  getPreferences() async {
    _shortname = await _preferences.getLanguage();
    notifyListeners();
  }
}
