import 'dart:io';
import 'package:flutter/material.dart';
import 'package:helpwave/config/language.dart';
import 'package:helpwave/services/language_preferences.dart';

/// Model for Language Localization
///
/// Notifies about changes to the Name and language short code the user prefers
class LanguageModel extends ChangeNotifier {
  /// Language short code e.g de, en
  String _language = languages[defaultLanguageIndex]["Language"]!;

  /// Spoken Name of the Language
  String _name = languages[defaultLanguageIndex]["Name"]!;

  final LanguagePreferences _preferences = LanguagePreferences();

  String get language => _language;

  String get name => _name;

  LanguageModel() {
    getPreferences();
  }

  clearLanguage() {
    _preferences.clear();
  }

  setLanguage(String local) {
    Map<String, String> languageMap =
        languages.firstWhere((element) => element["Local"]! == local);
    _language = languageMap["Language"]!;
    _name = languageMap["Name"]!;
    _preferences.setLanguage(local);
    notifyListeners();
  }

  getPreferences() async {
    String defaultLocale = Platform.localeName;
    String language = defaultLocale.split("_").first;
    Map<String, String> languageEntry = languages.firstWhere(
        (element) => element["Language"] == language,
        orElse: () => languages[defaultLanguageIndex]);
    String local = await _preferences.getLanguage() ?? languageEntry["Local"];

    Map<String, String> languageMap =
        languages.firstWhere((element) => element["Local"]! == local);
    _language = languageMap["Language"]!;
    _name = languageMap["Name"]!;
    notifyListeners();
  }
}
