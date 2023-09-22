import 'package:flutter/material.dart';
import 'package:helpwave_theme/constants.dart';

class ChallengeMenuCard extends StatelessWidget {
  const ChallengeMenuCard(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.text});

  final String title;
  final String subtitle;
  final String text;

  static const titleColor = Color(0xff6A5AE0);

  @override
  Widget build(BuildContext context) {
    const double width = 215;

    return Card(
      surfaceTintColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: titleColor, fontWeight: FontWeight.w700, fontSize: 30),
            ),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: titleColor, fontWeight: FontWeight.w700, fontSize: 22),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
              ),
            ),
            Container(
              width: width,
              height: width,
              decoration: const BoxDecoration(
                color: titleColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(borderRadiusVeryBig),
                ),
              ),
              padding: const EdgeInsets.all(paddingSmall),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(borderRadiusVeryBig - paddingSmall),
                ),
                child: Container(
                  color: Colors.blue,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(paddingMedium),
              child: ElevatedButton(
                onPressed: () {},
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(titleColor),
                  fixedSize: MaterialStatePropertyAll(
                    Size.fromWidth(width),
                  ),
                ),
                child: const Text(
                  "Nächster Schritt",
                  style:
                      TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
