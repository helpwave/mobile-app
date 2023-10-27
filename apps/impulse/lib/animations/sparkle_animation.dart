import 'dart:math';
import 'package:flutter/material.dart';
import 'package:impulse/components/star.dart';

/// A box in which fading and rising [Star]s are shown
///
/// The height and width are parameterized
class SparkleAnimation extends StatefulWidget {
  /// The width of the box
  final double width;

  /// The height of the box
  final double height;

  const SparkleAnimation({super.key, required this.width, required this.height});

  @override
  State<StatefulWidget> createState() => _SparkleAnimationState();
}

class _SparkleAnimationState extends State<SparkleAnimation> with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  List<_StarData> stars = [];
  final Duration spawnDelay = const Duration(milliseconds: 300);
  Duration fromLastSpawn = const Duration();
  Duration lastPassedTime = const Duration();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    controller = AnimationController(duration: spawnDelay, vsync: this)
      ..addListener(() {
        Duration timePassedBetween = (controller.lastElapsedDuration ?? lastPassedTime) - lastPassedTime;
        fromLastSpawn = fromLastSpawn + timePassedBetween;

        for (_StarData star in stars) {
          star.existsSince += timePassedBetween;
          star.y += star.velocityPerSecond * (timePassedBetween.inMilliseconds) / 1000;
        }

        setState(() {
          lastPassedTime = controller.lastElapsedDuration ?? lastPassedTime;
          stars = stars.where((star) => !star.isDone).toList();
          fromLastSpawn = fromLastSpawn;
        });

        if (fromLastSpawn.inMilliseconds >= spawnDelay.inMilliseconds) {
          setState(() {
            stars = [...stars, _StarData.newStar(widget.width, widget.height)];
            fromLastSpawn -= spawnDelay;
          });
        }
      });
    controller.repeat(period: spawnDelay);
    stars = [_StarData.newStar(widget.width, widget.height)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: Stack(
        children: stars.map((star) {
          return Positioned(
            height: star.size,
            width: star.size,
            bottom: star.y,
            left: star.x,
            child: Star(
              size: star.size,
              color: star.color,
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// A data class to hold the data needed for the [Star]s within the [SparkleAnimation]
class _StarData {
  /// The x position from the left
  double x;

  /// The y position from the bottom
  double y;

  /// The velocity with which the [Star]s should rise to not exceed the box within the duration
  double velocityPerSecond;

  /// The size of the star
  double size;

  /// The [Color] on which the fade effect will be applied
  Color baseColor;

  /// The [Duration] for which this [Star] exists in the [Animation]
  Duration existsSince;

  /// The maximum [Duration] for which the [Star] should be shown
  ///
  /// Used to calculate the [velocityPerSecond]
  static const Duration maxDuration = Duration(seconds: 2);

  /// The [Color] gained by fading the [baseColor] linearly to its existence duration
  ///
  /// If [maxDuration] is 2 seconds and the [Star] exists for 0.5 seconds the resulting opacity would be 75%
  Color get color => baseColor.withOpacity(max(0, 1 - existsSince.inMilliseconds / maxDuration.inMilliseconds));

  /// A simplified way to check whether the exists [Duration] exceeds the [maxDuration]
  bool get isDone => existsSince.compareTo(maxDuration) >= 0;

  /// Creates a new [Star] with [velocityPerSecond] that keeps the [Star] in bounds and gives it a random [Color]
  factory _StarData.newStar(
    double width,
    double height, {
    double minStarSize = 12,
    double maxStarSize = 32,
    double minTopDistance = 30,
  }) {
    Random random = Random();
    double size = minStarSize + random.nextDouble() * (maxStarSize - minStarSize);
    double y = random.nextDouble() * (height - size - minTopDistance);
    double x = random.nextDouble() * (width - size);
    double velocityPerSecond = (height - size - y) / _StarData.maxDuration.inSeconds;
    int colorAdd = random.nextInt(175);
    Color baseColor = Color.fromARGB(255, 80 + colorAdd, 80 + colorAdd, min(255, 160 + colorAdd));

    return _StarData(
      x: x,
      y: y,
      velocityPerSecond: velocityPerSecond,
      size: size,
      baseColor: baseColor,
      existsSince: const Duration(),
    );
  }

  _StarData({
    required this.x,
    required this.y,
    required this.velocityPerSecond,
    required this.size,
    required this.baseColor,
    required this.existsSince,
  });
}
