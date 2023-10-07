import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:tasks/components/TaskExpansionTile.dart';
import 'package:tasks/dataclasses/task.dart';

class PatientBottomSheet extends StatefulWidget {
  const PatientBottomSheet({Key? key, required this.task}) : super(key: key);

  final TaskWithPatient task;

  @override
  State<PatientBottomSheet> createState() => _PatientBottomSheetState();
}

class _PatientBottomSheetState extends State<PatientBottomSheet> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Consumer<ThemeModel>(
      builder: (BuildContext context, ThemeModel themeNotifier, __) {
        return BottomSheet(
          onClosing: () {},
          builder: (BuildContext ctx) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: paddingMedium),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: paddingMedium),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(top: paddingOffset),
                              child: Text(
                                widget.task.patient.name,
                                style: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: fontSizeBig,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      SizedBox(
                        width: width * 0.45,
                        child: const Center(
                          child: ExpansionTile(
                            title: Text(
                              overflow: TextOverflow.ellipsis,
                              "Room 2 - Bed 1", // TODO: replace with real data
                              style: TextStyle(color: Colors.grey),
                            ),
                            children: [
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                TextFormField(
                  initialValue: widget.task.notes,
                  decoration: InputDecoration(
                    hintText: context.localization!.notes,
                  ),
                  maxLines: 6,
                  keyboardType: TextInputType.multiline,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: paddingMedium, horizontal: paddingOffset ),
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(context.localization!.tasks, style: const TextStyle(fontSize: fontSizeBig, fontWeight: FontWeight.bold),),
                      Container(
                        height: 40,
                        width: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryColor
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(size: 25 , Icons.add, color: Colors.white,),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: width * 0.5,
                  child: ListView(
                    children: [
                      TaskExpansionTile(
                        tasks: [
                          // TODO: add upcoming tasks
                          widget.task
                        ],
                        color: upcomingColor,
                        title: context.localization!.upcoming,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: paddingMedium),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
        );
      },
    );
  }
}
