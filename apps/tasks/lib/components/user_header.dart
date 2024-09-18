import 'package:flutter/material.dart';
import 'package:helpwave_service/auth.dart';
import 'package:helpwave_service/tasks.dart';
import 'package:helpwave_service/user.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_theme/util.dart';
import 'package:helpwave_widget/bottom_sheets.dart';
import 'package:helpwave_widget/loading.dart';
import 'package:helpwave_widget/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tasks/components/user_bottom_sheet.dart';

/// A [AppBar] for displaying the current [User], [Organization] and [Ward]
class UserHeader extends StatelessWidget implements PreferredSizeWidget {
  const UserHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.theme.appBarTheme.backgroundColor,
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
                builder: (context) => BottomSheetNavigator(initialPageBuilder: UserBottomSheetPageBuilder()),
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
                      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
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
