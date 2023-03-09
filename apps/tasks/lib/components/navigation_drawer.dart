import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_theme/theme.dart';
import 'package:tasks/screens/my_tasks_screen.dart';
import 'package:tasks/screens/room_overview_screen.dart';
import 'package:tasks/screens/settings_screen.dart';

/// The Navigation options the User can use
enum NavigationOptions {
  myTasks,
  roomoverview,
  settings,
}

/// A Drawer for navigating through the application
class NavigationDrawer extends StatelessWidget {
  /// The current Page the User is on
  final NavigationOptions currentPage;

  const NavigationDrawer({
    super.key,
    required this.currentPage,
  });

  /// determines the [Color] of the ListTile for the given page
  Color tileColorForPage(NavigationOptions page) {
    return currentPage == page
        ? Colors.black.withOpacity(0.2)
        : Colors.transparent;
  }

  /// Replaces the current Page with the given one with an Animation
  void pushReplace(BuildContext context, Widget newPage) async {
    // TODO fine tune here to see what kind of animation transition looks the best
    Navigator.pop(context);
    await Future.delayed(const Duration(milliseconds: 100)).then(
      (_) => Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => newPage,
          transitionsBuilder: (_, __, ___, child) {
            return child;
          },
          transitionDuration: Duration.zero,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Consumer<ThemeModel>(
              builder: (_, ThemeModel themeNotifier, __) => Image.asset(
                themeNotifier.getIsDarkNullSafe(context)
                    ? 'assets/helpwave-logo-dark.png'
                    : 'assets/helpwave-logo-light.png',
                width: iconSizeBig,
                height: iconSizeBig,
              ),
            ),
            ListTile(
              tileColor: tileColorForPage(NavigationOptions.myTasks),
              onTap: currentPage == NavigationOptions.myTasks
                  ? null
                  : () => pushReplace(context, const MyTasksScreen()),
              title: Text(context.localization!.myTasks),
            ),
            ListTile(
              tileColor: tileColorForPage(NavigationOptions.roomoverview),
              onTap: currentPage == NavigationOptions.roomoverview
                  ? null
                  : () => pushReplace(context, const RoomOverviewScreen()),
              title: Text(context.localization!.roomoverview),
            ),
            ListTile(
              tileColor: tileColorForPage(NavigationOptions.settings),
              onTap: currentPage == NavigationOptions.settings
                  ? null
                  : () => pushReplace(context, const SettingsScreen()),
              title: Text(context.localization!.settings),
            ),
            // TODO add [UserCard]
          ],
        ),
      ),
    );
  }
}
