import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_widget/bottom_sheets.dart';
import 'package:tasks/dataclasses/user.dart';

/// A [BottomSheet] for selecting a assignee
class AssigneeSelect extends StatelessWidget {
  /// The selected assignee
  final String selected;

  /// The callback when the assignee should be changed
  final Function(User assignee) onChanged;

  const AssigneeSelect({super.key, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    // TODO replace by controller with GRPC request
    List<User> users = [
      User(id: "user1", name: "User 1", profile: Uri.parse("uri")),
      User(id: "user2", name: "User 2", profile: Uri.parse("uri")),
      User(id: "user3", name: "User 3", profile: Uri.parse("uri")),
      User(id: "user4", name: "User 4", profile: Uri.parse("uri")),
      User(id: "user5", name: "User 5", profile: Uri.parse("uri")),
    ];

    return BottomSheetBase(
      titleText: context.localization!.assignee,
      onClosing: () => {},
      builder: (context) => Flexible(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: paddingMedium),
          child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              User user = users[index];
              return ListTile(
                onTap: () {
                  // TODO make update request here
                  onChanged(user);
                  Navigator.pop(context);
                },
                // TODO change to network image later when uris are valid
                leading: const CircleAvatar(foregroundColor: Colors.blue),
                title: Text(user.name),
              );
            },
          ),
        ),
      ),
    );
  }
}
