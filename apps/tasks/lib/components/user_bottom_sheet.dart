import 'dart:math';
import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_service/user.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_widget/bottom_sheets.dart';
import 'package:helpwave_widget/loading.dart';
import 'package:helpwave_widget/navigation.dart';
import 'package:provider/provider.dart';
import 'package:helpwave_service/tasks.dart';
import 'package:helpwave_service/auth.dart';
import 'package:tasks/screens/login_screen.dart';
import 'package:helpwave_widget/widgets.dart';
import 'package:tasks/screens/settings_screen.dart';


class UserBottomSheetPageBuilder with BottomSheetPageBuilder {
  @override
  BottomSheetHeader? headerBuilder(BuildContext context, NavigationController<BottomSheetPageBuilder> controller) {
    return BottomSheetHeader(
      trailing: BottomSheetAction(
        icon: Icons.settings,
        onPressed: () => controller.push(SettingsBottomSheetPageBuilder()),
      ),
    );
  }

  @override
  Widget build(BuildContext context, NavigationController<BottomSheetPageBuilder> controller) {
    final double width = MediaQuery.of(context).size.width;

    return Flexible(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(paddingSmall).copyWith(top: paddingMedium),
            child: LoadingFutureBuilder(
              data: UserService().getSelf(),
              thenWidgetBuilder: (context, data) {
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
              currentWardController.currentWard?.organizationName ?? context.localization!.loading,
              style: TextStyle(
                fontSize: fontSizeSmall,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: paddingBig,
            ),
            child: Consumer<CurrentWardController>(builder: (context, currentWardController, __) {
              return LoadingFutureBuilder(
                  loadingWidget: const SizedBox(),
                  data:
                      WardService().getWardOverviews(organizationId: currentWardController.currentWard!.organizationId),
                  thenWidgetBuilder: (BuildContext context, List<WardOverview> data) {
                    double menuWidth = min(250, width * 0.7);
                    return PopupMenuButton(
                      initialValue: currentWardController.currentWard?.wardId,
                      shadowColor: Colors.transparent,
                      position: PopupMenuPosition.under,
                      itemBuilder: (context) {
                        return data
                            .map(
                              (WardOverview ward) => PopupMenuItem(
                                value: ward.id,
                                child: SizedBox(
                                  child: Text(ward.name),
                                ),
                              ),
                            )
                            .toList();
                      },
                      onSelected: (wardId) {
                        currentWardController.currentWard = CurrentWardInformation(
                            data.firstWhere((ward) => ward.id == wardId),
                            currentWardController.currentWard!.organization);
                      },
                      // Material used to hide splash effects of the PopupMenu's Inkwell
                      child: Material(
                        child: Container(
                          width: menuWidth,
                          constraints: BoxConstraints(maxWidth: menuWidth, minWidth: menuWidth),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(borderRadiusMedium),
                            color: Theme.of(context).popupMenuTheme.color,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: paddingMedium, vertical: paddingSmall),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  context.localization!.ward,
                                  style: TextStyle(
                                    color: Theme.of(context).popupMenuTheme.textStyle?.color?.withOpacity(0.6),
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      currentWardController.currentWard?.wardName ?? context.localization!.none,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      width: distanceTiny,
                                    ),
                                    const Icon(
                                      Icons.expand_more_rounded,
                                      size: iconSizeTiny,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            }),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: distanceMedium),
            child: Consumer<CurrentWardController>(builder: (context, currentWardService, _) {
              return TextButton(
                style: buttonStyleMedium,
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                  UserSessionService().logout();
                  currentWardService.clear();
                },
                child: Text(
                  context.localization!.logout,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
