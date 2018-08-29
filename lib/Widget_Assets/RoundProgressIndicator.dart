import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:shimmer/shimmer.dart';

class RoundProgress extends StatefulWidget {
  final Color dayProgressColor;
  final String timePercentage;
  final TextStyle textStyle;
  final TextStyle numStyle;
  final Duration duration;
  final double currentTime;
  final String type;

  RoundProgress(
      {this.type: 'dp',
      this.currentTime: 0.0,
      this.timePercentage = '0',
      this.duration: const Duration(hours: 24),
      this.textStyle: const TextStyle(fontFamily: 'Jua', color: Colors.black54),
      this.numStyle: const TextStyle(
          fontFamily: 'Exo', fontSize: 40.0, color: Colors.tealAccent),
      this.dayProgressColor: Colors.tealAccent});

  RoundProgressState createState() => RoundProgressState();
}

class RoundProgressState extends State<RoundProgress>
    with TickerProviderStateMixin {
  AnimationController controller;

  String get timerString {
    Duration duration = controller.duration * controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60)
        .toString()
        .padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: widget.duration)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.repeat();
        }
      });
    controller.forward(from: widget.currentTime);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == 'dp')
      return dayProgress();
    else
      return new Container();
  }

  @override
  void deactivate() {
    controller.dispose();
    controller.removeListener(() {});
  }

  Widget dayProgress() {
    return Align(
      alignment: FractionalOffset.center,
      child: Container(
        height: 120.0,
        width: 120.0,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: AnimatedBuilder(
                animation: controller,
                builder: (BuildContext context, Widget child) {
                  return new CustomPaint(
                      painter: TimerPainter(
                    animation: controller,
                    backgroundColor: Colors.black54,
                    color: widget.dayProgressColor,
                  ));
                },
              ),
            ),
            Align(
              alignment: FractionalOffset.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Shimmer.fromColors(
                      baseColor: Colors.black54,
                      highlightColor: widget.dayProgressColor,
                      child: Text(
                        widget.timePercentage == null
                            ? '...'
                            : widget.timePercentage,
                        style: widget.numStyle,
                      )),
                  Text(
                    "left",
                    style: widget.textStyle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
  }
}

class TimerPainter extends CustomPainter {
  TimerPainter({
    this.animation,
    this.backgroundColor,
    this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.PI;
    canvas.drawArc(Offset.zero & size, math.PI * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(TimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}
