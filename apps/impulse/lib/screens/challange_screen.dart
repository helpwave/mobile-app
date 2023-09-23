import 'package:flutter/material.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:im_stepper/stepper.dart';
import 'package:impulse/components/challange_menu_card.dart';
import 'package:impulse/components/profile_form.dart';
import 'package:impulse/dataclasses/challange.dart';
import 'package:impulse/dataclasses/user.dart';
import 'package:impulse/screens/home_screen.dart';
import 'package:impulse/theming/colors.dart';

class ChallengeScreen extends StatefulWidget {
  final Challenge challenge;

  const ChallengeScreen({super.key, required this.challenge});

  @override
  State<StatefulWidget> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  int index = 0;

  @override
  void initState() {
    while (index < widget.challenge.verifiers.length &&
        widget.challenge.verifiers[index].wasFinished) {
      index++;
    }
    assert(index != widget.challenge.verifiers.length);
    super.initState();
  }

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
                        gender: Gender.na,
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
        body: Column(
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: paddingMedium,
                  right: paddingMedium,
                  top: paddingMedium,
                ),
                child: ChallengeMenuCard(
                  completion:
                      "${index + 1}/${widget.challenge.verifiers.length}",
                  title: widget.challenge.title,
                  description: widget.challenge.description,
                  verifier: widget.challenge.verifiers[index],
                  onFinish: () {
                    if (index + 1 < widget.challenge.verifiers.length) {
                      setState(() {
                        index++;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text("${widget.challenge.points} XP erhalten"),
                          behavior: SnackBarBehavior.floating,
                          margin: const EdgeInsets.all(paddingSmall),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                borderRadiusSmall), // Adjust the radius as needed
                          ),
                        ),
                      );
                      // TODO show finish animation
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
                numbers: List.generate(
                    widget.challenge.verifiers.length, (index) => index + 1),
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
        ),
      ),
    );
  }
}
