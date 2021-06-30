import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/food_tracking/food_tracking.dart';
import 'package:fit_tip/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FoodLogDaySelector extends StatelessWidget {
  const FoodLogDaySelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FoodLogFocusedDateBloc, FoodLogFocusedDateState>(
      listener: (context, state) {
        BlocProvider.of<FoodDailyLogsBloc>(context).add(FoodDailyLogsFocusedDateUpdated(state.selectedDate));
        BlocProvider.of<CalorieDailyGoalBloc>(context).add(CalorieDailyGoalFocusedDateUpdated(date: state.selectedDate));
      },
      builder: (context, state) {
        return DaySelector(
          arrowBackPressed: () => BlocProvider.of<FoodLogFocusedDateBloc>(context).add(FoodLogFocusedDatePreviousDayPressed()),
          arrowFowardPressed: () => BlocProvider.of<FoodLogFocusedDateBloc>(context).add(FoodLogFocusedDateNextDayPressed()),
          selectedDate: state.selectedDate,
          firstDate: BlocProvider.of<AuthenticationBloc>(context).state.user!.dateJoined!,
          dayChoosed: (DateTime? date) => BlocProvider.of<FoodLogFocusedDateBloc>(context).add(FoodLogFocusedDatePicked(date: date)),
        );
      },
    );
  }
}
