import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_service/introduction.dart';
import 'package:helpwave/pages/home_page.dart';

/// Landing-Page, if the user start the app for the first time
class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    const double startContainerWidthPercentage = 0.4;
    const double startContainerHeightPercentage = 0.1;
    const double startContainerTextIconDistance = distanceDefault;
    const double startContainerBorderRadius = borderRadiusVeryBig;

    Size mediaQuery = MediaQuery
        .of(context)
        .size;
    return Consumer<IntroductionModel>(
      builder: (context, IntroductionModel introductionModel, _) =>
          Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        Theme
                            .of(context)
                            .brightness == Brightness.light
                            ? 'assets/helpwave-icon-dark.png'
                            : 'assets/helpwave-icon-light.png',
                        width: iconSizeBig,
                        height: iconSizeBig,
                      ),
                      const SizedBox(
                        width: distanceSmall,
                      ),
                      Text("helpwave",
                          style: Theme
                              .of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                            color: Theme
                                .of(context)
                                .colorScheme
                                .onBackground,
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  width: mediaQuery.height * startContainerWidthPercentage,
                  height: mediaQuery.height * startContainerHeightPercentage,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(startContainerBorderRadius),
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ));
                      introductionModel.setHasSeenIntroduction();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(context.localization!.start),
                        Container(width: startContainerTextIconDistance),
                        const Icon(Icons.arrow_forward),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
