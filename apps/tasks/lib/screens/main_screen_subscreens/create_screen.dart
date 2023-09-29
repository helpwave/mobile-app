import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:tasks/components/task_bottom_sheet.dart';
import 'package:tasks/dataclasses/task.dart';
import 'package:tasks/screens/settings_screen.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<StatefulWidget> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  double chipWidth = 50;
  double chipHeight = 25;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.localization!.create),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: primaryColor,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: paddingSmall),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ActionChip(
                  label: SizedBox(
                    width: chipWidth,
                    height: chipHeight,
                    child: Center(child: Text(context.localization!.task)),
                  ),
                  onPressed: () {
                    showModalBottomSheet(context: context, builder: (context) => TaskBottomSheet(task: Task.empty),);
                  },
                ),
                const SizedBox(
                  width: distanceSmall,
                ),
                ActionChip(
                  label: SizedBox(
                    width: chipWidth,
                    height: chipHeight,
                    child: Center(child: Text(context.localization!.patient)),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          )),
      body: Center(child: Text(context.localization!.create)),
    );
  }
}
