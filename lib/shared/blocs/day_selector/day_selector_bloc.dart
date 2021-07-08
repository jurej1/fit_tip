import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'day_selector_event.dart';
part 'day_selector_state.dart';

class DaySelectorBloc extends Bloc<DaySelectorEvent, DaySelectorState> {
  DaySelectorBloc({DateTime? initialDate}) : super(DaySelectorState(initialDate ?? DateTime.now()));

  @override
  Stream<DaySelectorState> mapEventToState(
    DaySelectorEvent event,
  ) async* {
    if (event is DaySelectorNextDayRequested) {
      if (!state.isSelectedDayToday()) {
        yield state.copyWith(selectedDate: state.selectedDate.add(const Duration(days: 1)));
      }
    } else if (event is DaySelectorPreviousDayRequested) {
      yield state.copyWith(selectedDate: state.selectedDate.subtract(const Duration(days: 1)));
    } else if (event is DaySelectorDatePicked) {
      if (event.date != null) {
        yield state.copyWith(selectedDate: event.date);
      }
    }
  }
}
