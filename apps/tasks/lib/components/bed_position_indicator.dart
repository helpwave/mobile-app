import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';

/// An Indicator to show at which bed position in a [Room] the [Patient] is
///
/// 0 | 1 | 2 | 3 | 4 is an example for the bed counting order
class BedPositionIndicator extends StatelessWidget {
  /// The number of beds in the room
  final int totalBedCount;

  /// The position of bed in the room
  ///
  /// please note first bed is position 0
  final int bedPosition;

  /// The [Size] of the bed indicators
  final Size bedIndicatorSize;

  /// Whether the explanatory [Text] below the indicators is shown
  final bool isHidingText;

  /// The [Color] of the current [Bed]
  final Color activeColor;

  /// The [Color] of the not indicated [Bed]
  final Color inactiveColor;

  /// The radius of indicators
  final double borderRadius;

  /// The radius of indicators
  final double distanceBetween;

  const BedPositionIndicator({
    super.key,
    this.totalBedCount = 4,
    this.bedPosition = 1,
    this.bedIndicatorSize = const Size(12, 20),
    this.isHidingText = false,
    this.distanceBetween = 6,

    /// TODO change colors with ThemeUpdate
    this.activeColor = Colors.purple,
    this.inactiveColor = Colors.grey,
    this.borderRadius = 3,
  }) : assert(bedPosition < totalBedCount);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (int i = 0; i <= totalBedCount; i++)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: distanceBetween / 2,
                ),
                child: Container(
                  height: bedIndicatorSize.height,
                  width: bedIndicatorSize.width,
                  decoration: BoxDecoration(
                    color: i == bedPosition ? activeColor : inactiveColor,
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                ),
              )
          ],
        ),
        isHidingText
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.only(top: distanceTiny),
                child: Text(
                  context.localization!.bedPosition,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
      ],
    );
  }
}
