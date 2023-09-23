import 'package:flutter/material.dart';
import 'package:helpwave_proto_dart/proto/services/impulse_svc/v1/impulse_svc.pbenum.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:impulse/components/activity_card.dart';
import 'package:impulse/components/medal_carusel.dart';
import 'package:impulse/components/progressbar.dart';
import 'package:impulse/components/xp_label.dart';
import 'package:impulse/dataclasses/challange.dart';
import 'package:impulse/services/impulse_service.dart';
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
      category: ChallengeCategory.CHALLENGE_CATEGORY_FITNESS,
      title: "Step by Step",
      description: "Gehe so viele Schritte wie möglich in 30 Minuten.",
      endAt: DateTime.now(),
      startAt: DateTime.now(),
      points: 300,
      threshold: 20,
      type: ChallengeType.CHALLENGE_TYPE_QUEST,
    ),
    Challenge(
      id: "id2",
      category: ChallengeCategory.CHALLENGE_CATEGORY_UNSPECIFIED,
      title: "Dauerläufer",
      description: "Gehe so viele Schritte wie möglich in 30 Minuten.",
      endAt: DateTime.now(),
      startAt: DateTime.now(),
      points: 300,
      threshold: 20,
      type: ChallengeType.CHALLENGE_TYPE_QUEST,
    ),
    Challenge(
      id: "id3",
      category: ChallengeCategory.CHALLENGE_CATEGORY_FOOD,
      title: "Korbleger",
      description:
      "Spiele so viele Körbe wie möglich in 20 Min. auf dem Basketballplatz im Stadtpark.",
      endAt: DateTime.now(),
      startAt: DateTime.now(),
      points: 300,
      threshold: 20,
      type: ChallengeType.CHALLENGE_TYPE_QUEST,
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
            Column(children: [
              ProgressBar(
                progress: 0.5,
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.66,
              ),
            ],),
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
            FutureBuilder(
              initialData: challenges,
              future: ImpulseService().getActiveChallenges(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                List<Challenge> challenges = snapshot.data!;
                return Column(
                  children: challenges
                      .map((challenge) =>
                      ActivityCard(
                        activityName: challenge.title,
                        activityDescription: challenge.description,
                        xp: challenge.points,
                        onClick: () {
                          // TODO open Challenge Screen
                        },
                        margin: const EdgeInsets.all(paddingSmall),))
                      .toList(),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
