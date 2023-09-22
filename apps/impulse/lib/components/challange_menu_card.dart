import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChallengeMenuCard extends StatelessWidget {
  const ChallengeMenuCard({super.key, required this.title, required this.subtitle, required this.text});

  final String title;
  final String subtitle;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Text(title, textAlign: TextAlign.center, style: TextStyle(color: Colors.purple),),
            Text(subtitle, textAlign: TextAlign.center),
            Text(text, textAlign: TextAlign.center,),
            Text("ChallengePicture"),
            Text("NextButton")
          ],
        ),
      ),
    );
  }
}
