import 'package:flutter/material.dart';
import 'package:helpwave/pages/landing.dart';
import 'package:helpwave/styling/dark_theme.dart';
import 'package:helpwave/styling/light_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'helpwave',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,// TODO make switchable or use ThemeMode.system
      home: const LandingPage(),
    );
  }
}
