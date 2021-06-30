import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/shared/blocs/blocs.dart';
import 'package:fit_tip/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExcerciseDaySelector extends StatelessWidget {
  const ExcerciseDaySelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DaySelectorBloc, DaySelectorState>(
      builder: (context, state) {
        return DaySelector(
          arrowBackPressed: () => BlocProvider.of<DaySelectorBloc>(context).add(DaySelectorPreviousDayRequested()),
          arrowFowardPressed: () => BlocProvider.of<DaySelectorBloc>(context).add(DaySelectorNextDayRequested()),
          dayChoosed: (DateTime? date) => BlocProvider.of<DaySelectorBloc>(context).add(DaySelectorDatePicked(date)),
          firstDate: BlocProvider.of<AuthenticationBloc>(context).state.user!.dateJoined!,
          selectedDate: state.selectedDate,
        );
      },
    );
  }
}
