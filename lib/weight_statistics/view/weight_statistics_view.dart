import 'package:fit_tip/weight_statistics/weight_statistics.dart';
import 'package:fit_tip/weight_tracking/blocs/blocs.dart';
import 'package:weight_repository/weight_repository.dart' as weight_rep;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeightStatisticsView extends StatelessWidget {
  // static const routeName = 'weight_statistics_view';

  static MaterialPageRoute route(BuildContext context) {
    final historyBloc = BlocProvider.of<WeightHistoryBloc>(context);
    final weightGoalBloc = BlocProvider.of<WeightGoalBloc>(context);
    return MaterialPageRoute(
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<WeightStatisticsBloc>(
              create: (context) => WeightStatisticsBloc(
                weightHistoryBloc: historyBloc,
                weightRepository: RepositoryProvider.of<weight_rep.WeightRepository>(context),
              ),
            ),
            BlocProvider<WeightGoalStatisticsBloc>(
              create: (context) => WeightGoalStatisticsBloc(
                weightGoalBloc: weightGoalBloc,
                weightRepository: RepositoryProvider.of<weight_rep.WeightRepository>(context),
                weightHistoryBloc: historyBloc,
              ),
            ),
          ],
          child: WeightStatisticsView(),
        );
      },
    );
  }

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
