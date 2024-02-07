import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_theme/theme.dart';
import 'package:helpwave_widget/loading.dart';
import 'package:provider/provider.dart';
import 'package:tasks/controllers/user_session_controller.dart';

/// The Landing Screen of the Application
class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: distanceBig),
        child: Consumer<UserSessionController>(builder: (context, userSessionController, __) {
          if (!userSessionController.hasTriedTokens) {
            return const LoadingSpinner(
              size: iconSizeMedium,
            );
          }

          return OutlinedButton(
            style: buttonStyleBig.copyWith(side: const MaterialStatePropertyAll(buttonBorderSideBig)),
            child: Text(
              context.localization!.loginSlogan,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            onPressed: () {
              userSessionController.login();
            },
          );
        }),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.33),
          Consumer<ThemeModel>(
            builder: (BuildContext context, ThemeModel themeNotifier, _) => Center(
              child: Image.asset(
                themeNotifier.getIsDarkNullSafe(context)
                    ? 'assets/transparent-logo-dark.png'
                    : 'assets/transparent-logo-light.png',
                width: MediaQuery.of(context).size.height * 0.25,
                height: MediaQuery.of(context).size.height * 0.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
