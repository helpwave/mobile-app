import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_service/user.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_theme/util.dart';
import 'package:helpwave_widget/bottom_sheets.dart';
import 'package:helpwave_widget/lists.dart';
import 'package:helpwave_widget/loading.dart';
import 'package:helpwave_widget/text_input.dart';
import 'package:provider/provider.dart';
import 'package:tasks/screens/settings_screen.dart';

class OrganizationBottomSheetPage extends StatelessWidget {
  final String organizationId;

  const OrganizationBottomSheetPage({super.key, required this.organizationId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OrganizationController(Organization.empty(organizationId)),
      child: Consumer<OrganizationController>(builder: (context, controller, _) {
        return BottomSheetPage(
          header: BottomSheetHeader.navigation(
            context,
            title: LoadingAndErrorWidget.pulsing(
              state: controller.state,
              child: Text(controller.organization.combinedName),
            ),
          ),
          child: Flexible(
            child: LoadingAndErrorWidget(
              state: controller.state,
              child: ListView(
                children: [
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        const SizedBox(height: distanceMedium),
                        Text(context.localization!.shortName),
                        TextFormFieldWithTimer(
                          initialValue: controller.organization.shortName,
                          onUpdate: (value) => controller.update(shortName: value),
                        ),
                        const SizedBox(height: distanceMedium),
                        Text(context.localization!.longName),
                        TextFormFieldWithTimer(
                          initialValue: controller.organization.longName,
                          onUpdate: (value) => controller.update(longName: value),
                        ),
                        const SizedBox(height: distanceMedium),
                        Text(context.localization!.contactEmail),
                        TextFormFieldWithTimer(
                          initialValue: controller.organization.email,
                          // TODO validation
                          onUpdate: (value) => controller.update(email: value),
                        ),
                        const SizedBox(height: distanceMedium),
                        Text(context.localization!.settings),
                        RoundedListTiles(
                          items: [
                            NavigationListTile(
                              icon: Icons.house_rounded,
                              title: context.localization!.wards,
                              onTap: () {
                                // TODO navigate to ward page
                              },
                            ),
                            NavigationListTile(
                              icon: Icons.person,
                              title: context.localization!.members,
                              onTap: () {
                                // TODO navigate to members page
                              },
                            ),
                            NavigationListTile(
                              icon: Icons.label,
                              title: context.localization!.properties,
                              onTap: () {
                                // TODO navigate to properties page
                              },
                            )
                          ],
                        ),
                        const SizedBox(height: distanceMedium),
                        Text(context.localization!.dangerZone),
                        Text(
                          context.localization!.organizationDangerZoneDescription,
                          style: TextStyle(color: context.theme.hintColor),
                        ),
                        TextButton(
                          child: Text(
                            "${context.localization!.delete} ${context.localization!.organization}",
                            style: const TextStyle(color: Colors.red), // TODO get from theme
                          ),
                          onPressed: () {
                            // TODO show modal and delete organization
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
