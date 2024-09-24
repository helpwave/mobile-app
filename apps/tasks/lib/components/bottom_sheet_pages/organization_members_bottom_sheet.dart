import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_service/auth.dart';
import 'package:helpwave_service/user.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_theme/util.dart';
import 'package:helpwave_widget/bottom_sheets.dart';
import 'package:helpwave_widget/lists.dart';
import 'package:helpwave_widget/loading.dart';
import 'package:provider/provider.dart';

class OrganizationMembersBottomSheetPage extends StatelessWidget {
  final String organizationId;

  const OrganizationMembersBottomSheetPage({super.key, required this.organizationId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OrganizationMemberController(organizationId),
      child: BottomSheetPage(
        header: BottomSheetHeader.navigation(
          context,
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(context.localization!.members, style: context.theme.textTheme.titleMedium),
              Text(CurrentWardService().currentWard?.organizationName ?? "",
                  style: TextStyle(color: context.theme.hintColor)),
            ],
          ),
          trailing: BottomSheetAction(
            icon: Icons.add,
            onPressed: () {
              // TODO show dialog
            },
          ),
        ),
        child: Flexible(
          child: ListView(
            children: [
              Consumer<OrganizationMemberController>(builder: (context, controller, child) {
                return LoadingAndErrorWidget(
                  state: controller.state,
                  child: RoundedListTiles(
                    children: controller.members
                        .map(
                          (member) => ListTile(
                            leading: Icon(
                              Icons.person_rounded,
                              color: context.theme.colorScheme.primary,
                            ),
                            title: Text(member.name, style: const TextStyle(fontWeight: FontWeight.w700),),
                            subtitle: Text(member.email, style: TextStyle(color: context.theme.hintColor),),
                            trailing: IconButton(
                              onPressed: () {
                                controller.removeMember(organizationId: organizationId, userId: member.id);
                              },
                              icon: const Icon(
                                Icons.remove,
                                color: Colors.red, // TODO use theme
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                );
              }),
              Padding(
                padding: const EdgeInsets.only(top: distanceMedium, bottom: distanceTiny),
                child: Text(
                  context.localization!.invitations,
                  style: context.theme.textTheme.titleMedium,
                ),
              ),
              Consumer<OrganizationMemberController>(builder: (context, controller, child) {
                return LoadingAndErrorWidget(
                  state: controller.state,
                  child: RoundedListTiles(
                    children: controller.invitations
                        .map(
                          (invitation) => ListTile(
                            leading: Icon(
                              Icons.email_rounded,
                              color: context.theme.colorScheme.primary,
                            ),
                            title: Text(invitation.email),
                            trailing: IconButton(
                              onPressed: () {
                                controller.revokeInvitation(invitationId: invitation.id);
                              },
                              icon: const Icon(
                                Icons.remove,
                                color: Colors.red, // TODO use theme
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
