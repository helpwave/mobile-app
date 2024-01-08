import 'package:flutter/material.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_widget/bottom_sheets.dart';
import 'package:provider/provider.dart';
import 'package:tasks/components/user_bottom_sheet.dart';
import 'package:tasks/controllers/user_session_controller.dart';
import 'package:tasks/dataclasses/organization.dart';
import 'package:tasks/dataclasses/ward.dart';
import 'package:tasks/screens/settings_screen.dart';
import 'package:tasks/services/current_ward_svc.dart';

/// A [AppBar] for displaying the current [User], [Organization] and [Ward]
class UserHeader extends StatelessWidget implements PreferredSizeWidget {
  // TODO fetch users by with grpc
  const UserHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(paddingSmall),
      child: AppBar(
        centerTitle: false,
        titleSpacing: paddingSmall,
        leadingWidth: iconSizeSmall,
        leading: GestureDetector(
          onTap: () {
            context.pushModal(
              context: context,
              builder: (context) => const UserBottomSheet(),
            );
          },
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: iconSizeSmall / 2,
            child: Container(
              width: iconSizeSmall,
              height: iconSizeSmall,
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
        title: GestureDetector(
          onTap: () {
            context.pushModal(
              context: context,
              builder: (context) => const UserBottomSheet(),
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TODO get information somewhere
              Consumer<UserSessionController>(
                builder: (context, userSession, __) {
                  return Text(
                    userSession.identity!.name,
                    style: const TextStyle(fontSize: 16),
                  );
                }
              ),

              // TODO maybe show something for loading
              Consumer<CurrentWardController>(
                builder: (context, currentWardController, __) => Row(
                  children: [
                    Text(
                      "${currentWardController.currentWard?.organizationName ?? ""} - ",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      currentWardController.currentWard?.wardName ?? "",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            padding: EdgeInsets.zero,
            splashRadius: iconSizeSmall / 2,
            constraints: const BoxConstraints(maxWidth: iconSizeSmall, maxHeight: iconSizeSmall),
            iconSize: iconSizeSmall,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
            icon: const Icon(Icons.settings),
          )
        ],
      ),
    );


  }

  @override
  Size get preferredSize {
    Size size = AppBar().preferredSize;
    return Size(size.width, size.height + 2 * paddingSmall);
  }
}
