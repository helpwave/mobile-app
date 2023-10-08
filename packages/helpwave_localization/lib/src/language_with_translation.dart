/// A data class for storing Localization information like the language, local code, and its native name
class LocalWithName {
  final String name;
  final String local;
  final String language;

  const LocalWithName({required this.name, required this.language, required this.local});
}
