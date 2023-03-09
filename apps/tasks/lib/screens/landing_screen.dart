import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/theme.dart';
import 'package:provider/provider.dart';

/// The Landing Screen of the Application
class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.04),
        child: OutlinedButton(
          child: Text(context.localization!.loginSlogan),
          onPressed: () => {
            // TODO navigate to next Screen
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.33),
          Consumer<ThemeModel>(
            builder: (BuildContext context, ThemeModel themeNotifier, _) =>
                Center(
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
