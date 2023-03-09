import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:helpwave_theme/theme.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_localization/localization_model.dart';
import 'package:helpwave_localization/l10n/app_localizations.dart';
import 'package:helpwave_service/introduction.dart';
import 'package:helpwave/services/database_handler.dart';
import 'package:helpwave/screens/home_screen.dart';
import 'package:helpwave/screens/landing_screen.dart';

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
          return MaterialApp(
            title: 'helpwave',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeNotifier.themeMode,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: getSupportedLocals(),
            home: introductionModel.hasSeenIntroduction ? const HomeScreen() : const LandingScreen(),
            locale: Locale(languageNotifier.language),
          );
        },
      ),
    );
  }
}
