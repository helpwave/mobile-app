import 'package:flutter/material.dart';
import 'package:tasks/components/navigation_drawer.dart';
import 'package:tasks/components/task_list_tile.dart';
import 'package:helpwave_localization/localization.dart';

/// The Screen for showing all [Task]'s the [User] has in the current [ ]
class MyTasksScreen extends StatefulWidget{
  const MyTasksScreen({super.key});

  @override
  State<MyTasksScreen> createState() => _MyTasksScreenState();
}

class _MyTasksScreenState extends State<MyTasksScreen> {

  // TODO replace with API-Call here
  final List<TaskDTO> _items = [
    TaskDTO(
        title: "Blut entnahme",
        subTitle: "Blutwerte aus dem Labor prüfen",
        progress: 0.75,
        statusColor: Colors.yellow),
    TaskDTO(
        title: "Raum reinigen",
        subTitle: "Verdacht auf Corona-Patient",
        progress: 0.10,
        statusColor: Colors.red),
    TaskDTO(
        isChecked: true,
        title: "Labore sichten",
        subTitle: "Sind Erythrozyten aufällig?",
        progress: 1.0,
        statusColor: Colors.green),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const TasksNavigationDrawer(
          currentPage: NavigationOptions.myTasks,
        ),
        appBar: AppBar(title: Text(context.localization!.myTasks),),
        body: ReorderableListView(
              buildDefaultDragHandles: false,
              children: [
                for (int index = 0; index < _items.length; index += 1)
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                            top: Divider.createBorderSide(context)
                        )
                    ),
                    key: ValueKey(_items[index]),
                    child: TaskListTile(
                      index: index,
                      task: _items[index],
                    ),
                  )
              ],
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final item = _items.removeAt(oldIndex);
                  _items.insert(newIndex, item);
                });
              },
        )
    );
  }
}
