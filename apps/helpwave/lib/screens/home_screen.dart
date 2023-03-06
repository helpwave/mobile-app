import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave/screens/questionnaire_screen.dart';
import 'package:helpwave/screens/settings_screen.dart';
import 'package:helpwave/screens/street_map_screen.dart';

/// The Home Screen of the App with Navigation
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "helpwave",
          textAlign: TextAlign.center,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(columnPadding).copyWith(bottom: mediaQuery.height * columnPaddingBottomPercent),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: mediaQuery.height * menuColumnPaddingTopPercent),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const QuestionnaireScreen(),
                        ),
                      );
                    },
                    child: Text(context.localization!.questionnaire),
                  ),
                  SizedBox(
                    height: mediaQuery.height * menuColumnDistanceBetweenPercent,
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const StreetMapScreen(),
                        ),
                      );
                    },
                    child: Text(context.localization!.emergencyMap),
                  ),
                ],
              ),
            ),
            Center(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SettingsScreen(),
                    ),
                  );
                },
                child: Text(context.localization!.settings),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
