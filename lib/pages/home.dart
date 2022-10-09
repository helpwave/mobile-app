import 'package:flutter/material.dart';
import 'package:helpwave/pages/street_map_view.dart';
import 'package:helpwave/pages/questionnaire.dart';
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
        centerTitle: true,
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
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const QuestionnairePage(),
                        ),
                      );
                    },
                    child: const Text("Fragebogen"),
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
                    child: const Text("Notaufnahmekarte"),
                  ),
                ],
              ),
            ),
            Center(
              child: OutlinedButton(
                onPressed: () {
                  // TODO Add Settings Route
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => SomePage(),))
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).colorScheme.background)),
                child: const Text("Einstellungen"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
