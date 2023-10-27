import 'dart:ui';
import 'package:helpwave_localization/src/language_with_translation.dart';

/// Language configuration
const List<LocalWithName> languages = [
  LocalWithName(name: "English", local: "US", language: "en"),
  LocalWithName(name: "Deutsch", local: "DE", language: "de"),
];
const defaultLanguageIndex = 1;

/// List of Supported Locals that this package supports
List<Locale> getSupportedLocals() =>
    languages.map((language) => Locale(language.language, language.local)).toList();

/// List of Supported Locals as a Map with additional information
List<LocalWithName> getSupportedLocalsWithName() => languages;
