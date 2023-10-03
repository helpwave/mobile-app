import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:helpwave_widget/shapes.dart';
import 'package:impulse/theming/colors.dart';

class TimerComponent extends StatefulWidget {
  final bool isStartingImmediately;
  final Duration duration;
  final void Function() onFinish;

  const TimerComponent({
    super.key,
    this.isStartingImmediately = false,
    required this.duration,
    required this.onFinish,
  });

  @override
  State<StatefulWidget> createState() => _TimerComponentState();
}

class _TimerComponentState extends State<TimerComponent> {
  Timer? _timer;
  bool isInProgress = false;
  bool wasStarted = false;
  Duration timeRemaining = const Duration();
  Duration tickPeriod = const Duration(milliseconds: 50);

  @override
  void initState() {
    isInProgress = widget.isStartingImmediately;
    wasStarted = isInProgress;
    timeRemaining = Duration(seconds: widget.duration.inSeconds);
    if (isInProgress) {
      newTimer();
    }
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  newTimer() {
    _timer = Timer.periodic(
      tickPeriod,
      (Timer timer) {
        Duration newTimeRemaining = Duration(
            milliseconds:
                timeRemaining.inMilliseconds - tickPeriod.inMilliseconds);
        if (newTimeRemaining.inMilliseconds <= 0) {
          finish();
        } else {
          setState(() {
            timeRemaining = newTimeRemaining;
          });
        }
      },
    );
  }

  start() {
    newTimer();
    setState(() {
      isInProgress = true;
      wasStarted = true;
    });
  }

  stop() {
    setState(() {
      isInProgress = false;
    });
    _timer?.cancel();
  }

  /// When finished
  finish() {
    _timer?.cancel();
    setState(() {
      timeRemaining = Duration.zero;
    });
    widget.onFinish();
  }

  @override
  Widget build(BuildContext context) {
    double progress =
        timeRemaining.inMilliseconds / widget.duration.inMilliseconds;
    String durationString =
        "${timeRemaining.inMinutes.toString().padLeft(2, "0")}:${(timeRemaining.inSeconds % 60).toString().padLeft(2, "0")}";
    const double size = 150;
    const double iconSize = 48;
    const double textSize = 32;
    const double strokeWidth = 10;

    Widget iconForStatus() {
      if (isInProgress) {
        return Container();
      }
      if (wasStarted) {
        return const Icon(
          Icons.pause_rounded,
          color: primary,
          size: iconSize,
        );
      } else {
        return const Icon(
          Icons.play_arrow_rounded,
          color: primary,
          size: iconSize,
        );
      }
    }

    return SizedBox(
      height: size + strokeWidth * 2,
      width: size + strokeWidth * 2,
      child: GestureDetector(
        onTap: () {
          if (isInProgress) {
            stop();
          } else {
            start();
          }
        },
        child: Stack(
          children: [
            Positioned(
              left: strokeWidth,
              top: strokeWidth,
              child: SizedBox(
                height: size,
                width: size,
                child: Circle(
                  diameter: size,
                  color: secondary,
                  child: CustomPaint(
                    willChange: true,
                    size: const Size(size, size),
                    painter: TimerPainter(progress: progress),
                  ),
                ),
              ),
            ),
            Positioned(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    iconForStatus(),
                    Text(
                      durationString,
                      style: const TextStyle(
                        fontSize: textSize,
                        fontFamily: 'Fredoka',
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TimerPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color progressColor;
  final Color progressBackgroundColor;

  TimerPainter({
    required this.progress,
    this.strokeWidth = 10,
    this.progressColor = primary,
    this.progressBackgroundColor = Colors.transparent,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = progressBackgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double radius = min(centerX, centerY);

    canvas.drawCircle(Offset(centerX, centerY), radius, paint);

    Paint progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
