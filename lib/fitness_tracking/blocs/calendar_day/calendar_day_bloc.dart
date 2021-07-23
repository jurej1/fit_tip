import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/fitness_tracking/blocs/blocs.dart';

part 'calendar_day_event.dart';
part 'calendar_day_state.dart';

class CalendarDayBloc extends Bloc<CalendarDayEvent, CalendarDayState> {
  CalendarDayBloc({
    required CalendarBloc calendarBloc,
    required CalendarFocusedDayBloc focusedDayBloc,
    required int index,
  }) : super(
          CalendarDayState.pure(
            calendarBloc,
            focusedDayBloc,
            index: index,
          ),
        );

  @override
  Stream<CalendarDayState> mapEventToState(
    CalendarDayEvent event,
  ) async* {
    if (event is CalendarDaySelectedDayUpdated) {
      yield* _mapSelectedDayUpdatedToState(event);
    }
  }

  Stream<CalendarDayState> _mapSelectedDayUpdatedToState(CalendarDaySelectedDayUpdated event) async* {
    if (this.state.isDaySelected(event.date)) {
      yield state.copyWith(isSelected: true);
    } else {
      yield state.copyWith(isSelected: false);
    }
  }
}
