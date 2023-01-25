import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:helpwave/services/database_handler.dart';
import 'package:helpwave/config/language.dart';
import 'package:helpwave/pages/home_page.dart';
import 'package:helpwave/services/introduction_model.dart';
import 'package:helpwave/pages/landing_page.dart';
import 'package:helpwave/services/language_model.dart';
import 'package:helpwave_theme/theme.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // initialize
  DatabaseHandler().initDatabase();
  runApp(const MyApp());
  FlutterNativeSplash.remove();
}

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
        ChangeNotifierProvider(
          create: (_) => IntroductionModel(),
        ),
      ],
      child: Consumer3<ThemeModel, LanguageModel, IntroductionModel>(
        builder:
            (_, ThemeModel themeNotifier, LanguageModel languageNotifier, IntroductionModel introductionModel, __) {
          ThemeMode themeMode = ThemeMode.system;
          if (themeNotifier.isDark != null) {
            themeMode = themeNotifier.isDark! ? ThemeMode.dark : ThemeMode.light;
          }
          return MaterialApp(
            title: 'helpwave',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeMode,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: languages.map((language) => Locale(language["Language"]!, language["Local"]!)).toList(),
            home: introductionModel.hasSeenIntroduction ? const HomePage() : const LandingPage(),
            locale: Locale(languageNotifier.language),
          );
        },
      ),
    );
  }
}
