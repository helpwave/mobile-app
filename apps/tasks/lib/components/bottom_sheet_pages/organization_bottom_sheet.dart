import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_service/user.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_theme/util.dart';
import 'package:helpwave_widget/bottom_sheets.dart';
import 'package:helpwave_widget/lists.dart';
import 'package:helpwave_widget/loading.dart';
import 'package:helpwave_widget/navigation.dart';
import 'package:helpwave_widget/text_input.dart';
import 'package:helpwave_widget/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tasks/components/bottom_sheet_pages/organization_members_bottom_sheet.dart';
import 'package:tasks/components/bottom_sheet_pages/properties_bottom_sheet.dart';
import 'package:tasks/components/bottom_sheet_pages/wards_bottom_sheet_page.dart';

class OrganizationBottomSheetPage extends StatelessWidget {
  final String organizationId;

  const OrganizationBottomSheetPage({super.key, required this.organizationId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OrganizationController(id: organizationId),
      child: Consumer<OrganizationController>(builder: (context, controller, _) {
        return BottomSheetPage(
          header: BottomSheetHeader.navigation(
            context,
            title: LoadingAndErrorWidget.pulsing(
              state: controller.state,
              child: Text(
                controller.data.combinedName,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
              ),
            ),
          ),
          child: Flexible(
            child: LoadingAndErrorWidget(
              state: controller.state,
              child: ListView(
                shrinkWrap: true,
                children: [
                  const SizedBox(height: distanceMedium),
                  Text(context.localization.shortName, style: context.theme.textTheme.titleMedium),
                  const SizedBox(height: distanceTiny),
                  TextFormFieldWithTimer(
                    initialValue: controller.data.shortName,
                    onUpdate: (value) => controller.update(OrganizationUpdate(shortName: value)),
                  ),
                  const SizedBox(height: distanceMedium),
                  Text(context.localization.longName, style: context.theme.textTheme.titleMedium),
                  const SizedBox(height: distanceTiny),
                  TextFormFieldWithTimer(
                    initialValue: controller.data.longName,
                    onUpdate: (value) => controller.update(OrganizationUpdate(longName: value)),
                  ),
                  const SizedBox(height: distanceMedium),
                  Text(context.localization.contactEmail, style: context.theme.textTheme.titleMedium),
                  const SizedBox(height: distanceTiny),
                  TextFormFieldWithTimer(
                    initialValue: controller.data.details?.email,
                    // TODO validation
                    onUpdate: (value) => controller.update(OrganizationUpdate(email: value)),
                  ),
                  const SizedBox(height: distanceMedium),
                  Text(context.localization.settings, style: context.theme.textTheme.titleMedium),
                  const SizedBox(height: distanceTiny),
                  RoundedListTiles(
                    children: [
                      ForwardNavigationTile(
                        icon: Icons.house_rounded,
                        title: context.localization.wards,
                        onTap: () {
                          NavigationStackController.of(context)
                              .push(WardsBottomSheetPage(organizationId: organizationId));
                        },
                      ),
                      ForwardNavigationTile(
                        icon: Icons.person,
                        title: context.localization.members,
                        onTap: () {
                          NavigationStackController.of(context)
                              .push(OrganizationMembersBottomSheetPage(organizationId: organizationId));
                        },
                      ),
                      ForwardNavigationTile(
                        icon: Icons.label,
                        title: context.localization.properties,
                        onTap: () {
                          NavigationStackController.of(context).push(const PropertiesBottomSheet());
                        },
                      )
                    ],
                  ),
                  const SizedBox(height: distanceMedium),
                  Text(context.localization.dangerZone, style: context.theme.textTheme.titleMedium),
                  Text(
                    context.localization.organizationDangerZoneDescription,
                    style: TextStyle(color: context.theme.hintColor),
                  ),
                  PressableText(
                    text: "${context.localization.delete} ${context.localization.organization}",
                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w700), // TODO get from theme
                    onPressed: () {
                      // TODO show modal and delete organization
                    },
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
