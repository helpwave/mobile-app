import 'package:flutter/material.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:impulse/screens/BoardingScreen.dart';
import 'package:impulse/theming/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'helpwave impulse',
      theme: ThemeData(
        primaryColor: primary,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        chipTheme: const ChipThemeData(
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(40),
            ),
          ),
        ),
        cardTheme: const CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(borderRadiusBig),
            ),
          ),
        ),
        useMaterial3: true,
      ),
      home: const OnBoardingScreen(),
    );
  }
}
