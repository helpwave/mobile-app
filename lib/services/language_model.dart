import 'package:flutter/material.dart';
import 'package:helpwave/config/language.dart';
import 'package:helpwave/services/language_preferences.dart';

/// Model for Language Localization
///
/// Notifies about changes to the Name and language short code the user prefers
class LanguageModel extends ChangeNotifier {
  /// language short code
  String _shortname = languages[defaultLanguageIndex]["Shortname"]!;

  /// Spoken Name of the Language
  String _name = languages[defaultLanguageIndex]["Name"]!;

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
