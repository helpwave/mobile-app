import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';

/// Widget to show when a FutureBuilder contains an error
class LoadErrorWidget extends StatelessWidget {
  /// Text below the error Icon
  final String? errorText;

  /// Color of the Error icon
  final Color iconColor;

  /// Size of the Error icon
  final double iconSize;

  const LoadErrorWidget({
    super.key,
    this.errorText,
    this.iconColor = negativeColor,
    this.iconSize = iconSizeBig,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: iconSize,
            color: iconColor,
          ),
          const SizedBox(height: distanceBig),
          Text(errorText ?? context.localization!.errorOnLoad),
        ],
      ),
    );
  }
}
