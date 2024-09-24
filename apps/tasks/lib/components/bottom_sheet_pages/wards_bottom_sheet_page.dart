import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_service/tasks.dart';
import 'package:helpwave_service/user.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_theme/util.dart';
import 'package:helpwave_widget/bottom_sheets.dart';
import 'package:helpwave_widget/lists.dart';
import 'package:helpwave_widget/loading.dart';
import 'package:tasks/screens/settings_screen.dart';

class WardsBottomSheetPage extends StatelessWidget {
  final String organizationId;

  const WardsBottomSheetPage({super.key, required this.organizationId});

  @override
  Widget build(BuildContext context) {
    return BottomSheetPage(
      header: BottomSheetHeader.navigation(
        context,
        title: LoadingFutureBuilder(
          data: OrganizationService().getOrganization(id: organizationId),
          thenWidgetBuilder: (context, data) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.localization!.wards,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
              ),
              Text(
                data.combinedName,
                style: TextStyle(color: context.theme.hintColor),
              ),
            ],
          ),
        ),
      ),
      child: Flexible(
        child: LoadingFutureBuilder(
          data: WardService().getWards(organizationId: organizationId),
          thenWidgetBuilder: (context, data) => ListView(
            children: [
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    const SizedBox(height: distanceMedium),
                    RoundedListTiles(
                        children: data
                            .map(
                              (ward) => NavigationListTile(
                                icon: Icons.house_rounded,
                                title: ward.name,
                                onTap: () {
                                  // TODO navigate to ward view
                                },
                              ),
                            )
                            .toList()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
