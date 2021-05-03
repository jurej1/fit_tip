import 'package:flutter/material.dart';
import 'package:weight_repository/weight_repository.dart';
import 'package:fl_chart/fl_chart.dart';

class WeightHistoryLineChart extends StatelessWidget {
  final List<Weight> weights;

  WeightHistoryLineChart({
    Key? key,
    required this.weights,
  }) : super(key: key) {
    final lowBoundMonth = DateTime.now().subtract(const Duration(days: 365));
    List<Weight> weightsCopy = List.from(weights)..retainWhere((element) => element.date!.isAfter(lowBoundMonth));

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
        maxX: 12,
        maxY: _maxY,
        titlesData: FlTitlesData(
          bottomTitles: SideTitles(
            showTitles: true,
            reservedSize: 16,
            margin: 15,
            getTextStyles: (val) => TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            getTitles: (value) {
              switch (value.toInt()) {
                case 2:
                  return 'FEB';
                case 7:
                  return 'JUL';
                case 12:
                  return 'DEC';
              }
              return '';
            },
          ),
          leftTitles: SideTitles(
            showTitles: true,
            getTextStyles: (value) => const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            getTitles: (value) {
              if (value % 5 == 0) {
                return (value.toInt().toString());
              }
              return '';
            },
            margin: 8,
            reservedSize: 16,
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(),
            left: BorderSide(),
          ),
        ),
        gridData: FlGridData(show: false),
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
