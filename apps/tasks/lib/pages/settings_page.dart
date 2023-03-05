import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';


/// Screen for settings and other app options
class SettingsPage extends StatefulWidget{
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkTheme = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.localization!.settings),
      ),
      body: ListView(
        children: [
          Padding(padding: const EdgeInsets.symmetric(horizontal: paddingSmall), child:
            Column(
              children:
              ListTile.divideTiles(context: context,
                  tiles: [
                    ListTile(
                    leading: const Icon(Icons.brightness_medium),
                    title: Text(context.localization!.darkMode),
                    trailing: Switch(value: isDarkTheme, onChanged: (bool value){
                      setState(() {
                        isDarkTheme = !isDarkTheme;
                      });
                    },),
                  ),
                    ListTile(
                    leading: const Icon(Icons.language),
                    title: Text(context.localization!.language),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () => {

                    },
                  ),
                    ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: Text(context.localization!.licenses),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () => {

                    },
                  ),
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: Text(context.localization!.logout),
                      onTap: () => {

                      },
                    )
                  ]
              ).toList())
          )
        ],
      ),
    );
  }
}
