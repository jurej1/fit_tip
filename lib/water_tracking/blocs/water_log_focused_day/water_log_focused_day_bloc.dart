import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'water_log_focused_day_event.dart';
part 'water_log_focused_day_state.dart';

class WaterLogFocusedDayBloc extends Bloc<WaterLogFocusedDayEvent, WaterLogFocusedDayState> {
  WaterLogFocusedDayBloc() : super(WaterLogFocusedDayState.initial());

  @override
  Stream<WaterLogFocusedDayState> mapEventToState(
    WaterLogFocusedDayEvent event,
  ) async* {
    if (event is WaterLogNextDayPressed) {
      if (!state.isSelectedDateToday) {
        final selectedDate = state.selectedDate;
        yield state.copyWith(selectedDate: selectedDate.add(const Duration(days: 1)));
      }
    } else if (event is WaterLogPreviousDayPressed) {
      final selectedDate = state.selectedDate;

      yield state.copyWith(selectedDate: selectedDate.subtract(const Duration(days: 1)));
    }
  }
}
