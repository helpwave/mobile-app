import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:tasks/screens/settings_screen.dart';

/// A Screen where the user get the opportunity to create a [Task] or [Patient]
class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<StatefulWidget> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
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
      floatingActionButton: _TaskPatientFloatingActionButton(),
      body: Center(
        child: Text(context.localization!.create),
      ),
    );
  }
}

class _TaskPatientFloatingActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double chipWidth = 50;
    double chipHeight = 25;
    double componentHeight = chipHeight + 2 * paddingSmall;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(componentHeight / 2),
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
              onPressed: () {},
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
      ),
    );
  }
}
