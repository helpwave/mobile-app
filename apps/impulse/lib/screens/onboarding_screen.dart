import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:helpwave_service/introduction.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:impulse/screens/profile_screen.dart';
import 'package:provider/provider.dart';
import '../dataclasses/user.dart';
import '../notifiers/user_model.dart';
import '../theming/colors.dart';
import 'home_screen.dart';

/// The Screen shown when a [User] opens the app for the first time
class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<StatefulWidget> createState() => _OnboardingScreenSate();
}

class _OnboardingScreenSate extends State<OnBoardingScreen> {
  int currentIndexPage = 0;
  CarouselController carouselController = CarouselController();
  List<Widget> carouseItems = [
    // TODO: replace
    Container(
      width: 350,
      margin: const EdgeInsets.symmetric(horizontal: paddingSmall),
      decoration:
          const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(borderRadiusBig)), color: Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: paddingMedium),
            child: SvgPicture.asset(
              "assets/svg/fi_4259295.svg",
            ),
          ),
          const Text(
            "Next Level",
            style: TextStyle(
              fontSize: fontSizeBig,
              fontWeight: FontWeight.bold,
              color: primary,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingBig, vertical: paddingSmall),
            child: Text(
              "Erhalte für jede Challenge Punkte und erreiche das nächste Level.",
              style: TextStyle(color: primary),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    ),
    Container(
        width: 350,
        margin: const EdgeInsets.symmetric(horizontal: paddingSmall),
        decoration:
            const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(borderRadiusBig)), color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: paddingMedium),
              child: SvgPicture.asset(
                "assets/svg/fi_2698141.svg",
              ),
            ),
            const Text(
              "Sportliche Challenges",
              style: TextStyle(
                fontSize: fontSizeBig,
                fontWeight: FontWeight.bold,
                color: primary,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: paddingBig, vertical: paddingSmall),
              child: Text(
                "Meistere jeden Tag neue, aufregende Challenges in deiner Stadt.",
                textAlign: TextAlign.center,
                style: TextStyle(color: primary),
              ),
            )
          ],
        ))
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Container(
                  height: 100,
                ),
                CarouselSlider(
                  carouselController: carouselController,
                  items: carouseItems.map((item) {
                    return Builder(
                      builder: (BuildContext context) {
                        return item;
                      },
                    );
                  }).toList(),
                  options: CarouselOptions(
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentIndexPage = index;
                      });
                    },
                    autoPlay: true,
                    autoPlayAnimationDuration: const Duration(milliseconds: 500),
                    height: 350.0,
                  ),
                ),
              ],
            ),
          ),
          DotsIndicator(
            dotsCount: carouseItems.length,
            position: currentIndexPage,
            decorator: DotsDecorator(
              color: Colors.white,
              size: const Size.square(9.0),
              activeSize: const Size(18.0, 9.0),
              activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              activeColor: Colors.white,
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Consumer<IntroductionModel>(builder: (_, IntroductionModel introductionNotifier, __) => TextButton(
              onPressed: () {
                introductionNotifier.setHasSeenIntroduction(hasSeenIntroduction: true);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
              child: const Text(
                "Überspringen",
                style: TextStyle(color: Colors.white),
              ),
            ),),
            TextButton(
              onPressed: () {
                carouselController.nextPage();
                setState(() {
                  if (currentIndexPage < carouseItems.length - 1) {
                    currentIndexPage += 1;
                  } else {
                    currentIndexPage = 0;
                  }
                });
              },
              child: Row(
                children: [
                  Consumer<UserModel>(builder: (_, UserModel userNotifier, __) =>   GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          if (!userNotifier.isInitialized) {
                            return const ProfileScreen();
                          }
                          return const HomeScreen();
                        }),
                      );
                    },
                    child: const Text("Weiter", style: TextStyle(color: Colors.white)),
                  ),),
                  const Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Colors.white,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
