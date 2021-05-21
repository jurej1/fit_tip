import 'package:flutter/material.dart';
import 'package:water_repository/models/models.dart';

class WaterLogList extends StatelessWidget {
  final List<WaterLog> waterLogs;

  const WaterLogList({Key? key, required this.waterLogs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (waterLogs.isEmpty) {
      return Container();
    }

    return ListView.builder(
      itemBuilder: (context, index) {
        final item = waterLogs[index];
        return ListTile(
          title: Text(item.date.toString()),
          trailing: Text(item.cup.amount.toInt().toString()),
        );
      },
    );
  }
}
