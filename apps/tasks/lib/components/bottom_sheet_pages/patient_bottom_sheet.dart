import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_service/auth.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_theme/util.dart';
import 'package:helpwave_widget/bottom_sheets.dart';
import 'package:helpwave_widget/dialog.dart';
import 'package:helpwave_widget/lists.dart';
import 'package:helpwave_widget/loading.dart';
import 'package:helpwave_widget/text_input.dart';
import 'package:provider/provider.dart';
import 'package:tasks/components/bottom_sheet_pages/task_bottom_sheet.dart';
import 'package:tasks/components/task_expansion_tile.dart';
import 'package:helpwave_service/tasks.dart';
import 'package:helpwave_util/loading.dart';

/// A [BottomSheet] for showing [Patient] information and [Task]s for that [Patient]
class PatientBottomSheet extends StatefulWidget {
  /// The identifier of the [Patient]
  final String? patentId;

  const PatientBottomSheet({super.key, this.patentId});

  @override
  State<PatientBottomSheet> createState() => _PatientBottomSheetState();
}

class _PatientBottomSheetState extends State<PatientBottomSheet> {
  Future<List<RoomWithBedFlat>> loadRoomsWithBeds({String? patientId}) async {
    List<RoomWithBedWithMinimalPatient> rooms =
        await RoomService().getRoomOverviews(wardId: CurrentWardService().currentWard!.wardId);

    List<RoomWithBedFlat> flattenedRooms = [];
    for (RoomWithBedWithMinimalPatient room in rooms) {
      for (Bed bed in room.beds) {
        // TODO reconsider the filter to allow switching to bed the patient is in
        if (bed.patient == null || bed.patient?.id == patientId) {
          flattenedRooms.add(RoomWithBedFlat(room: room, bed: bed));
        }
      }
    }
    return flattenedRooms;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PatientController(id: widget.patentId),
        ),
      ],
      child: BottomSheetPage(
        header: BottomSheetHeader(
          title: Consumer<PatientController>(builder: (context, patientController, _) {
            if (patientController.state == LoadingState.loaded || patientController.isCreating) {
              return ClickableTextEdit(
                initialValue: patientController.patient.name,
                onUpdated: patientController.changeName,
                textAlign: TextAlign.center,
                textStyle: TextStyle(
                  color: context.theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: iconSizeTiny,
                  fontFamily: "SpaceGrotesk",
                  overflow: TextOverflow.ellipsis,
                ),
              );
            } else {
              return const PulsingContainer(width: 30);
            }
          }),
        ),
        bottom: Padding(
          padding: const EdgeInsets.symmetric(vertical: paddingSmall),
          child: Consumer<PatientController>(builder: (context, patientController, _) {
            return LoadingAndErrorWidget(
              state: patientController.state,
              child: Row(
                mainAxisAlignment:
                    patientController.isCreating ? MainAxisAlignment.end : MainAxisAlignment.spaceBetween,
                children: patientController.isCreating
                    ? [
                        FilledButton(
                          onPressed: patientController.create,
                          child: Text(context.localization.create),
                        )
                      ]
                    : [
                        SizedBox(
                          width: width * 0.4,
                          // TODO make this state checking easier and more readable
                          child: FilledButton(
                            onPressed: patientController.patient.isNotAssignedToBed
                                ? null
                                : () {
                                    patientController.unassign();
                                  },
                            style: buttonStyleMedium.copyWith(
                              backgroundColor: resolveByStatesAndContextBackground(
                                context: context,
                                defaultValue: inProgressColor,
                              ),
                              foregroundColor: resolveByStatesAndContextForeground(
                                context: context,
                              ),
                            ),
                            child: Text(context.localization.unassigne),
                          ),
                        ),
                        SizedBox(
                          width: width * 0.4,
                          child: FilledButton(
                            // TODO check whether the patient is active
                            onPressed: patientController.patient.isDischarged
                                ? null
                                : () {
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          AcceptDialog(titleText: context.localization.dischargePatient),
                                    ).then((value) {
                                      if (value) {
                                        patientController.discharge();
                                        if (context.mounted) {
                                          Navigator.of(context).pop();
                                        }
                                      }
                                    });
                                  },
                            style: buttonStyleMedium.copyWith(
                              backgroundColor: resolveByStatesAndContextBackground(
                                context: context,
                                defaultValue: negativeColor,
                              ),
                              foregroundColor: resolveByStatesAndContextForeground(
                                context: context,
                              ),
                            ),
                            child: Text(context.localization.discharge),
                          ),
                        ),
                      ],
              ),
            );
          }),
        ),
        child: Flexible(
          child: ListView(
            children: [
              Center(
                child: Consumer<PatientController>(builder: (context, patientController, _) {
                  return LoadingFutureBuilder(
                    future: loadRoomsWithBeds(patientId: patientController.patient.id),
                    loadingWidget: const PulsingContainer(width: 80, height: 20),
                    thenBuilder: (context, beds) {
                      if (beds.isEmpty) {
                        return Text(
                          context.localization.noFreeBeds,
                          style: TextStyle(color: context.theme.disabledColor, fontWeight: FontWeight.bold),
                        );
                      }
                      return DropdownButtonHideUnderline(
                        child: DropdownButton<RoomWithBedFlat>(
                          iconEnabledColor: context.theme.colorScheme.primary.withOpacity(0.6),
                          padding: EdgeInsets.zero,
                          isDense: true,
                          hint: Text(
                            context.localization.assignBed,
                            style: TextStyle(color: context.theme.colorScheme.primary.withOpacity(0.6)),
                          ),
                          value: beds.where((beds) => beds.bed.id == patientController.patient.bed?.id).firstOrNull,
                          items: beds
                              .map((roomWithBed) => DropdownMenuItem(
                                    value: roomWithBed,
                                    child: Text(
                                      "${roomWithBed.room.name} - ${roomWithBed.bed.name}",
                                      style: TextStyle(color: context.theme.colorScheme.primary.withOpacity(0.6)),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (RoomWithBedFlat? value) {
                            // TODO later unassign here
                            if (value == null) {
                              return;
                            }
                            patientController.assignToBed(value.room, value.bed);
                          },
                        ),
                      );
                    },
                  );
                }),
              ),
              Text(
                context.localization.notes,
                style: const TextStyle(fontSize: fontSizeBig, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: distanceSmall),
              Consumer<PatientController>(
                builder: (context, patientController, _) =>
                    patientController.state == LoadingState.loaded || patientController.isCreating
                        ? TextFormFieldWithTimer(
                            initialValue: patientController.patient.notes,
                            maxLines: 6,
                            onUpdate: patientController.changeNotes,
                          )
                        : TextFormField(maxLines: 6),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: paddingMedium),
                child: Consumer<PatientController>(builder: (context, patientController, _) {
                  Patient patient = patientController.patient;
                  return AddList(
                    maxHeight: width * 0.5,
                    items: [
                      ...patient.unscheduledTasks,
                      ...patient.inProgressTasks,
                      ...patient.doneTasks,
                    ],
                    itemBuilder: (_, index, taskList) {
                      if (index == 0) {
                        return TaskExpansionTile(
                          tasks: patient.unscheduledTasks
                              .map((task) => TaskWithPatient.fromTaskAndPatient(
                                    task: task,
                                    patient: patient,
                                  ))
                              .toList(),
                          title: context.localization.upcoming,
                          color: upcomingColor,
                        );
                      }
                      if (index == 2) {
                        return TaskExpansionTile(
                          tasks: patient.doneTasks
                              .map((task) => TaskWithPatient.fromTaskAndPatient(
                                    task: task,
                                    patient: patient,
                                  ))
                              .toList(),
                          title: context.localization.inProgress,
                          color: inProgressColor,
                        );
                      }
                      return TaskExpansionTile(
                        tasks: patient.inProgressTasks
                            .map((task) => TaskWithPatient.fromTaskAndPatient(
                                  task: task,
                                  patient: patient,
                                ))
                            .toList(),
                        title: context.localization.done,
                        color: doneColor,
                      );
                    },
                    title: Text(
                      context.localization.tasks,
                      style: const TextStyle(fontSize: fontSizeBig, fontWeight: FontWeight.bold),
                    ),
                    // TODO use return value to add it to task list or force a refetch
                    onAdd: () => context.pushModal(
                      context: context,
                      builder: (context) => TaskBottomSheet(task: Task.empty(patient.id), patient: patient),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
