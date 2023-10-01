import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:helpwave_proto_dart/proto/services/impulse_svc/v1/impulse_svc.pbenum.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:impulse/components/activity_card.dart';
import 'package:impulse/components/background_gradient.dart';
import 'package:impulse/components/medal_carousel.dart';
import 'package:impulse/components/progressbar.dart';
import 'package:impulse/components/xp_label.dart';
import 'package:impulse/dataclasses/challenge.dart';
import 'package:impulse/services/impulse_service.dart';
import 'package:impulse/screens/challenge_screen.dart';
import 'package:impulse/theming/colors.dart';
import '../components/profile_form.dart';
import '../dataclasses/user.dart';
import '../services/grpc_client_svc.dart';
import '../util/level.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _timer;
  int score = 0;

  @override
  void initState() {
    ImpulseService().getScore(userID).then((value) => setState(() {
          score = value;
        }));
    _timer = Timer.periodic(
      const Duration(seconds: 3),
      (Timer timer) {
        ImpulseService().getScore(userID).then((value) => setState(() {
              score = value;
            }));
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundGradient(
      child: Scaffold(
        appBar: AppBar(
          title: XpLabel(xp: score),
          actions: [
            IconButton(
              onPressed: () => showDialog(
                context: context,
                builder: (_) => Dialog(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  child: ProfileForm(
                    initialUser: User(
                        username: "User",
                        birthday: DateTime(2000),
                        gender: Gender.GENDER_UNSPECIFIED,
                        pal: 1,
                        id: 'userId1'),
                  ),
                ),
              ),
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
            MedalCarousel(unlockedTo: currentLevel(score)),
            Container(height: distanceDefault),
            Column(
              children: [
                ProgressBar(
                  progress: max(0, min(1, 1 - missingToNextLevel(score) / currentLevelXPRequirement(score))),
                  width: MediaQuery.of(context).size.width * 0.66,
                ),
              ],
            ),
            Container(height: distanceTiny),
            Center(
              child: Text(
                "Noch ${missingToNextLevel(score)}XP bis Level ${min(currentLevel(score) + 1, maxLvl)}",
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            Container(height: distanceDefault),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: paddingMedium,
              ),
              child: Row(
                children: [
                  Text(
                    "Verfügbare Challenges",
                    style: TextStyle(
                      fontSize: fontSizeBig,
                      fontFamily: "Fredoka",
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Container(height: distanceSmall),
            FutureBuilder(
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
                  mainAxisAlignment: challenges.isEmpty ? MainAxisAlignment.center : MainAxisAlignment.start,
                  children: challenges.isEmpty
                      ? [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: paddingMedium),
                            child: Text("Keine Challenges gefunden :(", style: TextStyle(color: Colors.white)),
                          ),
                        ]
                      : [
                          for (int i = 0; i < challenges.length; i++)
                            ActivityCard(
                              accentColor: colors[i % colors.length],
                              activityName: challenges[i].title,
                              activityDescription: challenges[i].description,
                              xp: challenges[i].points,
                              onClick: () {
                                Navigator.of(context).pushReplacement(MaterialPageRoute(
                                  builder: (context) => ChallengeScreen(challenge: challenges[i]),
                                ));
                              },
                              margin: const EdgeInsets.symmetric(
                                horizontal: paddingMedium,
                                vertical: paddingSmall,
                              ),
                            )
                        ],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
