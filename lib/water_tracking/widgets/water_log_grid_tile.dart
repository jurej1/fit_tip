import 'package:fit_tip/water_tracking/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WaterLogGridTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      color: Colors.blue[300],
      child: BlocBuilder<WaterGridTileBloc, WaterGridTileState>(
        builder: (context, state) {
          final item = state.waterLog;

          return GridTile(
            header: Text(
              item.time.format(context),
              textAlign: TextAlign.center,
            ),
            child: Center(
              child: Icon(Icons.water_damage),
            ),
            footer: Text(
              item.cup.amount.toStringAsFixed(0) + 'ml',
              textAlign: TextAlign.center,
            ),
          );
        },
      ),
    );
  }
}
