import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_theme/theme.dart';
import 'package:provider/provider.dart';

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: paddingMedium),
        child: ListView(
          children: [
            Column(
                children: ListTile.divideTiles(context: context, tiles: [
              ListTile(
                leading: const Icon(Icons.brightness_medium),
                title: Text(context.localization!.darkMode),
                trailing: Consumer<ThemeModel>(
                    builder: (_, ThemeModel themeNotifier, __) {
                  // Check System mode
                  bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
                  if (themeNotifier.isDark != null) {
                    isDarkTheme = themeNotifier.isDark!;
                  }
                  return Switch(
                    value: isDarkTheme,
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
                onTap: () => {},
              )
            ]).toList())
          ],
        ),
      ),
    );
  }
}
