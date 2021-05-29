import 'package:fit_tip/water_tracking/blocs/blocs.dart';
import 'package:fit_tip/water_tracking/water_tracking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WaterLogBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WaterLogDayBloc, WaterLogDayState>(
      builder: (context, state) {
        if (state is WaterLogDayLoading) {
          return Container(
            height: 5,
            child: LinearProgressIndicator(),
          );
        } else if (state is WaterLogDayLoadSuccess) {
          return Expanded(
            child: Column(
              children: [
                const SizedBox(height: 20),
                WaterLogConsumption(),
                WaterLogGrid(waterLogs: state.waterLogs),
              ],
            ),
          );
        } else if (state is WaterLogDayFailure) {
          return Container();
        }

        return Container();
      },
    );
  }
}
