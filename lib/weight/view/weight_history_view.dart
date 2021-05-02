import 'package:fit_tip/weight/view/add_weight_view.dart';
import 'package:fit_tip/weight/weight.dart';
import 'package:fit_tip/weight/widgets/widgets.dart';
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
          } else if (state is WeightHistorySuccesfullyLoaded) {
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
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
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
