import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_service/tasks.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_theme/util.dart';
import 'package:helpwave_util/loading.dart';
import 'package:helpwave_widget/bottom_sheets.dart';
import 'package:helpwave_widget/lists.dart';
import 'package:helpwave_widget/loading.dart';
import 'package:helpwave_widget/text_input.dart';
import 'package:provider/provider.dart';

class RoomOverviewBottomSheetPage extends StatelessWidget {
  final String roomId;

  const RoomOverviewBottomSheetPage({super.key, required this.roomId});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BedsController(roomId: roomId)),
        ChangeNotifierProvider(create: (context) => RoomController(roomId: roomId)),
      ],
      child: BottomSheetPage(
        header: BottomSheetHeader.navigation(
          context,
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(context.localization!.rooms, style: context.theme.textTheme.titleMedium),
              Consumer<RoomController>(builder: (context, controller, child) {
                return LoadingAndErrorWidget(
                  state: controller.state,
                  loadingWidget: const PulsingContainer(width: 80),
                  child: Text(controller.room.name, style: TextStyle(color: context.theme.hintColor)),
                );
              }),
            ],
          ),
        ),
        child: Flexible(
          child: ListView(
            children: [
              Consumer<RoomController>(
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
                          initialValue: controller.state == LoadingState.loaded ? controller.room.name : "",
                          onUpdate: (value) => controller.update(name: value),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: distanceMedium),
              Text(context.localization!.beds, style: context.theme.textTheme.titleSmall),
              const SizedBox(height: distanceTiny),
              Consumer<BedsController>(
                builder: (context, controller, _) {
                  return LoadingAndErrorWidget(
                    state: controller.state,
                    child: RoundedListTiles(
                      children: controller.beds
                          .map(
                            (bed) => ListTile(
                              leading: const Icon(Icons.bed_rounded),
                              title: Text(bed.name),
                              trailing: Text(bed.patient?.name ?? context.localization!.unassigned),
                            ),
                          )
                          .toList(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
