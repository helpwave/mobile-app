import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_localization/localization_model.dart';
import 'package:helpwave_service/auth.dart';
import 'package:helpwave_theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:tasks/screens/landing_screen.dart';
import 'package:tasks/services/auth_service.dart';
import 'package:tasks/services/current_ward_svc.dart';

/// Screen for settings and other app options
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.localization!.settings),
      ),
      body: ListView(
        children: [
          Column(
              children: ListTile.divideTiles(context: context, tiles: [
            ListTile(
              leading: const Icon(Icons.brightness_medium),
              title: Text(context.localization!.darkMode),
              trailing: Consumer<ThemeModel>(builder: (_, ThemeModel themeNotifier, __) {
                return Switch(
                  value: themeNotifier.getIsDarkNullSafe(context),
                  onChanged: (bool value) {
                    setState(() {
                      themeNotifier.isDark = value;
                    });
                  },
                );
              }),
            ),
            Consumer<LanguageModel>(
              builder: (context, languageModel, child) {
                return ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(context.localization!.language),
                  trailing: DropdownButton(
                    value: languageModel.local,
                    items: getSupportedLocalsWithName()
                        .map((local) => DropdownMenuItem(
                              value: local.local,
                              child: Text(
                                local.name,
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        languageModel.setLanguage(value);
                      }
                    },
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(context.localization!.licenses),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () => {showLicensePage(context: context)},
            ),
            Consumer<CurrentWardService>(builder: (context, currentWardService, _) {
              return ListTile(
                leading: const Icon(Icons.logout),
                title: Text(context.localization!.logout),
                onTap: () {
                  AuthenticationService().revoke();
                  AuthService().logout();
                  currentWardService.clear();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const LandingScreen()),
                  );
                },
              );
            })
          ]).toList())
        ],
      ),
    );
  }
}
