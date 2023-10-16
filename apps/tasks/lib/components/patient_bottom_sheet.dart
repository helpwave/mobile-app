import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:tasks/components/task_expansion_tile.dart';
import 'package:tasks/dataclasses/patient.dart';

/// A [BottomSheet] for showing [Patient] information and [Task]s for that [Patient]
class PatientBottomSheet extends StatefulWidget {
  /// The identifier of the [Patient]
  final String patentId;

  const PatientBottomSheet({Key? key, required this.patentId}) : super(key: key);

  @override
  State<PatientBottomSheet> createState() => _PatientBottomSheetState();
}

class _PatientBottomSheetState extends State<PatientBottomSheet> {
  String? selectedRoom;
  final rooms = ["Room 2 - Bed 5"];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Consumer<ThemeModel>(
      builder: (BuildContext context, ThemeModel themeNotifier, __) {
        return SingleChildScrollView(
          child: BottomSheet(
            onClosing: () {},
            builder: (BuildContext ctx) => Padding(
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
                          children: [
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            const Flexible(
                              child: Padding(
                                padding: EdgeInsets.only(top: paddingOffset),
                                child: Text(
                                  "Patient 1", // TODO: replace with real data
                                  style: TextStyle(
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
                        Center(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedRoom,
                              items: rooms
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(color: Colors.grey),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  selectedRoom = value;
                                });
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: paddingOffset, bottom: paddingOffset),
                    child: Text(context.localization!.notes, style: const TextStyle(fontSize: fontSizeBig)),
                  ),
                  TextFormField(
                    initialValue: "", // TODO: replace with real data
                    maxLines: 6,
                    keyboardType: TextInputType.multiline,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: paddingMedium, left: paddingOffset, right: paddingOffset, bottom: paddingSmall),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          context.localization!.tasks,
                          style: const TextStyle(fontSize: fontSizeBig, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          height: iconSizeSmall,
                          width: iconSizeSmall,
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: primaryColor),
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              size: iconSizeVeryTiny,
                              Icons.add,
                              color: Colors.white,
                            ),
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
                          tasks: const [
                            // TODO: add upcoming tasks
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
          ),
        );
      },
    );
  }
}