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

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 2 / 3,
      ),
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: waterLogs.length,
      itemBuilder: (context, index) {
        final item = waterLogs[index];
        return Card(
          elevation: 1.5,
          color: Colors.blue[300],
          child: GridTile(
            header: Text(
              item.time.format(context),
              textAlign: TextAlign.center,
            ),
            child: Center(),
            footer: Text(
              item.cup.amount.toInt().toString(),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}
