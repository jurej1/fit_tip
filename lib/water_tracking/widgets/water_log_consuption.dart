import 'package:fit_tip/water_tracking/widgets/widgets.dart';
import 'package:flutter/material.dart';

class WaterLogConsumption extends StatelessWidget {
  final double consumption;

  final double sizeA = 250;

  const WaterLogConsumption({Key? key, required this.consumption}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: sizeA,
      width: sizeA,
      child: CustomPaint(
        painter: ProgressPainter(
          primaryValue: consumption,
          maxValue: 100,
        ),
      ),
    );
  }
}
