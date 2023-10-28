import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_service/auth.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:tasks/screens/main_screen.dart';

/// The Landing Screen of the Application
class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.04,
          horizontal: MediaQuery.of(context).size.height * 0.05,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
                style: ButtonStyle(
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadiusSmall),
                    ),
                  ),
                ),
                child: Text(
                  context.localization!.loginSlogan,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                onPressed: () => {
                      AuthenticationService()
                          .authenticate(
                              context: context,
                              callback: () =>
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const MainScreen()))
                      )
                          .then((value) {
                            print("hi");
                            print(value);
                        if (value != null) {
                          // TODO do something with the auth token
                          print(value);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const MainScreen()));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(context.localization!.loginFailed)),
                          );
                        }
                      })
                    }),
            // TODO remove
            const SizedBox(
              height: distanceDefault,
            ),
            OutlinedButton(
                style: ButtonStyle(
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadiusSmall),
                    ),
                  ),
                ),
                child: Text(
                  "Login without auth",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const MainScreen()),
                  );
                }),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
