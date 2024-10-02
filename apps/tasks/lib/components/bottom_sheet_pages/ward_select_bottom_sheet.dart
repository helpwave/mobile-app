import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_service/auth.dart';
import 'package:helpwave_service/tasks.dart';
import 'package:helpwave_widget/bottom_sheets.dart';
import 'package:helpwave_widget/loading.dart';

class WardSelectBottomSheet extends StatelessWidget {
  /// The currently selected [WardMinimal]
  ///
  /// This is used to highlight the [WardMinimal] in the [List]
  final String? selectedWardId;

  /// The [Organization] identifier for which all [WardMinimal]s are loaded
  ///
  /// If unspecified the organizationId of the [CurrentWardService] is taken
  final String? organizationId;

  final void Function(WardMinimal ward) onChange;

  const WardSelectBottomSheet({super.key, this.selectedWardId, this.organizationId, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return BottomSheetBase(
      onClosing: () {},
      header: BottomSheetHeader(titleText: context.localization!.selectWard),
      mainAxisSize: MainAxisSize.min,
      child: LoadingFutureBuilder(
        loadingWidget: const SizedBox(),
        data: WardService().getWards(organizationId: organizationId),
        thenBuilder: (context, wards) {
          return Flexible(
            child: ListView(
              shrinkWrap: true,
              children: wards
                  .map((ward) => ListTile(
                        onTap: () => onChange(ward),
                        title: Text(
                          ward.name,
                          style: TextStyle(decoration: ward.id == selectedWardId ? TextDecoration.underline : null),
                        ),
                      ))
                  .toList(),
            ),
          );
        },
      ),
    );
  }
}
