import 'package:flutter/material.dart';
import 'package:helpwave_localization/l10n/app_localizations.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_localization/localization_model.dart';
import 'package:helpwave_theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:tasks/pages/task_edit_page.dart';


void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    ThemeMode themeMode = ThemeMode.system;

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

          if(themeNotifier.isDark != null){
            themeMode = themeNotifier.isDark! ? ThemeMode.dark : ThemeMode.light;
          }

          return MaterialApp(
            darkTheme: darkTheme,
            themeMode: themeMode,
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: getSupportedLocals(),
            locale: Locale(languageNotifier.language),
            home: const TaskEditPage(),
          );
        }
      )
    );

  }
}
