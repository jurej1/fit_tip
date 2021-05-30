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
        if (state is WaterLogConsumptionLoadSucccess) {
          return Container(
            height: sizeA,
            width: sizeA,
            child: CustomPaint(
              painter: ProgressPainter(
                primaryValue: state.amount,
                maxValue: state.max,
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${state.amount.toStringAsFixed(0)}ml',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Daily Goal: ${state.max.toStringAsFixed(0)}ml',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        if (state is WaterLogConsumptionLoading) {
          return Container(
            height: sizeA,
            width: sizeA,
            child: Center(
              child: const CircularProgressIndicator(),
            ),
          );
        }
        return Container();
      },
    );
  }
}
