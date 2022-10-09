import 'package:flutter/material.dart';
import 'package:helpwave/pages/landing.dart';
import 'package:helpwave/services/theme_model.dart';
import 'package:helpwave/styling/dark_theme.dart';
import 'package:helpwave/styling/light_theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeModel(),
      child: Consumer<ThemeModel>(
        builder: (_, ThemeModel themeNotifier, __) {
          return MaterialApp(
            title: 'helpwave',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeNotifier.isDark ? ThemeMode.dark : ThemeMode.light,
            home: const LandingPage(),
          );
        },
      ),
    );
  }
}
