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
      listener: (context, state) {},
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
    return BlocBuilder<WaterGridTileBloc, WaterGridTileState>(
      builder: (context, state) {
        final log = state.waterLog;

        return Container(
          width: double.infinity,
          color: Colors.green,
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                log.time.format(context),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                splashRadius: Material.defaultSplashRadius / 2,
                icon: const Icon(Icons.delete),
                onPressed: () {
                  BlocProvider.of<WaterGridTileBloc>(context).add(WaterGridTileDeleteRequested());
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
