import 'package:fit_tip/water_tracking/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WaterLogGridTileDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Header(),
            const SizedBox(height: 20),
            _Slider(),
          ],
        ),
      ),
    );
  }
}

class _Slider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WaterLogAmountSliderBloc, WaterLogAmountSliderState>(
      listener: (context, state) {
        BlocProvider.of<WaterGridTileBloc>(context).add(WaterGridTileBlocSliderUpdated(state.currentAmount));
      },
      builder: (context, state) {
        return Slider(
          onChanged: (val) {
            BlocProvider.of<WaterLogAmountSliderBloc>(context).add(WaterLogSLiderUpdated(value: val));
          },
          value: state.currentAmount,
          max: state.maxAmount,
          min: state.minAmount,
          divisions: 5,
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<WaterGridTileBloc, WaterGridTileState>(
      listener: (context, state) {
        if (state is WaterGridTileDeletingSuccess) {
          BlocProvider.of<WaterLogDayBloc>(context).add(WaterLogRemoved(state.waterLog));
          Navigator.of(context).pop();
        }
      },
      child: Container(
        width: double.infinity,
        color: Colors.green,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BlocBuilder<WaterGridTileBloc, WaterGridTileState>(
                  buildWhen: (previous, current) => previous.waterLog.time != current.waterLog.time,
                  builder: (context, state) {
                    final log = state.waterLog;
                    return Chip(
                      backgroundColor: Colors.green[300],
                      deleteIconColor: Colors.white,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onDeleted: () async {
                        //TODO Prevent chosing the time in the future
                        TimeOfDay? selectedTime = await showTimePicker(
                          context: context,
                          initialTime: log.time,
                        );

                        BlocProvider.of<WaterGridTileBloc>(context).add(WaterGridTileTimeUpdated(selectedTime));
                      },
                      deleteIcon: const Icon(Icons.arrow_forward_ios_rounded),
                      label: Text(
                        log.time.format(context),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  splashRadius: Material.defaultSplashRadius / 2,
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    BlocProvider.of<WaterGridTileBloc>(context).add(WaterGridTileDeleteRequested());
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            BlocBuilder<WaterGridTileBloc, WaterGridTileState>(
              buildWhen: (p, c) => p.waterLog.cup.amount != c.waterLog.cup.amount,
              builder: (context, state) {
                final log = state.waterLog;

                return Text(
                  '${log.cup.amount.toStringAsFixed(0)} ml',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
