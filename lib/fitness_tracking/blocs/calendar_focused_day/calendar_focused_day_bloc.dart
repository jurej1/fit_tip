import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'calendar_focused_day_event.dart';

class CalendarFocusedDayBloc extends Bloc<CalendarFocusedDayEvent, DateTime> {
  CalendarFocusedDayBloc() : super(DateTime.now());

  @override
  Stream<DateTime> mapEventToState(
    CalendarFocusedDayEvent event,
  ) async* {
    if (event is CalendarFocusedDayUpdated) {
      yield event.value;
    }
  }
}
