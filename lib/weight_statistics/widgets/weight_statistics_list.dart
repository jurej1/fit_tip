import 'package:fit_tip/weight_statistics/weight_statistics.dart';
import 'package:flutter/material.dart';

class WeightStatisticsList extends StatelessWidget {
  final WeightStatisticsLoadedSuccessfully state;

  const WeightStatisticsList({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      width: size.width,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text('Trends'),
            TrendCard(
              text: 'Last 7 day change',
              number: state.sevenDayChange,
            ),
            TrendCard(
              text: 'Last 30 day change',
              number: state.thirdyDayChange,
            ),
            TrendCard(
              text: 'Total weight change',
              number: state.totalChange,
            ),
          ],
        ),
      ),
    );
  }
}
