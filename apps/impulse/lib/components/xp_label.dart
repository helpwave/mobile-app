import 'package:flutter/material.dart';
import 'package:impulse/theming/colors.dart';

/// A [Widget] showing experience points
class XpLabel extends StatelessWidget {
  /// The amount of experience points
  final int xp;

  const XpLabel({super.key, required this.xp});

  @override
  Widget build(BuildContext context) {
    return Chip(
      color: const MaterialStatePropertyAll(accent),
      label: RichText(
        text: TextSpan(
          text: "$xp",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: "Fredoka",
          ),
          children: const <TextSpan>[
            TextSpan(
              text: 'XP',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, fontFamily: "Fredoka"),
            )
          ],
        ),
      ),
      side: BorderSide.none,
    );
  }
}
