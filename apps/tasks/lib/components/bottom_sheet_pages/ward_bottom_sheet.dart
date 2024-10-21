import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_service/tasks.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_theme/util.dart';
import 'package:helpwave_util/loading.dart';
import 'package:helpwave_widget/bottom_sheets.dart';
import 'package:helpwave_widget/lists.dart';
import 'package:helpwave_widget/loading.dart';
import 'package:helpwave_widget/navigation.dart';
import 'package:helpwave_widget/text_input.dart';
import 'package:helpwave_widget/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tasks/components/bottom_sheet_pages/properties_bottom_sheet.dart';
import 'package:tasks/components/bottom_sheet_pages/rooms_bottom_sheet.dart';
import 'package:tasks/components/bottom_sheet_pages/task_templates_bottom_sheet.dart';
import 'package:tasks/screens/settings_screen.dart';

class WardBottomSheetPage extends StatelessWidget {
  final String wardId;

  const WardBottomSheetPage({super.key, required this.wardId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WardController(wardId: wardId),
      child: BottomSheetPage(
        header: BottomSheetHeader.navigation(
          context,
          title: Consumer<WardController>(
            builder: (context, controller, _) {
              return LoadingAndErrorWidget(
                loadingWidget: const PulsingContainer(height: 20),
                state: controller.state,
                child: Text(
                  controller.ward.name,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
              );
            },
          ),
        ),
        child: Flexible(
          child: ListView(
            shrinkWrap: true,
            children: [
              Consumer<WardController>(
                builder: (context, controller, child) {
                  return LoadingAndErrorWidget(
                    state: controller.state,
                    loadingWidget: const PulsingContainer(height: 80),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.localization!.name, style: context.theme.textTheme.titleSmall),
                        const SizedBox(height: distanceTiny),
                        TextFormFieldWithTimer(
                          initialValue: controller.state == LoadingState.loaded ? controller.ward.name : "",
                          onUpdate: (value) => controller.update(name: value),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: distanceMedium),
              Text(context.localization!.settings, style: context.theme.textTheme.titleMedium),
              const SizedBox(height: distanceTiny),
              RoundedListTiles(
                children: [
                  NavigationListTile(
                    icon: Icons.house_rounded,
                    title: context.localization!.rooms,
                    onTap: () {
                      NavigationStackController.of(context).push(RoomsBottomSheetPage(wardId: wardId));
                    },
                  ),
                  NavigationListTile(
                    icon: Icons.checklist_rounded,
                    title: context.localization!.taskTemplates,
                    onTap: () {
                      NavigationStackController.of(context).push(TaskTemplatesBottomSheetPage(wardId: wardId));
                    },
                  ),
                  NavigationListTile(
                    icon: Icons.label,
                    title: context.localization!.properties,
                    onTap: () {
                      NavigationStackController.of(context).push(PropertiesBottomSheet(wardId: wardId));
                    },
                  )
                ],
              ),
              const SizedBox(height: distanceMedium),
              Text(context.localization!.dangerZone, style: context.theme.textTheme.titleMedium),
              Text(
                context.localization!.organizationDangerZoneDescription,
                style: TextStyle(color: context.theme.hintColor),
              ),
              PressableText(
                text: "${context.localization!.delete} ${context.localization!.organization}",
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
  }
}
