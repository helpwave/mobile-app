import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:helpwave/pages/questionnaire.dart';
import 'package:helpwave/pages/setting.dart';
import 'package:helpwave/pages/street_map_view.dart';
import 'package:helpwave/styling/constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    const double columnPadding = paddingMedium;
    const double columnPaddingBottom = 0.07;
    const double menuColumnPaddingTop = 0.2;
    const double menuColumnDistanceBetween = 0.05;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "helpwave",
          textAlign: TextAlign.center,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(columnPadding)
            .copyWith(bottom: mediaQuery.height * columnPaddingBottom),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: mediaQuery.height * menuColumnPaddingTop),
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
                    height: mediaQuery.height * menuColumnDistanceBetween,
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const StreetMapViewPage(),
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
