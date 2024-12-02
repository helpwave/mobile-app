import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_service/tasks.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_theme/util.dart';
import 'package:helpwave_util/lists.dart';
import 'package:helpwave_widget/bottom_sheets.dart';
import 'package:helpwave_widget/lists.dart';
import 'package:helpwave_widget/loading.dart';
import 'package:helpwave_widget/navigation.dart';
import 'package:helpwave_widget/shapes.dart';
import 'package:helpwave_widget/text_input.dart';
import 'package:provider/provider.dart';

import '../subtask_list.dart';

class TaskTemplateBottomSheetPage extends StatelessWidget {
  final TaskTemplate? template;
  final String? templateId;

  const TaskTemplateBottomSheetPage({
    super.key,
    this.templateId,
    this.template,
  }) : assert(templateId != null || template != null, "either template or templateId must be provided");

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskTemplateController(
        templateId: templateId,
        taskTemplate: templateId == null ? template : null,
      ),
      builder: (context, _) => BottomSheetPage(
        header: Consumer<TaskTemplateController>(builder: (context, controller, _) {
          return BottomSheetHeader.navigation(
            context,
            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LoadingAndErrorWidget(
                  state: controller.state,
                  loadingWidget: const PulsingContainer(width: 60),
                  child: Text(
                    controller.taskTemplate.name,
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                ),
                controller.taskTemplate.wardId != null
                    ? LoadingFutureBuilder(
                        future: WardService().get(id: controller.taskTemplate.wardId!),
                        thenBuilder: (context, data) => Text(
                          data.name,
                          style: TextStyle(color: context.theme.hintColor),
                        ),
                        loadingWidget: const PulsingContainer(width: 60, height: 40),
                        errorWidget: LoadErrorWidget(
                          errorText: controller.error.toString(),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
            trailing: controller.isCreating
                ? BottomSheetAction(
                    icon: Icons.check,
                    onPressed: () {
                      controller.create().then((_) {
                        if(context.mounted){
                          NavigationStackController.of(context).pop();
                        }
                      });
                    },
                  )
                : null, // TODO consider screen for using task template
          );
        }),
        child: Flexible(
          child: Consumer<TaskTemplateController>(
            builder: (context, controller, child) {
              return LoadingAndErrorWidget(
                state: controller.state,
                child: ListView(
                  children: [
                    Text(context.localization.name, style: context.theme.textTheme.titleSmall),
                    const SizedBox(height: distanceTiny),
                    TextFormFieldWithTimer(
                      initialValue: controller.taskTemplate.name,
                      onUpdate: (value) => controller.update(name: value),
                    ),
                    const SizedBox(height: distanceMedium),
                    Text(context.localization.notes, style: context.theme.textTheme.titleSmall),
                    const SizedBox(height: distanceTiny),
                    TextFormFieldWithTimer(
                      initialValue: controller.taskTemplate.description,
                      onUpdate: (value) => controller.update(description: value),
                      maxLines: 6,
                      decoration:
                          InputDecoration(hintText: "${context.localization.add} ${context.localization.notes}"),
                    ),
                    const SizedBox(height: distanceMedium),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(context.localization.subtasks, style: context.theme.textTheme.titleSmall),
                        TextButton(
                          onPressed: () {
                            controller.createSubtask(TaskTemplateSubtask(
                              templateId: controller.templateId,
                              name: context.localization.subtask,
                            ));
                          },
                          child: Text("+ ${context.localization.add} ${context.localization.subtask}"),
                        ),
                      ],
                    ),
                    const SizedBox(height: distanceTiny),
                    RoundedListTiles(
                      children: controller.taskTemplate.subtasks.mapWithIndex(
                        (subtask, index) => ListTile(
                          leading: Circle(diameter: 16, color: context.theme.colorScheme.primary),
                          title: Text(subtask.name),
                          onTap: () {
                            showDialog<String>(
                                context: context,
                                builder: (context) => SubTaskChangeDialog(initialName: subtask.name)).then((value) {
                              if (value != null) {
                                controller.updateSubtaskByIndex(index: index, name: value);
                              }
                            });
                          },
                          trailing: IconButton(
                            onPressed: () {
                              controller.deleteSubtaskByIndex(index: index);
                            },
                            // TODO get color from theme
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
