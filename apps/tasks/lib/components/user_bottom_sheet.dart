import 'dart:math';

import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_theme/theme.dart';
import 'package:helpwave_widget/bottom_sheets.dart';
import 'package:helpwave_widget/loading.dart';
import 'package:provider/provider.dart';
import 'package:tasks/controllers/user_session_controller.dart';
import 'package:tasks/services/current_ward_svc.dart';

import '../dataclasses/ward.dart';
import '../screens/login_screen.dart';
import '../services/user_session_service.dart';
import '../services/ward_service.dart';

/// A [BottomSheet] for showing the [User]s information
class UserBottomSheet extends StatefulWidget {
  const UserBottomSheet({super.key});

  @override
  State<UserBottomSheet> createState() => _UserBottomSheetState();
}

class _UserBottomSheetState extends State<UserBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Consumer2<ThemeModel, UserSessionController>(
      builder: (BuildContext context, ThemeModel themeNotifier,
          UserSessionController userSessionController, _) {
        return BottomSheetBase(
          onClosing: () {},
          titleText: context.localization!.profile,
          builder: (BuildContext ctx) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(paddingSmall)
                    .copyWith(top: paddingMedium),
                child: CircleAvatar(
                  radius: iconSizeMedium,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment(0.8, 1),
                        colors: <Color>[
                          Color(0xff1f005c),
                          Color(0xff5b0060),
                          Color(0xff870160),
                          Color(0xffac255e),
                          Color(0xffca485c),
                          Color(0xffe16b5c),
                          Color(0xfff39060),
                          Color(0xffffb56b),
                        ],
                        tileMode: TileMode.mirror,
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                userSessionController.identity!.name,
                style: const TextStyle(fontSize: fontSizeBig),
              ),
              // TODO consider a loading widget here
              Consumer<CurrentWardController>(
                builder: (context, currentWardController, __) => Text(
                    currentWardController.currentWard?.organizationName ??
                        context.localization!.loading,
                    style: TextStyle(
                        fontSize: fontSizeSmall,
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.6))),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: paddingBig,
                ),
                child: Consumer<CurrentWardController>(
                    builder: (context, currentWardController, __) {
                  return LoadingFutureBuilder(
                      loadingWidget: const SizedBox(),
                      future: WardService().getWardOverviews(
                          organizationId: currentWardController
                              .currentWard!.organizationId),
                      thenWidgetBuilder:
                          (BuildContext context, List<WardOverview> data) {
                        double menuWidth = min(250, width * 0.7);
                        // The theme disables unwanted corner splash effects
                        // For using splashes on the child wrap it in a new Theme()
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
                            currentWardController.currentWard =
                                CurrentWardInformation(
                                    data.firstWhere(
                                        (ward) => ward.id == wardId),
                                    currentWardController
                                        .currentWard!.organization);
                          },
                          // Material used to hide splash effects of the PopupMenu's Inkwell
                          child: Material(
                            child: Container(
                              width: menuWidth,
                              constraints: BoxConstraints(
                                  maxWidth: menuWidth, minWidth: menuWidth),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(borderRadiusMedium),
                                color: Theme.of(context).popupMenuTheme.color,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: paddingMedium,
                                    vertical: paddingSmall),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      context.localization!.ward,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .popupMenuTheme
                                              .textStyle
                                              ?.color
                                              ?.withOpacity(0.6)),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          currentWardController
                                                  .currentWard?.wardName ??
                                              context.localization!.none,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
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
              Padding(
                padding: const EdgeInsets.only(bottom: distanceMedium),
                child: Consumer<CurrentWardController>(
                    builder: (context, currentWardService, _) {
                  return TextButton(
                    onPressed: () {
                      UserSessionService().logout();
                      currentWardService.clear();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
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
      },
    );
  }
}
