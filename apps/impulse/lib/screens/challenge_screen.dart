import 'package:flutter/material.dart';
import 'package:helpwave_proto_dart/proto/services/impulse_svc/v1/impulse_svc.pbenum.dart';
import 'package:helpwave_proto_dart/proto/services/impulse_svc/v1/impulse_svc.pbgrpc.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:im_stepper/stepper.dart';
import 'package:impulse/components/challange_menu_card.dart';
import 'package:impulse/components/profile_form.dart';
import 'package:impulse/dataclasses/challange.dart';
import 'package:impulse/dataclasses/user.dart';
import 'package:impulse/dataclasses/verifier.dart';
import 'package:impulse/screens/home_screen.dart';
import 'package:impulse/services/grpc_client_svc.dart';
import 'package:impulse/services/impulse_service.dart';
import 'package:impulse/theming/colors.dart';

import '../components/background_gradient.dart';

class ChallengeScreen extends StatefulWidget {
  final Challenge challenge;

  const ChallengeScreen({super.key, required this.challenge});

  @override
  State<StatefulWidget> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
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
                          id: 'userId'),
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
                          completion: "${index + 1}/${verifiers.length}",
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
              })),
    );
  }
}
