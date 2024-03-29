import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_widget/bottom_sheets.dart';
import 'package:helpwave_widget/loading.dart';
import 'package:provider/provider.dart';
import 'package:tasks/controllers/assignee_select_controller.dart';
import 'package:tasks/dataclasses/user.dart';

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
      builder: (context) => Flexible(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: paddingMedium),
          child: Consumer<AssigneeSelectController>(builder: (context, assigneeSelectController, __) {
            return LoadingAndErrorWidget(
              state: assigneeSelectController.state,
              child: ListView.builder(
                itemCount: assigneeSelectController.users.length,
                itemBuilder: (context, index) {
                  User user = assigneeSelectController.users[index];
                  return ListTile(
                    onTap: () {
                      assigneeSelectController.changeAssignee(user.id).then((value) {
                        onChanged(user);
                      });
                    },
                    leading: CircleAvatar(
                        foregroundColor: Colors.blue, backgroundImage: NetworkImage(user.profile.toString())),
                    title: Text(user.nickName),
                  );
                },
              ),
            );
          }),
        ),
      ),
    );
  }
}
