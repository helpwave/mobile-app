import 'package:flutter/material.dart';
import 'package:helpwave_theme/constants.dart';

/// A [CircleAvatar] with a dummy image that can be sized as needed
class FallbackAvatar extends StatelessWidget{
  /// The size of the [CircleAvatar]
  final double size;

  const FallbackAvatar({super.key, this.size = iconSizeSmall});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: iconSizeSmall / 2,
      child: Container(
        width: iconSizeSmall,
        height: iconSizeSmall,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment(0.8, 1),
            colors: <Color>[
              Color(0xff1f005c),
              Color(0xff5b0060),
              Color(0xff870160),
              Color(0xffac255e),
              Color(0xffca485c),
              Color(0xffe16b5c),
              Color(0xfff39060),
              Color(0xffffb56b),
            ],
            tileMode: TileMode.mirror,
          ),
        ),
      ),
    );
  }
}
