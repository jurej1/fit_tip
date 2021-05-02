import 'package:flutter/material.dart';
import 'package:weight_repository/weight_repository.dart';

class WeightHistoryList extends StatelessWidget {
  final List<Weight> weights;

  const WeightHistoryList({Key? key, required this.weights}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (weights.isEmpty) {
      return Center(
        child: Text('You have no weights loggs'),
      );
    }

    return ListView.builder(
      itemCount: weights.length,
      itemBuilder: (context, index) {
        final item = weights[index];

        return ListTile(
          leading: Text(item.weight?.toStringAsFixed(1) ?? ''),
        );
      },
    );
  }
}