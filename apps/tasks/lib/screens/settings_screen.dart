import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_localization/localization_model.dart';
import 'package:helpwave_service/auth.dart';
import 'package:helpwave_service/user.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_theme/theme.dart';
import 'package:helpwave_theme/util.dart';
import 'package:helpwave_widget/bottom_sheets.dart';
import 'package:helpwave_widget/lists.dart';
import 'package:helpwave_widget/loading.dart';
import 'package:helpwave_widget/navigation.dart';
import 'package:provider/provider.dart';
import 'package:tasks/components/bottom_sheet_pages/organization_bottom_sheet.dart';
import 'package:tasks/components/bottom_sheet_pages/task_templates_bottom_sheet.dart';
import 'package:tasks/screens/login_screen.dart';

/// Screen for settings and other app options
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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

class NavigationListTile extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final String title;
  final void Function() onTap;
  final String? trailingText;

  const NavigationListTile({
    super.key,
    required this.icon,
    this.color,
    required this.title,
    required this.onTap,
    this.trailingText,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: color ?? context.theme.colorScheme.primary,
      ),
      onTap: onTap,
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          trailingText != null
              ? Text(
                  trailingText!,
                  style: context.theme.textTheme.labelLarge,
                )
              : const SizedBox(),
          Icon(
            Icons.chevron_right_rounded,
            color: context.theme.colorScheme.onBackground.withOpacity(0.7),
          ),
        ],
      ),
    );
  }
}

class SettingsBottomSheetPage extends StatelessWidget {
  const SettingsBottomSheetPage({super.key});

  @override
  Widget build(BuildContext context) {
    titleBuilder(String title) {
      return Padding(
        padding: const EdgeInsets.only(bottom: paddingSmall),
        child: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: "SpaceGrotesk"),
        ),
      );
    }

    return BottomSheetPage(
      header: BottomSheetHeader.navigation(
        context,
        titleText: context.localization!.settings,
      ),
      child: Flexible(
        child: ListView(
          children: [
            titleBuilder(context.localization!.personalSettings),
            RoundedListTiles(
              children: [
                NavigationListTile(
                  icon: Icons.person,
                  title: context.localization!.personalData,
                  onTap: () {},
                ),
                NavigationListTile(
                  icon: Icons.security_rounded,
                  title: context.localization!.passwordAndSecurity,
                  onTap: () {},
                ),
                NavigationListTile(
                  icon: Icons.checklist_rounded,
                  title: context.localization!.myTaskTemplates,
                  onTap: () {
                    NavigationStackController.of(context).push(const TaskTemplatesBottomSheetPage(isPersonal: true));
                  },
                ),
              ],
            ),
            const SizedBox(height: distanceMedium),
            titleBuilder(context.localization!.myOrganizations),
            LoadingFutureBuilder(
              future: OrganizationService().getOrganizationsForUser(),
              thenBuilder: (context, data) {
                return RoundedListTiles(
                  children: data
                      .map((organization) => NavigationListTile(
                            icon: Icons.apartment_rounded,
                            title: organization.longName,
                            onTap: () {
                              NavigationStackController.of(context)
                                  .push(OrganizationBottomSheetPage(organizationId: organization.id));
                            },
                          ))
                      .toList(),
                );
              },
              loadingWidget: const PulsingContainer(height: 50),
            ),
            const SizedBox(height: distanceMedium),
            titleBuilder(context.localization!.appearance),
            RoundedListTiles(
              children: [
                ListTile(
                  leading: Icon(Icons.brightness_medium, color: context.theme.colorScheme.primary),
                  title: Text(context.localization!.darkMode, style: const TextStyle(fontWeight: FontWeight.bold)),
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
                      );
                    },
                  ),
                ),
                Consumer<LanguageModel>(
                  builder: (context, languageModel, child) {
                    return ListTile(
                      leading: Icon(Icons.language, color: context.theme.colorScheme.primary),
                      title: Text(
                        context.localization!.language,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
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
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: distanceMedium),
            titleBuilder(context.localization!.other),
            RoundedListTiles(
              children: [
                NavigationListTile(
                  icon: Icons.info_outline,
                  title: context.localization!.licenses,
                  onTap: () => {showLicensePage(context: context)},
                ),
                Consumer<CurrentWardController>(
                  builder: (context, currentWardService, _) {
                    return NavigationListTile(
                      icon: Icons.logout,
                      title: context.localization!.logout,
                      color: Colors.red.withOpacity(0.7), // TODO get this from theme
                      onTap: () {
                        // TODO add confirm dialog
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
            ),
          ],
        ),
      ),
    );
  }
}
