import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:helpwave_localization/l10n/app_localizations.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_localization/localization_model.dart';
import 'package:helpwave_theme/theme.dart';
import 'package:tasks/screens/landing_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      child: Consumer2<ThemeModel, LanguageModel>(builder:
          (_, ThemeModel themeNotifier, LanguageModel languageNotifier, __) {
        return MaterialApp(
          title: 'helpwave tasks',
          themeMode: themeNotifier.themeMode,
          theme: lightTheme,
          darkTheme: darkTheme,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: getSupportedLocals(),
          locale: Locale(languageNotifier.language),
          home: const LandingScreen(),
        );
      }),
    );
  }
}
