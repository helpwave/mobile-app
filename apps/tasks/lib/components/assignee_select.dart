import 'dart:async';
import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_service/user.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_widget/bottom_sheets.dart';
import 'package:helpwave_widget/content_selection.dart';

/// A [BottomSheet] for selecting a assignee
class AssigneeSelectBottomSheet extends StatelessWidget {
  /// The callback when the assignee should be changed
  ///
  /// Null if the assignee should be removed
  final Function(User? assignee) onChanged;

  final FutureOr<List<User>> users;

  final String? selectedId;

  const AssigneeSelectBottomSheet({super.key, required this.onChanged, required this.users, this.selectedId});

  @override
  Widget build(BuildContext context) {
    return BottomSheetBase(
      titleText: context.localization!.assignee,
      onClosing: () => {},
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: paddingMedium),
        child: Column(
          children: [
            TextButton(
              child: Text(context.localization!.remove),
              onPressed: () => onChanged(null),
            ),
            const SizedBox(height: 10),
            ListSelect(
              items: users,
              onSelect: onChanged,
              builder: (context, user, select) => ListTile(
                onTap: select,
                leading: CircleAvatar(
                    foregroundColor: Colors.blue, backgroundImage: NetworkImage(user.profileUrl.toString())),
                title: Text(user.nickName,
                    style: TextStyle(decoration: user.id == selectedId ? TextDecoration.underline : null)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
