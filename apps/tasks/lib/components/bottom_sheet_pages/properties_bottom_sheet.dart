import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_service/property.dart';
import 'package:helpwave_service/tasks.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_theme/util.dart';
import 'package:helpwave_widget/bottom_sheets.dart';
import 'package:helpwave_widget/lists.dart';
import 'package:helpwave_widget/loading.dart';
import 'package:helpwave_widget/navigation.dart';
import 'package:helpwave_widget/widgets.dart';
import 'package:tasks/components/bottom_sheet_pages/property_bottom_sheet.dart';
import '../../util/field_type_translations.dart';

/// A [BottomSheet] for showing a [Property] information
class PropertiesBottomSheet extends StatelessWidget {
  final String? wardId;

  const PropertiesBottomSheet({super.key, this.wardId});

  @override
  Widget build(BuildContext context) {
    return BottomSheetPage(
      header: BottomSheetHeader.navigation(
        context,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(context.localization!.properties, style: context.theme.textTheme.titleMedium),
            wardId == null
                ? const SizedBox()
                : LoadingFutureBuilder(
                    future: WardService().get(id: wardId!),
                    loadingWidget: const PulsingContainer(
                      width: 60,
                    ),
                    thenBuilder: (context, data) => Text(data.name, style: TextStyle(color: context.theme.hintColor)),
                  )
          ],
        ),
        trailing: BottomSheetAction(
          icon: Icons.add,
          onPressed: () {
            NavigationStackController.of(context).push(const PropertyBottomSheetPage());
          },
        ),
      ),
      child: Flexible(
        child: LoadingFutureBuilder(
          future: PropertyService().getMany(),
          thenBuilder: (context, properties) {
            return ListView(
              padding: const EdgeInsets.only(top: paddingSmall, bottom: paddingMedium),
              children: [
                RoundedListTiles(
                  children: properties
                      .map((property) => ForwardNavigationTile(
                            icon: Icons.label,
                            title: property.name,
                            subtitle: propertyFieldTypeTranslations(context, property.fieldType),
                            onTap: () {
                              NavigationStackController.of(context).push(PropertyBottomSheetPage(id: property.id));
                            },
                          ))
                      .toList(),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
