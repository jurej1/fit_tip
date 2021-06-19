import 'package:flutter/material.dart';
import 'dart:math';

class FoodItemMacrosPieChartPainter extends CustomPainter {
  final double fatAmount;
  final double carbsAmount;
  final double proteinAmount;
  final double totalAmount;

  final Color fatColor;
  final Color carbsColor;
  final Color proteinColor;

  const FoodItemMacrosPieChartPainter({
    this.fatAmount = 50,
    this.carbsAmount = 72,
    this.proteinAmount = 18,
    this.fatColor = Colors.red,
    this.carbsColor = Colors.blue,
    this.proteinColor = Colors.green,
  }) : this.totalAmount = fatAmount + carbsAmount + proteinAmount;

  @override
  void paint(Canvas canvas, Size size) {
    Paint _paint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;

    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = 70;

    double startAngle = 0;
    double sweepAngle = 2 * pi;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle, sweepAngle, false, _paint);

    _paint = _paint..color = fatColor;
    final fatAngle = calculateAngle(fatAmount);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle, fatAngle, false, _paint);

    _paint = _paint..color = carbsColor;

    final carbsAngle = calculateAngle(carbsAmount);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), fatAngle, carbsAngle, false, _paint);

    _paint = _paint..color = proteinColor;
    final proteinAngle = -calculateAngle(proteinAmount);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), 0, proteinAngle, false, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  double calculateAngle(double amount) {
    return ((2 * pi) / totalAmount) * amount;
  }
}
