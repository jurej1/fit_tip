import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/fitness_tracking/blocs/blocs.dart';

part 'calendar_day_event.dart';
part 'calendar_day_state.dart';

class CalendarDayBloc extends Bloc<CalendarDayEvent, CalendarDayState> {
  CalendarDayBloc({
    required CalendarBloc calendarBloc,
    required int index,
  }) : super(
          CalendarDayState.calculateFromIndex(
            calendarBloc.state.firstDay,
            index: index,
          ),
        );

  @override
  Stream<CalendarDayState> mapEventToState(
    CalendarDayEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
