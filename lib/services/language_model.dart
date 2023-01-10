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

  LanguageModel() {
    getPreferences();
  }

  setLanguage(String local) {
    Map<String, String> languageMap =
        languages.firstWhere((element) => element["Local"]! == local);
    _shortname = languageMap["Shortname"]!;
    _name = languageMap["Name"]!;
    _preferences.setLanguage(local);
    notifyListeners();
  }

  getPreferences() async {
    String local = await _preferences.getLanguage();
    Map<String, String> languageMap =
        languages.firstWhere((element) => element["Local"]! == local);
    _shortname = languageMap["Shortname"]!;
    _name = languageMap["Name"]!;
    notifyListeners();
  }
}
