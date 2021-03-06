import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/weight_statistics/view/view.dart';
import 'package:fit_tip/weight_tracking/weight.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_repository/weight_repository.dart';

class WeightTrackingView extends StatelessWidget {
  // static const routeName = 'weight_tracking_view';

  const WeightTrackingView();

  static MaterialPageRoute route(BuildContext context) {
    return MaterialPageRoute(
      builder: (_) {
        return widget(context);
      },
    );
  }

  static Widget widget(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => WeightHistoryBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            weightRepository: RepositoryProvider.of<WeightRepository>(context),
          )..add(WeightHistoryLoad()),
        ),
        BlocProvider(
          create: (context) => WeightGoalBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            weightRepository: RepositoryProvider.of<WeightRepository>(context),
          )..add(WeightGoalLoadEvent()),
        ),
      ],
      child: WeightTrackingView(),
    );
  }

  static AppBar appBar(context) {
    return AppBar(
      title: const Text('Weight'),
      actions: [
        IconButton(
          icon: const Icon(Icons.pie_chart),
          onPressed: () {
            Navigator.of(context).push(WeightStatisticsView.route(context));
          },
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(AddWeightView.route(context));
          },
        )
      ],
    );
  }

  static Widget body() {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _WeightGoalView(),
            _WeightHistoryView(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: body(),
    );
  }
}

class _WeightGoalView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeightGoalBloc, WeightGoalState>(
      builder: (context, state) {
        if (state is WeightGoalFailure) {
          return Container();
        } else if (state is WeightGoalLoading) {
          return Container(
            height: 230,
            child: Center(
              child: const CircularProgressIndicator(),
            ),
          );
        } else if (state is WeightGoalLoadSuccess) {
          final goal = state.goal;

          return WeightGoalsList(goal: goal);
        }

        return Container();
      },
    );
  }
}

class _WeightHistoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeightHistoryBloc, WeightHistoryState>(
      builder: (context, state) {
        if (state is WeightHistoryLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is WeightHistoryFailure) {
          return Center(
            child: Text('Sorry there was an error while loading. Please try again.'),
          );
        } else if (state is WeightHistoryLoadSucces) {
          if (state.weights.isEmpty) {
            return Center(
              child: Text(
                'no items',
              ),
            );
          }

          final weights = state.weights;

          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(25),
                  height: 250,
                  child: WeightHistoryLineChart(weights: weights),
                ),
                WeightHistoryList(weights: weights),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
