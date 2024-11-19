import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_service/tasks.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_theme/util.dart';
import 'package:helpwave_widget/bottom_sheets.dart';
import 'package:helpwave_widget/lists.dart';
import 'package:helpwave_widget/loading.dart';
import 'package:helpwave_widget/navigation.dart';
import 'package:helpwave_widget/widgets.dart';
import 'package:tasks/components/bottom_sheet_pages/task_template_bottom_sheet.dart';

class TaskTemplatesBottomSheetPage extends StatelessWidget {
  final bool isPersonal;
  final String? wardId;

  const TaskTemplatesBottomSheetPage({
    super.key,
    this.isPersonal = false,
    this.wardId,
  });

  @override
  Widget build(BuildContext context) {
    return BottomSheetPage(
      header: BottomSheetHeader.navigation(
        context,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.localization!.taskTemplates,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
            wardId == null
                ? const SizedBox()
                : LoadingFutureBuilder(
                    future: WardService().get(id: wardId ?? ""),
                    thenBuilder: (context, data) => Text(
                      data.name,
                      style: TextStyle(color: context.theme.hintColor),
                    ),
                    loadingWidget: const PulsingContainer(width: 60),
                  ),
          ],
        ),
        trailing: BottomSheetAction(
            icon: Icons.add,
            onPressed: () {
              NavigationStackController.of(context).push(TaskTemplateBottomSheetPage(
                template: TaskTemplate(
                  name: context.localization!.task,
                  wardId: wardId,
                  isPublicVisible: !isPersonal,
                ),
              ));
            }),
      ),
      child: Flexible(
        child: LoadingFutureBuilder(
          future: TaskTemplateService().getMany(wardId: wardId, privateOnly: isPersonal),
          thenBuilder: (context, data) => ListView(
            shrinkWrap: true,
            children: [
              const SizedBox(height: distanceMedium),
              RoundedListTiles(
                  children: data
                      .map(
                        (template) => ForwardNavigationTile(
                          icon: Icons.fact_check_rounded,
                          title: template.name,
                          onTap: () {
                            NavigationStackController.of(context).push(TaskTemplateBottomSheetPage(
                              templateId: template.id!,
                            ));
                          },
                        ),
                      )
                      .toList()),
            ],
          ),
        ),
      ),
    );
  }
}
