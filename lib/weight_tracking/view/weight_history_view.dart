import 'package:fit_tip/weight_statistics/view/view.dart';
import 'package:fit_tip/weight_tracking/weight.dart';
import 'package:fit_tip/weight_tracking/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeightHistoryView extends StatelessWidget {
  static const routeName = 'weight_history_view';

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
      body: BlocBuilder<WeightHistoryBloc, WeightHistoryState>(
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

            return Container(
              height: size.height,
              width: size.width,
              child: SingleChildScrollView(
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
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
