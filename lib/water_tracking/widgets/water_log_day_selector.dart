import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/shared/blocs/blocs.dart';
import 'package:fit_tip/shared/shared.dart';
import 'package:fit_tip/water_tracking/water_tracking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WaterLogDaySelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DaySelectorBloc, DaySelectorState>(
      listener: (context, state) {
        BlocProvider.of<WaterDailyGoalBloc>(context).add(WaterDailyGoalDateUpdated(state.selectedDate));
        BlocProvider.of<WaterLogDayBloc>(context).add(WaterLogFocusedDayUpdated(state.selectedDate));
      },
      builder: (context, state) {
        return DaySelector(
          arrowBackPressed: () => BlocProvider.of<DaySelectorBloc>(context).add(DaySelectorPreviousDayRequested()),
          arrowFowardPressed: () => BlocProvider.of<DaySelectorBloc>(context).add(DaySelectorNextDayRequested()),
          selectedDate: state.selectedDate,
          firstDate: BlocProvider.of<UserDataBloc>(context).state.user!.dateJoined!,
          dayChoosed: (DateTime? date) => BlocProvider.of<DaySelectorBloc>(context).add(DaySelectorDatePicked(date)),
        );
      },
    );
  }
}
