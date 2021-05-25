import 'package:fit_tip/water_tracking/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WaterLogGridTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WaterGridTileBloc, WaterGridTileState>(
      builder: (context, state) {
        final item = state.waterLog;

        return Material(
          elevation: 1.5,
          color: Colors.blue[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) {},
              );
            },
            child: GridTile(
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
            ),
          ),
        );
      },
    );
  }
}
