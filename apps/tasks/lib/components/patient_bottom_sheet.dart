import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_theme/theme.dart';
import 'package:helpwave_widget/lists.dart';
import 'package:helpwave_widget/loading.dart';
import 'package:provider/provider.dart';
import 'package:tasks/components/task_bottom_sheet.dart';
import 'package:tasks/components/task_expansion_tile.dart';
import 'package:tasks/controllers/patient_controller.dart';
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
    List<RoomWithBedWithMinimalPatient> rooms = await RoomService()
        .getRoomOverviews(wardId: CurrentWardService().currentWard!.wardId);

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
    return ChangeNotifierProvider(
      create: (_) => PatientController(Patient.empty(id: widget.patentId)),
      child: Consumer2<ThemeModel, PatientController>(
        builder: (BuildContext context, ThemeModel themeNotifier, PatientController patientController, __) {
          Patient patient = patientController.patient;
          return SingleChildScrollView(
            child: BottomSheet(
              onClosing: () {
                // TODO handle this
              },
              builder: (BuildContext context) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: paddingMedium),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                constraints: const BoxConstraints(maxWidth: iconSizeTiny, maxHeight: iconSizeTiny),
                                padding: EdgeInsets.zero,
                                iconSize: iconSizeTiny,
                                onPressed: () => Navigator.maybePop(context),
                                icon: const Icon(Icons.close_rounded),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: paddingOffset),
                                  child: Text(
                                    patient.name,
                                    style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: fontSizeBig,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: iconSizeTiny),
                            ],
                          ),
                          Center(
                            child: LoadingFutureBuilder(
                                future: loadRoomsWithBeds(patientController.patient.id),
                                // TODO use a better loading widget
                                loadingWidget: const SizedBox(),
                                thenWidgetBuilder: (context, beds) {
                                  return DropdownButtonHideUnderline(
                                    child: DropdownButton<RoomWithBedFlat>(
                                      padding: EdgeInsets.zero,
                                      isDense: true,
                                      hint: Text(context.localization!.assignBed),
                                      value: patient.bed != null && patient.room != null
                                          ? RoomWithBedFlat(room: patient.room!, bed: patient.bed!)
                                          : null,
                                      items: beds
                                          .map((roomWithBed) => DropdownMenuItem(
                                                value: roomWithBed,
                                                child: Text(
                                                  "${roomWithBed.room.name} - ${roomWithBed.bed.name}",
                                                  style: const TextStyle(color: Colors.grey),
                                                ),
                                              ))
                                          .toList(),
                                      onChanged: (RoomWithBedFlat? value) {
                                        patientController.updatePatient((patient) {
                                          patient.room = value?.room;
                                          patient.bed = value?.bed;
                                        });
                                      },
                                    ),
                                  );
                                }),
                          )
                        ],
                      ),
                    ),
                    Text(
                      context.localization!.notes,
                      style: const TextStyle(fontSize: fontSizeBig, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: distanceSmall),
                    TextFormField(
                      initialValue: patient.notes,
                      maxLines: 6,
                      keyboardType: TextInputType.multiline,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: paddingMedium),
                      child: AddList(
                        maxHeight: width * 0.5,
                        items: [
                          patient.unscheduledTasks,
                          patient.inProgressTasks,
                          patient.doneTasks,
                        ],
                        itemBuilder: (_, index, taskList) {
                          if (taskList.isEmpty) {
                            return null;
                          }
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
                        onAdd: () => showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => TaskBottomSheet(task: Task.empty, patient: patient),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: paddingMedium),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: patientController.isCreating
                            ? [
                                TextButton(
                                  onPressed: () {
                                    // TODO: implement create
                                  },
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(borderRadiusMedium),
                                      ),
                                    ),
                                    backgroundColor: MaterialStateProperty.all(primaryColor),
                                  ),
                                  child: Text(context.localization!.create),
                                )
                              ]
                            : [
                                SizedBox(
                                  width: width * 0.4,
                                  child: TextButton(
                                    onPressed: () {
                                      // TODO: implement unassign
                                    },
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(borderRadiusMedium),
                                        ),
                                      ),
                                      backgroundColor: MaterialStateProperty.all(inProgressColor),
                                    ),
                                    child: Text(context.localization!.unassigne),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: paddingSmall),
                                  child: SizedBox(
                                    width: width * 0.4,
                                    child: TextButton(
                                      onPressed: () {
                                        // TODO: implement discharge
                                      },
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(borderRadiusMedium),
                                          ),
                                        ),
                                        backgroundColor: MaterialStateProperty.all(negativeColor),
                                      ),
                                      child: Text(context.localization!.discharge),
                                    ),
                                  ),
                                ),
                              ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
