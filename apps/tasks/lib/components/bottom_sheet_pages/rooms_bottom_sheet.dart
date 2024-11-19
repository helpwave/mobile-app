import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_service/tasks.dart';
import 'package:helpwave_theme/util.dart';
import 'package:helpwave_widget/bottom_sheets.dart';
import 'package:helpwave_widget/lists.dart';
import 'package:helpwave_widget/loading.dart';
import 'package:helpwave_widget/navigation.dart';
import 'package:helpwave_widget/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tasks/components/bottom_sheet_pages/room_overview_bottom_sheet.dart';

class RoomsBottomSheetPage extends StatelessWidget {
  final String wardId;

  const RoomsBottomSheetPage({super.key, required this.wardId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RoomsController(wardId: wardId),
      child: Consumer<RoomsController>(
        builder: (context, controller, _) {
          return BottomSheetPage(
            header: BottomSheetHeader.navigation(
              context,
              title: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(context.localization!.rooms, style: context.theme.textTheme.titleMedium),
                  LoadingFutureBuilder(
                    future: WardService().get(id: wardId),
                    loadingWidget: const PulsingContainer(width: 50),
                    thenBuilder: (context, ward) {
                      return Text(ward.name, style: TextStyle(color: context.theme.hintColor));
                    },
                  ),
                ],
              ),
              trailing: BottomSheetAction(
                icon: Icons.add,
                onPressed: () {
                  controller
                      .create(RoomWithBedWithMinimalPatient(id: "", name: context.localization!.newRoom, beds: []));
                },
              ),
            ),
            child: Flexible(
              child: ListView(
                children: [
                  LoadingAndErrorWidget(
                    state: controller.state,
                    loadingWidget: const PulsingContainer(height: 300),
                    child: RoundedListTiles(
                      children: controller.rooms
                          .map(
                            (room) => ForwardNavigationTile(
                              icon: Icons.meeting_room_rounded,
                              title: room.name,
                              trailingText: "${room.beds.length} ${context.localization!.beds}",
                              onTap: () {
                                NavigationStackController.of(context)
                                    .push(RoomOverviewBottomSheetPage(roomId: room.id));
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
