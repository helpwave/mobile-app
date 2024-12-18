import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_service/user.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_theme/util.dart';
import 'package:helpwave_widget/bottom_sheets.dart';
import 'package:helpwave_widget/lists.dart';
import 'package:helpwave_widget/loading.dart';
import 'package:helpwave_widget/navigation.dart';
import 'package:provider/provider.dart';
import 'package:helpwave_service/tasks.dart';
import 'package:helpwave_service/auth.dart';
import 'package:tasks/components/bottom_sheet_pages/ward_select_bottom_sheet.dart';
import 'package:tasks/screens/login_screen.dart';
import 'package:helpwave_widget/widgets.dart';
import 'package:tasks/screens/settings_screen.dart';

class UserBottomSheetPage extends StatelessWidget {
  const UserBottomSheetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomSheetPage(
      header: BottomSheetHeader.navigation(
        context,
        trailing: BottomSheetAction(
          icon: Icons.settings,
          onPressed: () => NavigationStackController.of(context).push(const SettingsBottomSheetPage()),
        ),
      ),
      child: Flexible(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(paddingSmall).copyWith(top: paddingMedium),
              child: LoadingFutureBuilder(
                future: UserService().getSelf(),
                thenBuilder: (context, data) {
                  return CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: iconSizeMedium,
                    foregroundImage: NetworkImage(data.profileUrl.toString()),
                  );
                },
                loadingWidget: const FallbackAvatar(size: iconSizeMedium),
                errorWidget: const FallbackAvatar(size: iconSizeMedium),
              ),
            ),
            Consumer<UserSessionController>(builder: (context, userSessionController, _) {
              return Text(
                userSessionController.identity!.name,
                style: const TextStyle(fontSize: fontSizeBig),
              );
            }),
            Consumer<CurrentWardController>(
              builder: (context, currentWardController, __) => Text(
                currentWardController.currentWard?.organizationName ?? context.localization.loading,
                style: TextStyle(
                  fontSize: fontSizeSmall,
                  color: context.theme.hintColor,
                ),
              ),
            ),
            const SizedBox(height: distanceBig),
            RoundedListTiles(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.house_rounded,
                    color: context.theme.colorScheme.primary,
                  ),
                  title: Text(context.localization.currentWard, style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Consumer<CurrentWardController>(builder: (context, currentWardController, __) {
                        return Text(
                          currentWardController.currentWard!.wardName,
                          style: context.theme.textTheme.labelLarge,
                        );
                      }),
                      const Icon(Icons.expand_more_rounded),
                    ],
                  ),
                  onTap: () {
                    context.pushModal(
                      context: context,
                      builder: (context) => WardSelectBottomSheet(
                        selectedWardId: CurrentWardService().currentWard!.wardId,
                        onChange: (WardMinimal ward) {
                          CurrentWardService().currentWard = CurrentWardInformation(
                            ward,
                            CurrentWardService().currentWard!.organization,
                          );
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: distanceMedium),
              child: Consumer<CurrentWardController>(builder: (context, currentWardService, _) {
                return FilledButton(
                  style: buttonStyleMedium,
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                    UserSessionService().logout();
                    currentWardService.clear();
                  },
                  child: Text(
                    context.localization.logout,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
