import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:impulse/animations/sparkle_animation.dart';
import 'package:impulse/components/medal.dart';
import 'package:impulse/util/level.dart';

class MedalCarousel extends StatefulWidget {
  final int unlockedTo;

  const MedalCarousel({super.key, this.unlockedTo = 0});

  @override
  State<StatefulWidget> createState() => _MedalCarouselState();
}

class _MedalCarouselState extends State<MedalCarousel> {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      carouselController: CarouselController(),
      options: CarouselOptions(height: 200.0, autoPlay: true),
      items: List.generate(maxLvl, (index) => index + 1).map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Stack(
              children: [
                Center(
                  child: Medal(
                    name: "Level $i",
                    icon: widget.unlockedTo >= i ? Icons.workspace_premium_rounded : Icons.lock,
                  ),
                ),
                widget.unlockedTo >= i
                    ? Positioned(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SparkleAnimation(width: MediaQuery.of(context).size.width * 0.5, height: 100),
                          ],
                        ),
                      )
                    : Container(),
              ],
            );
          },
        );
      }).toList(),
    );
  }
}
