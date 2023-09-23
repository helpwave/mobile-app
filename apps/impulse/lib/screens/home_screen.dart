import 'package:flutter/material.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:impulse/components/activity_card.dart';
import 'package:impulse/components/medal_carusel.dart';
import 'package:impulse/components/progressbar.dart';
import 'package:impulse/components/xp_label.dart';
import 'package:impulse/dataclasses/challange.dart';
import 'package:impulse/screens/challange_screen.dart';
import 'package:impulse/theming/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Challenge> challenges = [
    Challenge(
      id: "id1",
      category: ChallengeCategory.fitness,
      title: "Step by Step",
      description: "Gehe so viele Schritte wie möglich in 30 Minuten.",
      endAt: DateTime.now(),
      startAt: DateTime.now(),
      points: 300,
      threshold: 20,
      type: ChallengeType.timer,
      verifiers: [
        Verifier(methode: VerificationMethodType.qr, qrCode: "code"),
      ],
    ),
    Challenge(
      id: "id2",
      category: ChallengeCategory.fitness,
      title: "Dauerläufer",
      description: "Gehe so viele Schritte wie möglich in 30 Minuten.",
      endAt: DateTime.now(),
      startAt: DateTime.now(),
      points: 300,
      threshold: 20,
      type: ChallengeType.timer,
      verifiers: [
        Verifier(methode: VerificationMethodType.timer, duration: const Duration(seconds: 20)),
      ],
    ),
    Challenge(
      id: "id3",
      category: ChallengeCategory.fitness,
      title: "Korbleger",
      description:
          "Spiele so viele Körbe wie möglich in 20 Min. auf dem Basketballplatz im Stadtpark.",
      endAt: DateTime.now(),
      startAt: DateTime.now(),
      points: 300,
      threshold: 20,
      type: ChallengeType.timer,
      verifiers: [
        Verifier(methode: VerificationMethodType.number, min: 0, max: 20, isFinishable: true),
        Verifier(methode: VerificationMethodType.number, min: 0, max: 20, isFinishable: true),
        Verifier(methode: VerificationMethodType.number, min: 0, max: 20, isFinishable: true),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFA49AEC), primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 1.0],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const XpLabel(xp: 480),
          actions: [
            IconButton(
              onPressed: () {
                // TODO open user modal
              },
              icon: const Icon(
                Icons.person_outline_outlined,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: ListView(
          children: <Widget>[
            Container(height: distanceDefault),
            const MedalCarousel(),
            Container(height: distanceDefault),
            Column(
              children: [
                ProgressBar(
                  progress: 0.5,
                  width: MediaQuery.of(context).size.width * 0.66,
                ),
              ],
            ),
            Container(height: distanceTiny),
            const Center(
              child: Text(
                "Noch 80XP bis Level 3",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            Container(height: distanceDefault),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: paddingSmall,
              ),
              child: Row(
                children: [
                  Text(
                    "Verfügbare Challenges",
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: "SpaceGrotesk",
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Container(height: distanceSmall),
            ...challenges
                .map(
                  (challenge) => ActivityCard(
                    onClick: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) =>
                            ChallengeScreen(challenge: challenge),
                      ));
                    },
                    activityName: challenge.title,
                    activityDescription: challenge.description,
                    xp: challenge.points,
                    margin: const EdgeInsets.all(paddingSmall),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }
}
