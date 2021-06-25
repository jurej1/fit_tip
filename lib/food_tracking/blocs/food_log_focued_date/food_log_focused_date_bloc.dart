import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'food_log_focused_date_event.dart';
part 'food_log_focused_date_state.dart';

class FoodLogFocusedDateBloc extends Bloc<FoodLogFocusedDateEvent, FoodLogFocusedDateState> {
  FoodLogFocusedDateBloc() : super(FoodLogFocusedDateState());

  @override
  Stream<FoodLogFocusedDateState> mapEventToState(
    FoodLogFocusedDateEvent event,
  ) async* {
    if (event is FoodLogFocusedDateNextDayPressed) {
      if (!state.isSelectedDayToday) {
        final selected = state.selectedDate;
        yield state.copyWith(selectedDate: selected.add(const Duration(days: 1)));
      }
    } else if (event is FoodLogFocusedDatePreviousDayPressed) {
      final selected = state.selectedDate;

      yield state.copyWith(
        selectedDate: selected.subtract(const Duration(days: 1)),
      );
    } else if (event is FoodLogFocusedDatePicked) {
      if (event.date != null) {
        bool isAfterNow = event.date!.isAfter(DateTime.now());

        if (!isAfterNow) yield state.copyWith(selectedDate: event.date!);
      }
    }
  }
}
