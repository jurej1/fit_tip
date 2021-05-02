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
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          width: size.width,
          child: Column(
            children: [
              Container(
                // this should be a graph
                height: 250,
                width: size.width,
              ),
              Expanded(
                child: _WeightHistoryListBuilder(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeightHistoryListBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeightHistoryBloc, WeightHistoryState>(
      builder: (context, state) {
        if (state is WeightHistoryLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is WeightHistorySuccesfullyLoaded) {
          return WeightHistoryList(weights: state.weights);
        }
        return Center(
          child: Text('Sorry there wwas an error'),
        );
      },
    );
  }
}
