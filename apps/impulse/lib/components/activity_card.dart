import 'package:flutter/material.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:impulse/theming/colors.dart';

/// A [Card] that shows an activity with all relevant information
class ActivityCard extends StatelessWidget {
  /// The [name] of the activity
  final String name;
  /// The [description] of the activity
  final String description;
  /// The amount of [xp] the activity rewards on completion
  final int xp;
  /// The [margin] of the [ActivityCard] defaults to [EdgeInsets.zero]
  final EdgeInsets margin;
  /// The callback when the [ActivityCard] is clicked
  final void Function() onClick;
  /// The [Color] with which to accentuate the start button and [Text] of the [ActivityCard]
  final Color? accentColor;

  const ActivityCard({
    super.key,
    required this.name,
    required this.description,
    required this.xp,
    this.margin = EdgeInsets.zero,
    required this.onClick,
    this.accentColor,
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
                      backgroundColor: MaterialStateProperty.all<Color>(
                          accentColor ?? accent),
                    ),
                    onPressed: onClick,
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
                        name,
                        style: TextStyle(
                          fontSize: fontSizeBig,
                          fontWeight: FontWeight.bold,
                          color: accentColor ?? accent,
                          fontFamily: "Fredoka",
                        ),
                      ),
                      Text(
                        description,
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
