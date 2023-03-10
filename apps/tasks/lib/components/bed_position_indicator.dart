import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_widget/loading.dart';

/// An Indicator to show at which bed position in a [Room] the [Patient] is
///
/// 1 | 2 | 3 | 4 is an example for the bed counting order
class BedPositionIndicator extends StatelessWidget {
  /// The number of beds in the room
  final int totalBedCount;

  /// The position of bed in the room
  ///
  /// please note first bed is position 1
  final int bedPosition;

  const BedPositionIndicator({
    super.key,
    this.totalBedCount = 4,
    this.bedPosition = 2,
  });

  // TODO replace API-Call
  Future<List<Map<String, dynamic>>> loadTasks() async {
    return [
      {"name": "Taskname"},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadTasks(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: LoadErrorWidget(
                errorText: context.localization!.errorOnLoad,
              ),
            ),
          );
        }
        return Scaffold();
      },
    );
  }
}
