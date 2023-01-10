import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:helpwave/pages/emergency_pass_page.dart';
import 'package:helpwave/pages/language_selection_page.dart';
import 'package:helpwave/services/language_model.dart';
import 'package:helpwave/services/theme_model.dart';
import 'package:provider/provider.dart';

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
    return Consumer2<ThemeModel, LanguageModel>(
      builder:
          (_, ThemeModel themeNotifier, LanguageModel languageNotifier, __) {
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
                        builder: (context) => const LanguageSelectionPage())),
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
                      builder: (context) => const EmergencyPassPage()),
                ),
                title: Text(AppLocalizations.of(context)!.emergencyPass),
                trailing: const Icon(
                  Icons.arrow_forward,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
