import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_theme/util.dart';
import 'package:helpwave_widget/bottom_sheets.dart';
import 'package:helpwave_widget/dialog.dart';
import 'package:helpwave_widget/lists.dart';
import 'package:helpwave_widget/loading.dart';
import 'package:helpwave_widget/text_input.dart';
import 'package:provider/provider.dart';
import 'package:tasks/components/task_bottom_sheet.dart';
import 'package:tasks/components/task_expansion_tile.dart';
import 'package:tasks/controllers/patient_controller.dart';
import 'package:tasks/controllers/ward_patients_controller.dart';
import 'package:tasks/dataclasses/bed.dart';
import 'package:tasks/dataclasses/patient.dart';
import 'package:tasks/dataclasses/room.dart';
import 'package:tasks/dataclasses/task.dart';
import 'package:tasks/services/current_ward_svc.dart';
import 'package:tasks/services/room_svc.dart';

/// A [BottomSheet] for showing [Patient] information and [Task]s for that [Patient]
class PatientBottomSheet extends StatefulWidget {
  /// The identifier of the [Patient]
  final String patentId;

  const PatientBottomSheet({Key? key, required this.patentId}) : super(key: key);

  @override
  State<PatientBottomSheet> createState() => _PatientBottomSheetState();
}

class _PatientBottomSheetState extends State<PatientBottomSheet> {
  Future<List<RoomWithBedFlat>> loadRoomsWithBeds(String patientId) async {
    List<RoomWithBedWithMinimalPatient> rooms =
        await RoomService().getRoomOverviews(wardId: CurrentWardService().currentWard!.wardId);

    List<RoomWithBedFlat> flattenedRooms = [];
    for (RoomWithBedWithMinimalPatient room in rooms) {
      for (BedWithMinimalPatient bed in room.beds) {
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
          create: (_) => PatientController(Patient.empty(id: widget.patentId)),
        ),
        ChangeNotifierProvider(
          create: (_) => WardPatientsController(),
        ),
      ],
      child: BottomSheetBase(
        title: Consumer<PatientController>(builder: (context, patientController, _) {
          if (patientController.state == LoadingState.loaded || patientController.isCreating) {
            return ClickableTextEdit(
              initialValue: patientController.patient.name,
              onUpdated: patientController.changeName,
              textAlign: TextAlign.center,
              textStyle: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
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
        onClosing: () {
          // TODO handle this
        },
        bottomWidget: Padding(
          padding: const EdgeInsets.only(top: paddingMedium),
          child: Consumer2<PatientController, WardPatientsController>(builder: (context, patientController, wardPatientController, _) {
            return LoadingAndErrorWidget(
                state: wardPatientController.state,
                child: Row(
              mainAxisAlignment: patientController.isCreating ? MainAxisAlignment.end : MainAxisAlignment.spaceBetween,
              children: patientController.isCreating
                  ? [
                TextButton(
                  style: buttonStyleBig,
                  onPressed: patientController.create,
                  child: Text(context.localization!.create),
                )
              ]
                  : [
                SizedBox(
                  width: width * 0.4,
                  // TODO make this state checking easier and more readable
                  child: TextButton(
                    onPressed: patientController.patient.isUnassigned
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
                    child: Text(context.localization!.unassigne),
                  ),
                ),
                SizedBox(
                  width: width * 0.4,
                  child: TextButton(
                    // TODO check whether the patient is active
                    onPressed: wardPatientController.discharged.contains(patientController.patient)? null : () {
                      showDialog(
                        context: context,
                        builder: (context) => AcceptDialog(titleText: context.localization!.dischargePatient),
                      ).then((value) {
                        if (value) {
                          patientController.discharge();
                          Navigator.of(context).pop();
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
                    child: Text(context.localization!.discharge),
                  ),
                ),
              ],
            ));
          }),
        ),
        builder: (BuildContext context) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Consumer<PatientController>(builder: (context, patientController, _) {
                return LoadingFutureBuilder(
                  future: loadRoomsWithBeds(patientController.patient.id),
                  // TODO use a better loading widget
                  loadingWidget: const SizedBox(),
                  thenWidgetBuilder: (context, beds) {
                    if (beds.isEmpty) {
                      return Text(
                        context.localization!.noFreeBeds,
                        style: TextStyle(color: Theme.of(context).disabledColor, fontWeight: FontWeight.bold),
                      );
                    }
                    return DropdownButtonHideUnderline(
                      child: DropdownButton<RoomWithBedFlat>(
                        iconEnabledColor: Theme.of(context).colorScheme.secondary.withOpacity(0.6),
                        padding: EdgeInsets.zero,
                        isDense: true,
                        hint: Text(
                          context.localization!.assignBed,
                          style: TextStyle(color: Theme.of(context).colorScheme.secondary.withOpacity(0.6)),
                        ),
                        value: !patientController.patient.isUnassigned
                            ? RoomWithBedFlat(
                                room: patientController.patient.room!, bed: patientController.patient.bed!)
                            : null,
                        items: beds
                            .map((roomWithBed) => DropdownMenuItem(
                                  value: roomWithBed,
                                  child: Text(
                                    "${roomWithBed.room.name} - ${roomWithBed.bed.name}",
                                    style: TextStyle(color: Theme.of(context).colorScheme.primary.withOpacity(0.6)),
                                  ),
                                ))
                            .toList(),
                        onChanged: (RoomWithBedFlat? value) {
                          // TODO later unassign here
                          if (value == null) {
                            return;
                          }
                          patientController.changeBed(value.room, value.bed);
                        },
                      ),
                    );
                  },
                );
              }),
            ),
            Text(
              context.localization!.notes,
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
                        title: context.localization!.upcoming,
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
                        title: context.localization!.inProgress,
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
                      title: context.localization!.done,
                      color: doneColor,
                    );
                  },
                  title: Text(
                    context.localization!.tasks,
                    style: const TextStyle(fontSize: fontSizeBig, fontWeight: FontWeight.bold),
                  ),
                  // TODO use return value to add it to task list or force a refetch
                  onAdd: () => context.pushModal(
                    context: context,
                    builder: (context) => TaskBottomSheet(task: Task.empty, patient: patient),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
