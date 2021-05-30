import 'package:fit_tip/water_tracking/water_tracking.dart';
import 'package:fit_tip/water_tracking/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WaterLogConsumption extends StatelessWidget {
  final double sizeA = 250;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WaterLogConsumptionBloc, WaterLogConsumptionState>(
      builder: (context, state) {
        print('WaterLogConsumptionBloc ' + state.toString());
        if (state is WaterLogConsumptionLoadSucccess) {
          return Container(
            height: sizeA,
            width: sizeA,
            child: CustomPaint(
              painter: ProgressPainter(
                primaryValue: state.amount,
                maxValue: state.max,
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
