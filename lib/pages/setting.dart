import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_model.dart';

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
            ],
          ),
        );
      },
    );
  }
}
