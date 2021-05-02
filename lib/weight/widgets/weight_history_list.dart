import 'package:flutter/material.dart';
import 'package:weight_repository/weight_repository.dart';
import 'package:intl/intl.dart';

class WeightHistoryList extends StatelessWidget {
  final List<Weight> weights;

  const WeightHistoryList({Key? key, required this.weights}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: weights.length,
      itemBuilder: (context, index) {
        final item = weights[index];
        return WeightTile(weight: item);
      },
    );
  }
}

class WeightTile extends StatelessWidget {
  final Weight weight;

  const WeightTile({Key? key, required this.weight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(weight),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: _deleteIcon(),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: _deleteIcon(),
      ),
      child: ListTile(
        leading: Text(weight.weight!.toDouble().toString()),
        trailing: weight.date != null ? Text(DateFormat('d.MMM.yyyy').format(weight.date!)) : null,
      ),
    );
  }

  Widget _deleteIcon() {
    return Icon(
      Icons.delete,
      color: Colors.white,
    );
  }
}
