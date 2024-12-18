import 'package:flutter/material.dart';
import 'package:helpwave_service/auth.dart';
import 'package:helpwave_service/property.dart';
import 'package:helpwave_service/user.dart';
import 'package:provider/provider.dart';
import 'package:helpwave_localization/l10n/app_localizations.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_localization/localization_model.dart';
import 'package:helpwave_theme/theme.dart';
import 'package:tasks/config/config.dart';
import 'package:helpwave_service/tasks.dart';
import 'package:tasks/screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  CurrentWardService().devMode = isUsingOfflineClients;
  TasksAPIServiceClients()
    ..apiUrl = usedAPIURL
    ..offlineMode = isUsingOfflineClients;
  UserAPIServiceClients()
    ..apiUrl = usedAPIURL
    ..offlineMode = isUsingOfflineClients;
  PropertyAPIServiceClients().apiUrl = usedAPIURL;
  // OfflineMode for PropertyAPIServiceClients does not work yet
  // ..offlineMode = isUsingOfflineClients;
  UserSessionService().changeMode(isUsingDevModeLogin);
  // TODO the line below enables direct login, but behaves somewhat weirdly
  UserSessionService().tokenLogin().then((value) => CurrentWardService().fakeLogin());
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
        ChangeNotifierProvider(
          create: (_) => CurrentWardController(devMode: isUsingDevModeLogin),
        ),
        ChangeNotifierProvider(
          create: (_) => UserSessionController(),
        ),
      ],
      child: Consumer2<ThemeModel, LanguageModel>(
          builder: (_, ThemeModel themeNotifier, LanguageModel languageNotifier, __) {
        return MaterialApp(
          title: 'helpwave tasks',
          themeMode: themeNotifier.themeMode,
          theme: lightTheme,
          darkTheme: darkTheme,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: getSupportedLocals(),
          locale: Locale(languageNotifier.language),
          home: const LoginScreen(),
        );
      }),
    );
  }
}
