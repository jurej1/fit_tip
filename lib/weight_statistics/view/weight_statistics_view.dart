import 'package:fit_tip/weight_statistics/weight_statistics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeightStatisticsView extends StatelessWidget {
  static const routeName = 'weight_statistics_view';

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        height: size.height,
        width: size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _Trends(),
              _GoalStats(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Trends extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeightStatisticsBloc, WeightStatisticsState>(
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
          return WeightStatisticsList(state: state);
        }
        return Container();
      },
    );
  }
}

class _GoalStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeightGoalStatisticsBloc, WeightGoalStatisticsState>(
      builder: (context, state) {
        if (state is WeightGoalStatisticsLoadSuccess) {
          return Column(
            children: [
              TrendCard(
                text: 'Remaning',
                number: state.remaining,
              ),
              TrendCard(
                text: 'Percantage done',
                number: state.percentageDone,
              ),
            ],
          );
        }

        return Container();
      },
    );
  }
}
