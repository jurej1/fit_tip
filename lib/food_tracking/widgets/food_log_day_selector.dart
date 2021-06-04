import 'package:fit_tip/food_tracking/food_tracking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

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
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios_rounded),
              onPressed: () {
                BlocProvider.of<FoodLogFocusedDateBloc>(context).add(FoodLogFocusedDatePreviousDayPressed());
              },
            ),
            Text(
              DateFormat('d.MMMM.yyyy').format(state.selectedDate),
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward_ios_rounded),
              onPressed: () {
                BlocProvider.of<FoodLogFocusedDateBloc>(context).add(FoodLogFocusedDateNextDayPressed());
              },
            ),
          ],
        );
      },
    );
  }
}
