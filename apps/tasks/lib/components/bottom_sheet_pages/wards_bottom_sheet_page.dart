import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_service/tasks.dart';
import 'package:helpwave_service/user.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_theme/util.dart';
import 'package:helpwave_widget/bottom_sheets.dart';
import 'package:helpwave_widget/lists.dart';
import 'package:helpwave_widget/loading.dart';
import 'package:helpwave_widget/navigation.dart';
import 'package:helpwave_widget/widgets.dart';
import 'package:tasks/components/bottom_sheet_pages/ward_bottom_sheet.dart';

class WardsBottomSheetPage extends StatelessWidget {
  final String organizationId;

  const WardsBottomSheetPage({super.key, required this.organizationId});

  @override
  Widget build(BuildContext context) {
    return BottomSheetPage(
      header: BottomSheetHeader.navigation(
        context,
        title: LoadingFutureBuilder(
          future: OrganizationService().getOrganization(id: organizationId),
          thenBuilder: (context, data) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.localization.wards,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
              ),
              Text(
                data.combinedName,
                style: TextStyle(color: context.theme.hintColor),
              ),
            ],
          ),
          loadingWidget: const PulsingContainer(width: 60, height: 40),
        ),
        trailing: BottomSheetAction(
            icon: Icons.add,
            onPressed: () {
              NavigationStackController.of(context).push(const WardBottomSheetPage());
            }),
      ),
      child: Flexible(
        child: LoadingFutureBuilder(
          future: WardService().getWards(organizationId: organizationId),
          thenBuilder: (context, data) {
            return ListView(
              shrinkWrap: true,
              children: [
                const SizedBox(height: distanceMedium),
                RoundedListTiles(
                    children: data
                        .map(
                          (ward) => ForwardNavigationTile(
                            icon: Icons.house_rounded,
                            title: ward.name,
                            onTap: () {
                              NavigationStackController.of(context).push(WardBottomSheetPage(wardId: ward.id));
                            },
                          ),
                        )
                        .toList()),
              ],
            );
          },
        ),
      ),
    );
  }
}
