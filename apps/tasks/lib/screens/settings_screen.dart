import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_localization/localization_model.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:tasks/screens/login_screen.dart';
import 'package:tasks/services/user_session_service.dart';
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
            children: ListTile.divideTiles(
              context: context,
              tiles: [
                ListTile(
                  leading: const Icon(Icons.brightness_medium),
                  title: Text(context.localization!.darkMode),
                  trailing: Consumer<ThemeModel>(
                    builder: (_, ThemeModel themeNotifier, __) {
                      return PopupMenuButton(
                        initialValue: themeNotifier.themeMode,
                        position: PopupMenuPosition.under,
                        itemBuilder: (context) => [
                          PopupMenuItem(value: ThemeMode.dark, child: Text(context.localization!.darkMode)),
                          PopupMenuItem(value: ThemeMode.light, child: Text(context.localization!.lightMode)),
                          PopupMenuItem(value: ThemeMode.system, child: Text(context.localization!.system)),
                        ],
                        onSelected: (value) {
                          if (value == ThemeMode.system) {
                            themeNotifier.isDark = null;
                          } else {
                            themeNotifier.isDark = value == ThemeMode.dark;
                          }
                        },
                        child: Material(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                  {
                                    ThemeMode.dark: context.localization!.darkMode,
                                    ThemeMode.light: context.localization!.lightMode,
                                    ThemeMode.system: context.localization!.system,
                                  }[themeNotifier.themeMode]!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                  )),
                              const SizedBox(
                                width: distanceTiny,
                              ),
                              const Icon(
                                Icons.expand_more_rounded,
                                size: iconSizeTiny,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Consumer<LanguageModel>(
                  builder: (context, languageModel, child) {
                    return ListTile(
                      leading: const Icon(Icons.language),
                      title: Text(context.localization!.language),
                      trailing: PopupMenuButton(
                        position: PopupMenuPosition.under,
                        initialValue: languageModel.local,
                        onSelected: (value) {
                          languageModel.setLanguage(value);
                        },
                        itemBuilder: (BuildContext context) => getSupportedLocalsWithName()
                            .map((local) => PopupMenuItem(
                                  value: local.local,
                                  child: Text(
                                    local.name,
                                  ),
                                ))
                            .toList(),
                        child: Material(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(languageModel.name,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                  )),
                              const SizedBox(
                                width: distanceTiny,
                              ),
                              const Icon(
                                Icons.expand_more_rounded,
                                size: iconSizeTiny,
                              ),
                            ],
                          ),
                        ),
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
                Consumer<CurrentWardController>(
                  builder: (context, currentWardService, _) {
                    return ListTile(
                      leading: const Icon(Icons.logout),
                      title: Text(context.localization!.logout),
                      onTap: () {
                        UserSessionService().logout();
                        currentWardService.clear();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                        );
                      },
                    );
                  },
                ),
              ],
            ).toList(),
          ),
        ],
      ),
    );
  }
}
