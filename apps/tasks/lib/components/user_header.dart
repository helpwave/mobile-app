import 'package:flutter/material.dart';
import 'package:helpwave_service/auth.dart';
import 'package:helpwave_service/tasks.dart';
import 'package:helpwave_service/user.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_theme/util.dart';
import 'package:helpwave_widget/bottom_sheets.dart';
import 'package:helpwave_widget/loading.dart';
import 'package:helpwave_widget/navigation.dart';
import 'package:helpwave_widget/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tasks/components/bottom_sheet_pages/user_bottom_sheet.dart';

/// A [AppBar] for displaying the current [User], [Organization] and [Ward]
class UserHeader extends StatelessWidget implements PreferredSizeWidget {
  const UserHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.appBarTheme.backgroundColor,
        boxShadow: [
          BoxShadow(spreadRadius: 0, blurRadius: 2, offset: const Offset(0, -1), color: Colors.black.withOpacity(0.1)),
        ]
      ),
      child: Consumer<UserSessionController>(builder: (context, userSession, __) {
        return SafeArea(
          child: ListTile(
            leading: SizedBox(
              width: iconSizeSmall,
              height: iconSizeSmall,
              child: LoadingFutureBuilder(
                data: UserService().getSelf(),
                thenWidgetBuilder: (context, data) {
                  return CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: iconSizeSmall / 2,
                    foregroundImage: NetworkImage(data.profileUrl.toString()),
                  );
                },
                loadingWidget: const FallbackAvatar(),
                errorWidget: const FallbackAvatar(),
              ),
            ),
            onTap: () {
              context.pushModal(
                context: context,
                builder: (context) => NavigationOutlet(initialValue: const UserBottomSheetPage()),
              );
            },
            title: Text(
              userSession.identity!.name,
              style: const TextStyle(fontSize: 16),
            ),
            subtitle: Consumer<CurrentWardController>(
              builder: (context, currentWardController, __) => Row(
                children: [
                  Text(
                    "${currentWardController.currentWard?.organization.shortName ?? ""} - ",
                    style: TextStyle(
                      color: context.theme.colorScheme.onBackground.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    currentWardController.currentWard?.wardName ?? "",
                    overflow: TextOverflow.fade,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            trailing: const Icon(Icons.expand_more),
          ),
        );
      }),
    );
  }

  @override
  Size get preferredSize {
    Size size = AppBar().preferredSize;
    return Size(size.width, size.height + 2 * paddingSmall);
  }
}
