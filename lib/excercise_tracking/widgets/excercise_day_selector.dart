import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/shared/blocs/blocs.dart';
import 'package:fit_tip/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../excercise_tracking.dart';

class ExcerciseDaySelector extends StatelessWidget {
  const ExcerciseDaySelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DaySelectorBloc, DaySelectorState>(
      listener: (context, state) {
        BlocProvider.of<ExcerciseDailyListBloc>(context).add(ExcerciseDailyListDateUpdated(state.selectedDate));
      },
      builder: (context, state) {
        return DaySelector(
          arrowBackPressed: () => BlocProvider.of<DaySelectorBloc>(context).add(DaySelectorPreviousDayRequested()),
          arrowFowardPressed: () => BlocProvider.of<DaySelectorBloc>(context).add(DaySelectorNextDayRequested()),
          dayChoosed: (DateTime? date) => BlocProvider.of<DaySelectorBloc>(context).add(DaySelectorDatePicked(date)),
          firstDate: BlocProvider.of<UserDataBloc>(context).state.user?.dateJoined ?? DateTime.now().subtract(const Duration(days: 365)),
          selectedDate: state.selectedDate,
        );
      },
    );
  }
}
