import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_theme/util.dart';

class RoundedListTiles extends StatelessWidget {
  final List<Widget> children;

  const RoundedListTiles({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    const double borderRadius = borderRadiusMedium;

    final usedChildren = children.isEmpty
        ? [
            SizedBox(
              height: 60,
              child: Center(
                child: Text(
                  context.localization!.nothingYet,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            )
          ]
        : children;

    return Container(
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 1,
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(usedChildren.length * 2 - 1, (index) {
          if (index.isOdd) {
            return const Divider();
          }
          final itemIndex = index ~/ 2;
          Widget item = usedChildren[itemIndex];
          if (index == 0 && usedChildren.length == 1) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: Material(color: Colors.transparent, child: item),
            );
          }
          if (index == 0) {
            return ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(borderRadius)),
              child: Material(color: Colors.transparent, child: item),
            );
          }
          if (itemIndex == usedChildren.length - 1) {
            return ClipRRect(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(borderRadius)),
              child: Material(color: Colors.transparent, child: item),
            );
          }
          return item;
        }),
      ),
    );
  }
}
