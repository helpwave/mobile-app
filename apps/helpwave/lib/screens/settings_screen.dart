import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_localization/localization_model.dart';
import 'package:helpwave_theme/theme.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_widget/dialog.dart';
import 'package:helpwave_service/introduction.dart';
import 'package:helpwave/screens/landing_screen.dart';
import 'package:helpwave/screens/emergency_pass_screen.dart';
import 'package:helpwave/screens/language_selection_screen.dart';

/// Screen for displaying basic Settings
///
/// for example: Theme, Language and a Navigation to [EmergencyPassScreen]
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("helpwave"),
      ),
      body: ListView(
        children: [
          Consumer<ThemeModel>(
              builder: (BuildContext context, ThemeModel themeNotifier, _) {
            bool isDarkTheme = themeNotifier.getIsDarkNullSafe(context);
            return SwitchListTile(
              value: isDarkTheme,
              secondary: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.brightness_4,
                  ),
                ],
              ),
              subtitle: Text(isDarkTheme
                  ? context.localization!.on
                  : context.localization!.off),
              title: Text(context.localization!.darkMode),
              onChanged: (value) => themeNotifier.isDark = value,
            );
          }),
          ListTile(
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.language,
                ),
              ],
            ),
            subtitle: Consumer<LanguageModel>(
              builder: (_, LanguageModel languageNotifier, __) =>
                  Text(languageNotifier.name),
            ),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const LanguageSelectionScreen())),
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
              MaterialPageRoute(
                  builder: (context) => const EmergencyPassScreen()),
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
          Consumer<IntroductionModel>(
            builder: (_, IntroductionModel introductionModel, __) => ListTile(
              title: Text(context.localization!.resetIntroduction),
              leading: const Icon(Icons.refresh),
              onTap: () => showDialog(
                context: context,
                builder: (context) => AcceptDialog(
                  yesText: context.localization!.yes,
                  noText: context.localization!.no,
                  titleText: context.localization!.showIntroduction,
                ),
              ).then((value) {
                if (value == true) {
                  introductionModel.setHasSeenIntroduction(
                      hasSeenIntroduction: false);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LandingScreen(),
                      ));
                }
              }),
            ),
          ),
        ],
      ),
    );
  }
}
