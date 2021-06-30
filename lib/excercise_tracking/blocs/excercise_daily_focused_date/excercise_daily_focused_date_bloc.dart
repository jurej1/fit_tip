import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'excercise_daily_focused_date_event.dart';
part 'excercise_daily_focused_date_state.dart';

class ExcerciseDailyFocusedDateBloc extends Bloc<ExcerciseDailyFocusedDateEvent, ExcerciseDailyFocusedDateState> {
  ExcerciseDailyFocusedDateBloc() : super(ExcerciseDailyFocusedDateState(DateTime.now()));

  @override
  Stream<ExcerciseDailyFocusedDateState> mapEventToState(
    ExcerciseDailyFocusedDateEvent event,
  ) async* {
    if (event is ExcerciseDailyFocusedDateNextDayPressed) {
      if (!state.isSelectedDateToday()) {
        yield state.copyWith(selectedDate: this.state.selectedDate.add(const Duration(days: 1)));
      }
    } else if (event is ExcerciseDailyFocusedDatePreviousDayPressed) {
      yield state.copyWith(selectedDate: this.state.selectedDate.subtract(const Duration(days: 1)));
    }
  }
}
