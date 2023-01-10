import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:helpwave/components/accept_dialog.dart';
import 'package:helpwave/pages/emergency_pass.dart';
import 'package:helpwave/pages/landing.dart';
import 'package:helpwave/pages/setting_language_selection.dart';
import 'package:helpwave/services/introduction_model.dart';
import 'package:helpwave/services/language_model.dart';
import 'package:helpwave/services/theme_model.dart';
import 'package:helpwave/styling/constants.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer3<ThemeModel, LanguageModel, IntroductionModel>(
      builder: (_, ThemeModel themeNotifier, LanguageModel languageNotifier,
          IntroductionModel introductionModel, __) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("helpwave"),
          ),
          body: ListView(
            children: [
              SwitchListTile(
                value: themeNotifier.isDark,
                secondary: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.brightness_4,
                    ),
                  ],
                ),
                subtitle: Text(themeNotifier.isDark
                    ? AppLocalizations.of(context)!.on
                    : AppLocalizations.of(context)!.off),
                title: Text(AppLocalizations.of(context)!.darkMode),
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
                onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const SettingLanguageSelectionPage())),
                title: Text(AppLocalizations.of(context)!.language),
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
                onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EmergencyPass())),
                title: Text(AppLocalizations.of(context)!.emergencyPass),
                trailing: const Icon(
                  Icons.arrow_forward,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(paddingMedium),
                child: TextButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => AcceptDialog(
                      titleText: AppLocalizations.of(context)!.resetQuestion,
                    ),
                  ).then((value) {
                    if (value == true) {
                      introductionModel.setHasSeenIntroduction(
                          hasSeenIntroduction: false);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LandingPage(),
                          ));
                    }
                  }),
                  child: Text(AppLocalizations.of(context)!.reset),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
