import 'package:fit_tip/water_tracking/blocs/blocs.dart';
import 'package:fit_tip/water_tracking/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_repository/enums/drinking_cup_size.dart';

class WaterLogGridTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WaterGridTileBloc, WaterGridTileState>(
      listener: (context, state) {
        if (state is WaterGridTileDirty) {
          BlocProvider.of<WaterLogDayBloc>(context).add(WaterLogUpdated(state.waterLog));
        }
      },
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
                builder: (_) {
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider.value(
                        value: BlocProvider.of<WaterGridTileBloc>(context),
                      ),
                      BlocProvider<WaterLogAmountSliderBloc>(
                        create: (context) => WaterLogAmountSliderBloc(
                          log: BlocProvider.of<WaterGridTileBloc>(context).state.waterLog,
                        ),
                      ),
                      BlocProvider.value(
                        value: BlocProvider.of<WaterLogDayBloc>(context),
                      ),
                    ],
                    child: WaterLogGridTileDialog(),
                  );
                },
              ).then((_) {
                BlocProvider.of<WaterGridTileBloc>(context).add(WaterGridTileDialogClosed());
              });
            },
            child: GridTile(
              header: Text(
                item.time.format(context),
                textAlign: TextAlign.center,
              ),
              child: Center(child: Text(mapDrinkingCupSizeToString(item.cup.size))),
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
