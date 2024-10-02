import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_service/tasks.dart';
import 'package:helpwave_theme/util.dart';
import 'package:helpwave_util/loading.dart';
import 'package:helpwave_widget/bottom_sheets.dart';
import 'package:helpwave_widget/lists.dart';
import 'package:helpwave_widget/loading.dart';
import 'package:provider/provider.dart';
import 'package:tasks/screens/settings_screen.dart';

class RoomOverviewBottomSheetPage extends StatelessWidget {
  final String roomId;

  const RoomOverviewBottomSheetPage({super.key, required this.roomId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BedsController(roomId: roomId),
      child: BottomSheetPage(
        header: BottomSheetHeader.navigation(
          context,
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(context.localization!.rooms, style: context.theme.textTheme.titleMedium),
              LoadingFutureBuilder(
                data: RoomService().get(roomId: roomId),
                thenBuilder: (context, room) {
                  return Text(room.name, style: TextStyle(color: context.theme.hintColor));
                },
                loadingWidget: LoadingAndErrorWidget.pulsing(state: LoadingState.loading, child: SizedBox()),
              ),
            ],
          ),
        ),
        child: Flexible(
          child: ListView(
            children: [
              Consumer<BedsController>(
                builder: (context, controller, _) {
                  return LoadingAndErrorWidget(
                    state: controller.state,
                    child: RoundedListTiles(
                      children: controller.beds
                          .map(
                            (bed) => NavigationListTile(
                              icon: Icons.bed_rounded,
                              title: bed.name,
                              trailingText: bed.patient?.name ?? context.localization!.unassigned,
                              onTap: () {},
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
