import 'package:flutter/material.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:impulse/theming/colors.dart';

class ActivityCard extends StatelessWidget {
  final String activityName;
  final String activityDescription;
  final int xp;
  final EdgeInsets margin;
  final void Function() onClick;

  const ActivityCard({
    super.key,
    required this.activityName,
    required this.activityDescription,
    required this.xp,
    this.margin = EdgeInsets.zero,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Card(
        margin: margin,
        child: Padding(
          padding: const EdgeInsets.all(paddingSmall),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(paddingSmall),
                child: Container(
                  decoration:
                      const BoxDecoration(shape: BoxShape.circle, boxShadow: [
                    BoxShadow(
                      offset: Offset(2, 2),
                      color: Colors.grey,
                      blurRadius: 1,
                    ),
                  ]),
                  child: IconButton(
                    iconSize: 60,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(accent),
                    ),
                    onPressed: () => {},
                    icon: const Center(
                      child: Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: paddingSmall),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Chip(
                        padding: const EdgeInsets.symmetric(
                          horizontal: paddingTiny,
                          vertical: 0,
                        ),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        color: const MaterialStatePropertyAll(orange),
                        label: Text(
                          "Bis zu +$xp XP",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      Text(
                        activityName,
                        style: const TextStyle(
                          fontSize: fontSizeBig,
                          fontWeight: FontWeight.bold,
                          color: accent,
                          fontFamily: "SpaceGrotesk",
                        ),
                      ),
                      Text(
                        activityDescription,
                        style: TextStyle(color: Colors.black.withOpacity(0.6)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
