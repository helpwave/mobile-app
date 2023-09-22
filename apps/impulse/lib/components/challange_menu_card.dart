import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
              color: titleColor,
              width: 215,
              height: 215,
              padding: EdgeInsets.all(4),
              child: ClipRRect(
                child: Container(
                  color: Colors.blue,
                ),
              ),
            ),
            Text("NextButton")
          ],
        ),
      ),
    );
  }
}
