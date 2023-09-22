import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class XpLabel extends StatelessWidget {
  final int xp;
  static const backgroundColor = Color(0xfff16c82);
  static const labelColor = Color(0xffffffff);

  const XpLabel({super.key, required this.xp});

  @override
  Widget build(BuildContext context) {
    return Chip(
      color: const MaterialStatePropertyAll(backgroundColor),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(40),
        ),
      ),
      label: Padding(
        padding: const EdgeInsets.all(8),
        child: RichText(
          text: TextSpan(
            text: "$xp",
            style: const TextStyle(
              color: labelColor,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
            children: const <TextSpan>[
              TextSpan(
                text: 'xp',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              )
            ],
          ),
        ),
      ),
      side: const BorderSide(color: backgroundColor),
    );
  }
}
