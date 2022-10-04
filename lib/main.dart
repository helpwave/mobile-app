import 'package:flutter/material.dart';
import 'package:helpwave/pages/landing.dart';

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
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 17, 17, 51),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 68, 68, 255),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                const Color.fromARGB(255, 68, 68, 255)),
            padding:
                MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(18)),
            side: MaterialStateProperty.all<BorderSide>(const BorderSide(
              color: Color.fromARGB(255, 255, 255, 255),
              width: 2,
            )),
            fixedSize: MaterialStateProperty.all<Size>(const Size(250, 50)),
          ),
        ),
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: Color.fromARGB(255, 255, 255, 255),
          onPrimary: Color.fromARGB(255, 0, 0, 0),
          background: Color.fromARGB(255, 153, 153, 153),
          onBackground: Color.fromARGB(255, 255, 255, 255),
          secondary: Color.fromARGB(255, 68, 68, 255),
          onSecondary: Color.fromARGB(255, 255, 255, 255),
          tertiary: Color.fromARGB(255, 153, 153, 153),
          onTertiary: Color.fromARGB(255, 255, 255, 255),
          error: Color.fromARGB(255, 255, 51, 51),
          onError: Color.fromARGB(255, 255, 255, 255),
          surface: Color.fromARGB(255, 85, 85, 85),
          onSurface: Color.fromARGB(255, 255, 255, 255),
          primaryContainer: Color.fromARGB(255, 153, 153, 153),
          onPrimaryContainer: Color.fromARGB(255, 255, 255, 255),
          outline: Color.fromARGB(255, 255, 255, 255),
        ),
      ),
      home: const LandingPage(),
    );
  }
}
