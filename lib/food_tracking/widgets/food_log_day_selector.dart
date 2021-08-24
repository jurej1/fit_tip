import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/food_tracking/food_tracking.dart';
import 'package:fit_tip/shared/blocs/blocs.dart';
import 'package:fit_tip/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FoodLogDaySelector extends StatelessWidget {
  const FoodLogDaySelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DaySelectorBloc, DaySelectorState>(
      listener: (context, state) {
        BlocProvider.of<FoodDailyLogsBloc>(context).add(FoodDailyLogsFocusedDateUpdated(state.selectedDate));
        BlocProvider.of<CalorieDailyGoalBloc>(context).add(CalorieDailyGoalFocusedDateUpdated(date: state.selectedDate));
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
