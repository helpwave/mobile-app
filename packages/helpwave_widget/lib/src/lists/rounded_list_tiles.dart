import 'package:flutter/material.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_theme/util.dart';

class RoundedListTiles extends StatelessWidget {
  final List<Widget> items;

  const RoundedListTiles({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    const double borderRadius = borderRadiusMedium;

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
        children: List.generate(items.length * 2 - 1, (index) {
          if(index.isOdd){
            return const Divider();
          }
          Widget item = items[index ~/ 2];
          if (index == 0 && items.length == 1) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: item,
            );
          }
          if (index == 0) {
            return ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(borderRadius)),
              child: item,
            );
          }
          if (index == items.length - 1) {
            return ClipRRect(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(borderRadius)),
              child: item,
            );
          }
          return item;
        }),
      ),
    );
  }
}
