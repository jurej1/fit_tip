import 'package:fit_tip/weight/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:weight_repository/weight_repository.dart';
import 'package:fl_chart/fl_chart.dart';

class WeightHistoryLineChart extends StatelessWidget {
  final List<Weight> weights;

  WeightHistoryLineChart({
    Key? key,
    required this.weights,
  }) : super(key: key) {
    List<Weight> weightsCopy = List.from(weights);

    double maxY = 0;
    weightsCopy.forEach((element) {
      if (maxY < element.weight!) maxY = element.weight!.toDouble();
    });

    _maxY = maxY + 5;
  }

  late final double _maxY;
  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        axisTitleData: FlAxisTitleData(
          bottomTitle: AxisTitle(titleText: 'Date'),
          leftTitle: AxisTitle(titleText: 'Weight'),
        ),
        maxX: 12,
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
