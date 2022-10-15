import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:helpwave/pages/SettingLanguageSelection.dart';
import 'package:helpwave/services/theme_model.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
      builder: (_, ThemeModel themeNotifier, __) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("helpwave"),
          ),
          body: ListView(
            children: [
              SwitchListTile(
                value: themeNotifier.isDark,
                title: const Text("Dunkel Modus"),
                onChanged: (value) => themeNotifier.isDark = value,
              ),
              ListTile(
                leading: const Icon(Icons.language),
                onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const SettingLanguageSelection())),
                title: Text(AppLocalizations.of(context)!.language),
              ),
            ],
          ),
        );
      },
    );
  }
}
