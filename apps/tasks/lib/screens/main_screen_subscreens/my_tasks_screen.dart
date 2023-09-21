import 'package:flutter/material.dart';
import 'package:helpwave_theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:tasks/screens/settings_screen.dart';

/// The Screen for showing all [Task]'s the [User] has in the current [ ]
class MyTasksScreen extends StatefulWidget {
  const MyTasksScreen({super.key});

  @override
  State<MyTasksScreen> createState() => _MyTasksScreenState();
}

class _MyTasksScreenState extends State<MyTasksScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (BuildContext context, ThemeModel themeNotifier, _) =>
        Scaffold(
          appBar: AppBar(
            title: Text(context.localization!.myTasks),
            actions: [
              IconButton(
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
          body: Center(child: Text(context.localization!.myTasks)),
        )
    );
  }
}
