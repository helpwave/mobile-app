import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:helpwave/pages/landing.dart';
import 'package:helpwave/services/language_model.dart';
import 'package:helpwave/services/theme_model.dart';
import 'package:helpwave/styling/dark_theme.dart';
import 'package:helpwave/styling/light_theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

List<Map<String, String>> languages = [
  {"Name": "English", "Local": "US", "Shortname": "en"},
  {"Name": "Deutsch", "Local": "DE", "Shortname": "de"}
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => LanguageModel(),
        ),
      ],
      child: Consumer2<ThemeModel, LanguageModel>(
        builder:
            (_, ThemeModel themeNotifier, LanguageModel languageNotifier, __) {
          return MaterialApp(
            title: 'helpwave',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeNotifier.isDark ? ThemeMode.dark : ThemeMode.light,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: languages
                .map((language) =>
                    Locale(language["Shortname"]!, language["Local"]!))
                .toList(),
            home: const LandingPage(),
            locale: Locale(languageNotifier.shortname),
          );
        },
      ),
    );
  }
}
