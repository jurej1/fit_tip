import 'package:fit_tip/water_tracking/water_tracking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class WaterLogDaySelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WaterLogFocusedDayBloc, WaterLogFocusedDayState>(
      builder: (context, state) {
        return Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded),
                onPressed: () {
                  BlocProvider.of<WaterLogFocusedDayBloc>(context).add(WaterLogPreviousDayPressed());
                },
              ),
              Text(
                DateFormat('d.MMMM.yyyy').format(state.selectedDate),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios_rounded),
                onPressed: () {
                  BlocProvider.of<WaterLogFocusedDayBloc>(context).add(WaterLogNextDayPressed());
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
