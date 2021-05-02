import 'package:flutter/material.dart';
import 'package:weight_repository/weight_repository.dart';
import 'package:fl_chart/fl_chart.dart';

class WeightHistoryLineChart extends StatelessWidget {
  final List<Weight> weights;

  WeightHistoryLineChart({
    Key? key,
    required this.weights,
  }) : super(key: key) {
    final List<Weight> sorted = weights..sort((a, b) => b.weight!.compareTo(a.weight!));

    _maxY = sorted[0].weight!.toDouble() + 5;
  }

  late double _maxY;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        maxY: _maxY,
        lineBarsData: [
          LineChartBarData(
            spots: weights.map<FlSpot>(
              (e) {
                return FlSpot(
                  e.date!.month.toDouble(),
                  e.weight!.toDouble(),
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }
}
