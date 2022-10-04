import 'package:flutter/material.dart';
import 'package:helpwave/pages/street_map_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "helpwave",
          textAlign: TextAlign.center,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, mediaQuery.height * 0.07),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, mediaQuery.height * 0.2, 0,
                        mediaQuery.height * 0.05),
                    child: OutlinedButton(
                      onPressed: () {
                        // TODO Add QuestionPage Route
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => SomePage(),))
                      },
                      child: const Text("Fragebogen"),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const StreetMapViewPage(),));
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
