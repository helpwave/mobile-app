import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_service/property.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_theme/util.dart';
import 'package:helpwave_widget/bottom_sheets.dart';
import 'package:helpwave_widget/lists.dart';
import 'package:helpwave_widget/loading.dart';
import 'package:helpwave_widget/text_input.dart';
import 'package:provider/provider.dart';
import 'package:tasks/util/field_type_translations.dart';

import '../../util/subject_type_translations.dart';

class PropertyBottomSheetPage extends StatelessWidget {
  final String? id;

  const PropertyBottomSheetPage({super.key, this.id});

  @override
  Widget build(BuildContext context) {
    InputDecoration inputDecoration = InputDecoration(
        border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadiusMedium),
    ));

    String createTitle = "${context.localization!.create} ${context.localization!.property}";
    String editTitle = context.localization!.editProperty;

    return ChangeNotifierProvider(
      create: (context) => PropertyController(id: id),
      child: BottomSheetPage(
        header: BottomSheetHeader.navigation(
          context,
          title: Consumer<PropertyController>(
            builder: (context, controller, _) => LoadingAndErrorWidget(
              state: controller.state,
              loadingWidget: const PulsingContainer(width: 50),
              child: Text(controller.property.isCreating ? createTitle : editTitle,
                  style: context.theme.textTheme.titleMedium),
            ),
          ),
        ),
        child: Flexible(
          child: Consumer<PropertyController>(
            builder: (context, controller, _) => LoadingAndErrorWidget(
              state: controller.state,
              child: ListView(
                children: [
                  Text(
                    context.localization!.basic,
                    style: context.theme.textTheme.titleMedium?.copyWith(
                      color: context.theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: paddingSmall),
                  Text(
                    context.localization!.name,
                    style: context.theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: paddingTiny),
                  TextFormFieldWithTimer(
                    initialValue: controller.property.name,
                    onUpdate: (value) => controller.update(PropertyUpdate(name: value)),
                  ),
                  const SizedBox(height: paddingSmall),
                  Text(
                    context.localization!.subjectType,
                    style: context.theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: paddingTiny),
                  DropdownButtonFormField(
                    decoration: inputDecoration,
                    value: controller.property.subjectType,
                    items: PropertySubjectType.values
                        .map((value) => DropdownMenuItem(
                              value: value,
                              child: Text(propertySubjectTypeTranslations(context, value)),
                            ))
                        .toList(),
                    onChanged: (value) => controller.update(PropertyUpdate(subjectType: value)),
                  ),
                  const SizedBox(height: paddingSmall),
                  Text(
                    context.localization!.description,
                    style: context.theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: paddingTiny),
                  TextFormFieldWithTimer(
                    initialValue: controller.property.description,
                    onUpdate: (value) => controller.update(PropertyUpdate(description: value)),
                    maxLines: 5,
                  ),
                  const SizedBox(height: paddingMedium),
                  // Field section
                  Text(
                    context.localization!.field,
                    style: context.theme.textTheme.titleMedium?.copyWith(
                      color: context.theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: paddingSmall),
                  Text(
                    "${context.localization!.field} ${context.localization!.type}",
                    style: context.theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: paddingTiny),
                  DropdownButtonFormField(
                    decoration: inputDecoration,
                    value: controller.property.fieldType,
                    items: PropertyFieldType.values
                        .map((value) => DropdownMenuItem(
                              value: value,
                              child: Text(propertyFieldTypeTranslations(context, value)),
                            ))
                        .toList(),
                    onChanged: (value) => controller.update(PropertyUpdate(fieldType: value)),
                  ),
                  Visibility(
                      visible: controller.property.isSelectType,
                      child: Column(
                        children: [
                          const SizedBox(height: paddingSmall),
                          RoundedListTiles(
                            children: [
                              ExpansionTile(
                                shape: const Border(),
                                title: Text(
                                    "${controller.property.selectData?.options.length} ${context.localization!.options}"),
                                children: (controller.property.selectData?.options ?? [])
                                    .map((selectOption) => ListTile(title: Text(selectOption.name)))
                                    .toList(),

                              ),
                            ],
                          ),
                          // TODO select option list
                          const SizedBox(height: paddingSmall),
                          RoundedListTiles(
                            children: [
                              ListTile(
                                title: Text(
                                  context.localization!.allowCustomValues,
                                  style: context.theme.textTheme.titleSmall,
                                ),
                                subtitle: Text(
                                  context.localization!.allowCustomValuesDescription,
                                  style: TextStyle(color: context.theme.hintColor),
                                ),
                                trailing: Switch(
                                  value: controller.property.selectData?.isAllowingFreeText ?? false,
                                  onChanged: (value) => controller.update(PropertyUpdate(
                                    selectDataUpdate: (
                                      isAllowingFreeText: value,
                                      options: controller.property.selectData!.options,
                                      removeOptions: null,
                                      upsert: null
                                    ),
                                  )),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                  const SizedBox(height: paddingMedium),
                  // Rules
                  Text(
                    context.localization!.rules,
                    style: context.theme.textTheme.titleMedium?.copyWith(
                      color: context.theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: paddingSmall),
                  Text(
                    context.localization!.importance,
                    style: context.theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: paddingTiny),
                  RoundedListTiles(
                    children: [
                      ListTile(
                        title: Text(
                          context.localization!.alwaysVisible,
                          style: context.theme.textTheme.titleSmall,
                        ),
                        subtitle: Text(
                          context.localization!.alwaysVisibleDescription,
                          style: TextStyle(color: context.theme.hintColor),
                        ),
                        trailing: Switch(
                          value: controller.property.alwaysIncludeForViewSource ?? false,
                          onChanged: (value) => controller.update(PropertyUpdate(alwaysIncludeForViewSource: value)),
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: controller.property.isCreating,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: paddingMedium),
                          child: FilledButton(
                            onPressed: () => controller.create(),
                            child: Text(
                              context.localization!.create,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
