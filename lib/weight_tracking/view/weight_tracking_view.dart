import 'package:fit_tip/weight_statistics/view/view.dart';
import 'package:fit_tip/weight_tracking/weight.dart';
import 'package:fit_tip/weight_tracking/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class WeightTrackingView extends StatelessWidget {
  static const routeName = 'weight_tracking_view';

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.pie_chart),
            onPressed: () {
              Navigator.of(context).pushNamed(WeightStatisticsView.routeName);
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddWeightView.routeName);
            },
          )
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _WeightGoalView(),
              _WeightHistoryView(),
            ],
          ),
        ),
      ),
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
            height: 250,
            child: Center(
              child: const CircularProgressIndicator(),
            ),
          );
        } else if (state is WeightGoalLoadSuccess) {
          final goal = state.goal;

          return Column(
            children: [
              ListTile(
                title: Text('Goals'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {},
                ),
              ),
              GoalRow(
                text: 'Begin date',
                value: goal.beginDate != null ? DateFormat('dd.MM.yyyy').format(goal.beginDate!) : '-',
              ),
              GoalRow(
                text: 'Begin weight',
                value: goal.beginWeight?.toString() ?? '-',
              ),
              GoalRow(
                text: 'Target date',
                value: goal.targetDate != null ? DateFormat('dd.MM.yyyy').format(goal.beginDate!) : '',
              ),
              GoalRow(
                text: 'Target weight',
                value: goal.targetWeight?.toString() ?? '-',
              ),
            ],
          );
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