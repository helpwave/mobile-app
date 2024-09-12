import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/theme.dart';
import 'package:helpwave_widget/loading.dart';
import 'package:provider/provider.dart';
import 'package:tasks/components/subtask_list.dart';
import 'package:tasks/components/task_card.dart';
import 'package:helpwave_service/tasks.dart';

class ThemeVisualizer extends StatelessWidget {
  const ThemeVisualizer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.brightness_medium),
            title: Text(context.localization!.darkMode),
            trailing: Consumer<ThemeModel>(builder: (_, ThemeModel themeNotifier, __) {
              return Switch(
                value: themeNotifier.getIsDarkNullSafe(context),
                onChanged: (bool value) {
                  themeNotifier.isDark = value;
                },
              );
            }),
          ),
          Expanded(
            child: ListView(
              children: [
                const LoadingSpinner(),
                //SizedBox(width: 300, height: 400, child: SubtaskList(onChange: (_) {})),
                const Text("Text"),
                const Icon(Icons.ac_unit),
                SubtaskList(onChange: (_){}),
                TextButton(onPressed: () {}, child: const Text("TextButton")),
                ElevatedButton(onPressed: () {}, child: const Text("ElevatedButton")),
                OutlinedButton(onPressed: () {}, child: const Text("OutlinedButton")),
                TaskCard(
                  task: TaskWithPatient(
                    id: 'task',
                    name: "Task",
                    notes: "Some Notes",
                    status: TaskStatus.inProgress,
                    dueDate: DateTime.now().add(const Duration(hours: 2)),
                    patient: PatientMinimal(
                      id: "patient",
                      name: "Patient",
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(items: const [
        BottomNavigationBarItem(icon: Icon(Icons.align_horizontal_left_outlined), label: "stats"),
        BottomNavigationBarItem(icon: Icon(Icons.add), label: "add"),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "settings"),
      ]),
    );
  }
}
