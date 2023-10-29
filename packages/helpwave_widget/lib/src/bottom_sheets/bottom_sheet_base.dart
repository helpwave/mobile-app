import 'package:flutter/material.dart';
import 'package:helpwave_theme/constants.dart';

/// A [BottomSheet] with a titlebar
class BottomSheetBase extends StatelessWidget {
  /// The function to call when closing the [BottomSheetBase]
  final void Function() onClosing;

  /// The builder function call to build the content of the [BottomSheetBase]
  final Widget Function(BuildContext context) builder;

  /// The title of the titlebar
  ///
  /// Overwrites [titleText]
  final Widget? title;

  /// The title text of the titlebar
  ///
  /// Overwritten by [title]
  final String titleText;

  /// The [Padding] of the builder [Widget]
  final EdgeInsetsGeometry padding;

  const BottomSheetBase({
    super.key,
    required this.onClosing,
    required this.builder,
    this.title,
    this.titleText = "",
    this.padding = const EdgeInsets.only(
      right: paddingMedium,
      left: paddingMedium,
      top: paddingMedium,
      bottom: 0,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: onClosing,
      builder: (context) {
        return Padding(
          padding: padding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                      padding: const EdgeInsets.symmetric(horizontal: paddingSmall),
                      child: title ??
                          Text(
                            titleText,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: iconSizeTiny,
                              fontFamily: "SpaceGrotesk",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                    ),
                  ),
                  const SizedBox(width: iconSizeTiny),
                ],
              ),
              builder(context),
            ],
          ),
        );
      },
    );
  }
}
