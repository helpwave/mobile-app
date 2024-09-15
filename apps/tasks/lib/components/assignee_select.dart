import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_service/tasks.dart';
import 'package:helpwave_service/user.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_widget/bottom_sheets.dart';
import 'package:helpwave_widget/loading.dart';
import 'package:provider/provider.dart';

/// A [BottomSheet] for selecting a assignee
class AssigneeSelect extends StatelessWidget {
  /// The callback when the assignee should be changed
  final Function(User assignee) onChanged;

  const AssigneeSelect({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return BottomSheetBase(
      titleText: context.localization!.assignee,
      onClosing: () => {},
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: paddingMedium),
        child: Consumer<AssigneeSelectController>(builder: (context, assigneeSelectController, __) {
          return LoadingAndErrorWidget(
            state: assigneeSelectController.state,
            child: Column(
              children: assigneeSelectController.users.map((user) =>
                 ListTile(
                  onTap: () {
                    assigneeSelectController.changeAssignee(user.id).then((value) {
                      onChanged(user);
                    });
                  },
                  leading: CircleAvatar(
                      foregroundColor: Colors.blue, backgroundImage: NetworkImage(user.profileUrl.toString())),
                  title: Text(user.nickName),
                )).toList(),
            ),
          );
        }),
      ),
    );
  }
}
