import 'dart:io';
import 'package:flutter/material.dart';
import 'package:helpwave_localization/src/config/language.dart';
import 'package:helpwave_localization/src/language_preferences.dart';
import 'package:helpwave_localization/src/language_with_translation.dart';

/// Model for Language Localization
///
/// Notifies about changes to the Name and language short code the user prefers
class LanguageModel extends ChangeNotifier {
  /// The currently selected [LocalWithName]
  LocalWithName _localWithName = getSupportedLocalsWithName()[defaultLanguageIndex];

  final LanguagePreferences _preferences = LanguagePreferences();

  String get language => _localWithName.language;

  String get name => _localWithName.name;

  String get local => _localWithName.local;

  LanguageModel() {
    getPreferences();
  }

  clearLanguage() {
    _preferences.clear();
  }

  setLanguage(String local) {
    _localWithName = languages.firstWhere((element) => element.local == local);
    _preferences.setLanguage(local);
    notifyListeners();
  }

  getPreferences() async {
    String defaultLocale = Platform.localeName;
    String language = defaultLocale.split("_").first;
    LocalWithName languageEntry =
        languages.firstWhere((element) => element.language == language, orElse: () => languages[defaultLanguageIndex]);
    String local = await _preferences.getLanguage() ?? languageEntry.local;

    _localWithName = languages.firstWhere((element) => element.local == local);
    notifyListeners();
  }
}
