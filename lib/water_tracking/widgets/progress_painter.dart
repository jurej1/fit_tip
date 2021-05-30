import 'dart:math';

import 'package:flutter/material.dart';

class ProgressPainter extends CustomPainter {
  final double primaryValue;
  final double radius;
  final double completeWidth;
  final double outerWidth;
  final Color outerColor;
  final Color innerColor;
  final double maxValue;

  ProgressPainter({
    required this.primaryValue,
    this.radius = 100,
    this.completeWidth = 10,
    this.outerWidth = 20,
    this.outerColor = Colors.red,
    this.innerColor = Colors.blue,
    required this.maxValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint background = Paint()
      ..color = outerColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = outerWidth;

    Paint foreground = Paint()
      ..color = innerColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = completeWidth;

    Offset center = Offset(size.width / 2, size.height / 2);

    double radius = min(size.width / 2, size.height / 2);

    double startAngle = pi / 2 + pi / 4;
    double maxAngle = ((2 * pi - pi / 2));

    double maxValueConsumed = maxAngle * (primaryValue / maxValue);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      maxAngle,
      false,
      background,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      maxValueConsumed,
      false,
      foreground,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
