import 'dart:ui';

/// Language configuration
const List<Map<String, String>> languages = [
  {"Name": "English", "Local": "US", "Language": "en"},
  {"Name": "Deutsch", "Local": "DE", "Language": "de"}
];
const defaultLanguageIndex = 1;

/// List of Supported Locals that this package supports
List<Locale> getSupportedLocals() =>
    languages.map((language) => Locale(language["Language"]!, language["Local"]!)).toList();

/// List of Supported Locals as a Map with additional information
List<Map<String, String>> getSupportedLocalsMap() => languages;
