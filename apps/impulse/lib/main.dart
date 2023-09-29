import 'package:flutter/material.dart';
import 'package:helpwave_service/introduction.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:impulse/components/background_gradient.dart';
import 'package:impulse/screens/boarding_screen.dart';
import 'package:impulse/screens/home_screen.dart';
import 'package:impulse/theming/colors.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'helpwave impulse',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
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
      home: ChangeNotifierProvider(
        create: (BuildContext context) => IntroductionModel(),
        child: Consumer<IntroductionModel>(
          builder: (BuildContext context, IntroductionModel value, Widget? child) {
            if (!value.isInitialized) {
              return const BackgroundGradient(
                child: Scaffold(),
              );
            }
            if (value.hasSeenIntroduction) {
              return const HomeScreen();
            }
            return const OnBoardingScreen();
          },
        ),
      ),
    );
  }
}
