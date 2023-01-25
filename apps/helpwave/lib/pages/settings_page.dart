import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_localization/localization_model.dart';
import 'package:helpwave/styling/constants.dart';
import 'package:provider/provider.dart';
import 'package:helpwave/components/accept_dialog.dart';
import 'package:helpwave/pages/landing_page.dart';
import 'package:helpwave/services/introduction_model.dart';
import 'package:helpwave/pages/emergency_pass_page.dart';
import 'package:helpwave/pages/language_selection_page.dart';
import 'package:helpwave/services/theme_model.dart';

/// Page for displaying basic Settings
///
/// for example: Theme, Language and a Navigation to [EmergencyPassPage]
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer3<ThemeModel, LanguageModel, IntroductionModel>(
      builder: (_, ThemeModel themeNotifier, LanguageModel languageNotifier, IntroductionModel introductionModel, __) {
        bool isDarkTheme = themeNotifier.isDark ?? Theme.of(context).brightness == Brightness.dark;
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("helpwave"),
          ),
          body: ListView(
            children: [
              SwitchListTile(
                value: isDarkTheme,
                secondary: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.brightness_4,
                    ),
                  ],
                ),
                subtitle: Text(isDarkTheme ? context.localization!.on : context.localization!.off),
                title: Text(context.localization!.darkMode),
                onChanged: (value) => themeNotifier.isDark = value,
              ),
              ListTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.language,
                    ),
                  ],
                ),
                subtitle: Text(languageNotifier.name),
                onTap: () =>
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LanguageSelectionPage())),
                title: Text(context.localization!.language),
                trailing: const Icon(
                  Icons.arrow_forward,
                ),
              ),
              ListTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.emergency,
                    ),
                  ],
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EmergencyPassPage()),
                ),
                title: Text(context.localization!.emergencyPass),
                trailing: const Icon(
                  Icons.arrow_forward,
                ),
              ),
              AboutListTile(
                icon: const Icon(Icons.info),
                applicationIcon: Center(
                  child: Image.asset(
                    height: iconSizeMedium,
                    width: iconSizeMedium,
                    Theme.of(context).brightness == Brightness.light
                        ? 'assets/helpwave-icon-dark.png'
                        : 'assets/helpwave-icon-light.png',
                  ),
                ),
              ),
              ListTile(
                title: Text(context.localization!.resetIntroduction),
                leading: const Icon(Icons.refresh),
                onTap: () => showDialog(
                  context: context,
                  builder: (context) => AcceptDialog(
                    titleText: context.localization!.showIntroduction,
                  ),
                ).then((value) {
                  if (value == true) {
                    introductionModel.setHasSeenIntroduction(hasSeenIntroduction: false);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LandingPage(),
                        ));
                  }
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}
