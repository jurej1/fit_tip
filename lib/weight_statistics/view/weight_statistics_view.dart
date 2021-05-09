import 'package:fit_tip/weight_statistics/weight_statistics.dart';
import 'package:fit_tip/weight_statistics/widgets/trend_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeightStatisticsView extends StatelessWidget {
  static const routeName = 'weight_statistics_view';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<WeightStatisticsBloc, WeightStatisticsState>(
        builder: (context, state) {
          if (state is WeightStatisticsLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is WeightStatisticsFail) {
            return Center(
              child: Text('Seems like there was an error. Please try again later.'),
            );
          } else if (state is WeightStatisticsLoadedSuccessfully) {
            return _StatsList(state: state);
          }
          return Container();
        },
      ),
    );
  }
}

class _StatsList extends StatelessWidget {
  final WeightStatisticsLoadedSuccessfully state;

  const _StatsList({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
