import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:impulse/components/medal.dart';

class MedalCarousel extends StatefulWidget {
  const MedalCarousel({super.key});

  @override
  State<StatefulWidget> createState() => _MedalCarouselState();
}

class _MedalCarouselState extends State<MedalCarousel> {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      carouselController: CarouselController(),
      options: CarouselOptions(height: 200.0),
      items: [1, 2, 3, 4, 5].map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Medal(name: "Level $i");
          },
        );
      }).toList(),
    );
  }
}
