import 'package:flutter/material.dart';

class SelectedViewPainter extends CustomPainter {
  final int length;
  final Paint _dotPaint;
  final double radius;
  final double spacing;
  final int dotBorderThicknes;
  final Color dotBorderColor;
  final Paint _indicatorPaint;
  final double scrollPosition;

  SelectedViewPainter({
    required this.length,
    required this.dotBorderThicknes,
    required this.dotBorderColor,
    required this.radius,
    required this.spacing,
    required this.scrollPosition,
    required Color dotBackgroundColor,
    required Color indicatorColor,
  })  : this._dotPaint = Paint()..color = dotBackgroundColor,
        _indicatorPaint = Paint()..color = indicatorColor;

  double get _dotDiameter => radius * 2;

  @override
  void paint(Canvas canvas, Size size) {
    final double totalWidth = (_dotDiameter * length) + (spacing * (length - 1));

    final Offset startPoint = size.center(Offset.zero);

    _drawDots(canvas, startPoint, totalWidth);
    _drawIndicator(canvas, totalWidth);
  }

  void _drawIndicator(Canvas canvas, double totalWidth) {
    final int leftPageIndex = scrollPosition.floor();

    final double leftDotX = (-(totalWidth * 0.5)) + (leftPageIndex * (_dotDiameter + spacing));
    final double rightDotX = leftDotX + _dotDiameter;

    final double transitionPercentage = scrollPosition - leftPageIndex;

    final double laggingLeftSide = (transitionPercentage - 0.3).clamp(0, 1) / 0.7;
    final double leftIndicatorX = leftDotX + (laggingLeftSide * (_dotDiameter + spacing));

    final double acceleratedRightSide = (transitionPercentage / 0.5).clamp(0, 1);
    final double rightIndicatorX = rightDotX + (acceleratedRightSide * (_dotDiameter + spacing));

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(
          leftIndicatorX,
          -radius,
          rightIndicatorX,
          radius,
        ),
        Radius.circular(radius),
      ),
      _indicatorPaint,
    );
  }

  void _drawDots(Canvas canvas, Offset startingPoint, double totalWidth) {
    Offset dotCenter = startingPoint.translate(-(totalWidth * 0.5) + radius, 0);

    for (int i = 0; i < length; i++) {
      _drawDot(canvas, dotCenter);
      dotCenter = dotCenter.translate((_dotDiameter + spacing), 0);
    }
  }

  void _drawDot(Canvas canvas, Offset dotCenter) {
    canvas.drawCircle(dotCenter, radius, _dotPaint);

    Path path = Path()
      ..addOval(Rect.fromCircle(center: dotCenter, radius: radius))
      ..addOval(Rect.fromCircle(center: dotCenter, radius: radius - dotBorderThicknes))
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, Paint()..color = dotBorderColor);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
