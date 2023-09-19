import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:tasks/screens/landing_screen.dart';

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
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(context.localization!.language),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () => {},
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(context.localization!.licenses),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () => {showLicensePage(context: context)},
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(context.localization!.logout),
              onTap: () {
                // TODO logout user in [AuthService]
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LandingScreen()),
                );
              },
            )
          ]).toList())
        ],
      ),
    );
  }
}
