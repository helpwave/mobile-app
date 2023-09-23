import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:impulse/theming/colors.dart';

class Medal extends StatelessWidget {
  final String name;
  final IconData icon;

  const Medal({
    super.key,
    required this.name,
    this.icon = Icons.workspace_premium_rounded,
  });

  @override
  Widget build(BuildContext context) {
    const svgPath = "assets/svg/medal.svg";
    const double size = 200;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Center(
            child: SvgPicture.asset(
              svgPath,
            ),
          ),
          Positioned(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: primary,
                    size: 40,
                  ),
                  const SizedBox(height: distanceSmall),
                  Text(
                    name,
                    style: const TextStyle(
                      color: primary,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Fredoka",
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
