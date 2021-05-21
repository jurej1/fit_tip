import 'package:fit_tip/water_tracking/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WaterLogBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WaterLogDayBloc, WaterLogDayState>(
      builder: (context, state) {
        if (state is WaterLogDayLoading) {
          return CircularProgressIndicator();
        } else if (state is WaterLogDayLoadSuccess) {
          return Container();
        } else if (state is WaterLogDayFailure) {
          return Container();
        }

        return Container();
      },
    );
  }
}
