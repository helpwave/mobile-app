import 'package:flutter/material.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_widget/shapes.dart';
import 'package:tasks/dataclasses/subtask.dart';
import '../dataclasses/task.dart';

class _SheetListTile extends StatelessWidget {
  final String label;
  final String name;
  final IconData icon;

  const _SheetListTile({required this.label, required this.name, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: iconSizeTiny,
        ),
        const SizedBox(width: paddingTiny),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              name,
              style: const TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        )
      ],
    );
  }
}

class TaskBottomSheet extends StatefulWidget {
  final Task task;

  const TaskBottomSheet({super.key, required this.task});

  @override
  State<StatefulWidget> createState() => _TaskBottomSheetState();
}

class _TaskBottomSheetState extends State<TaskBottomSheet> {
  @override
  Widget build(BuildContext context) {
    const double subtaskAddIconSize = 21;

    return Padding(
      padding: const EdgeInsets.all(paddingSmall),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                constraints: const BoxConstraints(maxWidth: iconSizeTiny, maxHeight: iconSizeTiny),
                padding: EdgeInsets.zero,
                iconSize: iconSizeTiny,
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: paddingSmall),
                  child: Text(
                    widget.task.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: iconSizeTiny,
                      fontFamily: "SpaceGrotesk",
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              IconButton(
                constraints: const BoxConstraints(maxWidth: iconSizeTiny, maxHeight: iconSizeTiny),
                padding: EdgeInsets.zero,
                iconSize: iconSizeTiny,
                onPressed: () => {},
                icon: const Icon(Icons.edit),
              ),
            ],
          ),
          Center(
            child: DropdownButton(
              underline: const SizedBox(),
              // removes the default underline
              padding: EdgeInsets.zero,
              isDense: true,
              // TODO use the full list of possible assignees
              items: const [
                DropdownMenuItem(value: 1, child: Text("Victoria Schäfer")),
                DropdownMenuItem(value: 2, child: Text("User 1")),
                DropdownMenuItem(value: 3, child: Text("User 2")),
                DropdownMenuItem(value: 4, child: Text("User 3")),
                DropdownMenuItem(value: 5, child: Text("User 4")),
                DropdownMenuItem(value: 6, child: Text("User 5")),
                DropdownMenuItem(value: 7, child: Text("User 6")),
              ],
              value: 1,
              onChanged: (value) {
                // TODO change selected item
              },
            ),
          ),
          const SizedBox(
            height: distanceSmall,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // TODO change static assignee name
              _SheetListTile(icon: Icons.person, label: "Assigned to", name: "Assignee"),
              _SheetListTile(icon: Icons.access_time, label: "Due", name: "27. Juni"),
            ],
          ),
          const SizedBox(height: distanceSmall),
          const _SheetListTile(icon: Icons.lock, label: "Visibility", name: "Private"),
          const SizedBox(height: distanceSmall),
          const Text(
            "Notes",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: distanceTiny),
          const TextField(
            maxLines: 6,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: paddingSmall, vertical: paddingSmall),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1.0,
                ),
              ),
              hintText: 'Your Notes',
            ),
          ),
          const SizedBox(height: distanceMedium),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Subtasks",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Circle(
                color: primaryColor,
                diameter: subtaskAddIconSize,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: subtaskAddIconSize,
                  onPressed: () {
                    // TODO add add Feature
                  },
                  icon: const Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Flexible(
            child: ListView(
                children: (widget.task.subtasks + [SubTask(id: "1", name: "Subtask", isDone: true)])
                    .map(
                      (subtask) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(subtask.name),
                        leading: Checkbox(
                          visualDensity: VisualDensity.compact,
                          value: subtask.isDone,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(iconSizeSmall),
                          ),
                          onChanged: (value) {
                            // TODO handle change
                          },
                        ),
                        trailing: GestureDetector(
                          onTap: () {
                            // TODO add delete
                          },
                          child: const Text(
                            "Delete",
                            style: TextStyle(color: negativeColor),
                          ),
                        ),
                      ),
                    )
                    .toList()),
          ),
        ],
      ),
    );
  }
}
