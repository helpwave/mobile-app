import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_widget/loading.dart';
import 'package:tasks/components/bed_position_indicator.dart';

class PatientScreen extends StatelessWidget {
  final Map<String, dynamic> patient;

  const PatientScreen({
    super.key,
    required this.patient,
  });

  // TODO replace API-Call
  Future<List<Map<String, dynamic>>> loadTasks() async {
    return [
      {"name": "Taskname", "description": "This is a very desriptive text"},
    ];
  }

  @override
  Widget build(BuildContext context) {
    const double bottomBarHeight = 60;

    return Scaffold(
      appBar: AppBar(title: Text(patient["name"])),
      bottomNavigationBar: SizedBox(
        height: bottomBarHeight,
        child: BottomAppBar(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(paddingSmall),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: distanceTiny),
                    child: Text(
                      patient["room"]["name"],
                      style: Theme.of(context).textTheme.titleLarge,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ),
                const Expanded(
                    child: BedPositionIndicator(
                  isHidingText: true,
                )),
                // TODO change Color with Theme update
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        style: ButtonStyle(
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(borderRadiusBig),
                            ),
                          ),
                        ),
                        onPressed: () {
                          // TODO open TaskCreationScreen with patient and room information
                        },
                        icon: const Icon(Icons.add, size: iconSizeTiny),
                        label: Text(context.localization!.addTasks),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: loadTasks(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: LoadErrorWidget(
                errorText: context.localization!.errorOnLoad,
              ),
            );
          }
          if (!snapshot.hasData) {
            Center(
              child: LoadingSpinner(
                text: "${context.localization!.loading}...",
              ),
            );
          }
          return ListView();
        },
      ),
    );
  }
}
