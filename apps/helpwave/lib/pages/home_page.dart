import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave/pages/questionnaire_page.dart';
import 'package:helpwave/pages/settings_page.dart';
import 'package:helpwave/pages/street_map_page.dart';

/// The Homepage of the App with Navigation
class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                          builder: (_) => const QuestionnairePage(),
                        ),
                      );
                    },
                    child: Text(AppLocalizations.of(context)!.questionnaire),
                  ),
                  SizedBox(
                    height: mediaQuery.height * menuColumnDistanceBetweenPercent,
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const StreetMapPage(),
                        ),
                      );
                    },
                    child: Text(AppLocalizations.of(context)!.emergencyMap),
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
                      builder: (_) => const SettingsPage(),
                    ),
                  );
                },
                child: Text(AppLocalizations.of(context)!.settings),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
