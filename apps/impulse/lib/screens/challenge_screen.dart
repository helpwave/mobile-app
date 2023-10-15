import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:helpwave_proto_dart/proto/services/impulse_svc/v1/impulse_svc.pb.dart';
import 'package:helpwave_service/user.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:im_stepper/stepper.dart';
import 'package:impulse/components/challenge_menu_card.dart';
import 'package:impulse/dataclasses/challenge.dart';
import 'package:impulse/dataclasses/user.dart';
import 'package:impulse/dataclasses/verifier.dart';
import 'package:impulse/screens/home_screen.dart';
import 'package:impulse/screens/profile_screen.dart';
import 'package:impulse/services/grpc_client_svc.dart';
import 'package:impulse/services/impulse_service.dart';
import 'package:impulse/theming/colors.dart';
import 'package:provider/provider.dart';

import '../components/background_gradient.dart';

/// A Screen on which the [User] solves [Challenge]s
class ChallengeScreen extends StatefulWidget {
  /// The [Challenge] the [User] should solve
  final Challenge challenge;

  const ChallengeScreen({super.key, required this.challenge});

  @override
  State<StatefulWidget> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, UserModel userNotifier, __) {
      User? user;

      if (userNotifier.user.isNotEmpty){
        final userData = jsonDecode(userNotifier.user);
        user = User(
          id: userData['id'],
          height: userData['height'],
          weight: userData['weight'],
          pal: userData['pal'],
          username: userData['username'],
          gender: Gender.values[userData['gender']],
          birthday: DateTime.parse(userData['birthday']),
        );
      }

      return BackgroundGradient(
        child: Scaffold(
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    iconSize: iconSizeTiny,
                    icon: const Icon(Icons.close, color: primary),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ),
              title: Text(
                widget.challenge.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                            initialUser: user,
                          )
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.person_outline_outlined,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            body: FutureBuilder(
                future: ImpulseService().getVerifiers(widget.challenge.id),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  List<Verifier> verifiers = snapshot.data ?? [];

                  if (verifiers.isEmpty) {
                    return const Center(
                      child: Text("Die Challenge hat noch keine Aufgaben", style: TextStyle(color: Colors.white)),
                    );
                  }
                  return Column(
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: paddingMedium,
                            right: paddingMedium,
                            top: paddingMedium,
                          ),
                          child: ChallengeMenuCard(
                            progressText: "${index + 1}/${verifiers.length}",
                            title: widget.challenge.title,
                            description: widget.challenge.description,
                            verifier: verifiers[index],
                            onFinish: () {
                              if (index + 1 < verifiers.length) {
                                setState(() {
                                  index++;
                                });
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("${widget.challenge.points} XP erhalten"),
                                    behavior: SnackBarBehavior.floating,
                                    margin: const EdgeInsets.all(paddingSmall),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(borderRadiusSmall), // Adjust the radius as needed
                                    ),
                                  ),
                                );
                                ImpulseService().trackChallenge(userID, widget.challenge.id, widget.challenge.points);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomeScreen(),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: paddingSmall),
                        child: NumberStepper(
                          numbers: List.generate(verifiers.length, (index) => index + 1),
                          activeStep: index,
                          enableNextPreviousButtons: false,
                          lineColor: Colors.white,
                          lineDotRadius: 2,
                          stepColor: disabled,
                          activeStepBorderColor: Colors.transparent,
                          activeStepColor: Colors.white,
                          enableStepTapping: false,
                        ),
                      ),
                    ],
                  );
                }
            )
        ),
      );
    });
  }
}
