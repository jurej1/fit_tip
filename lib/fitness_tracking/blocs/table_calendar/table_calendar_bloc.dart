import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:table_calendar/table_calendar.dart';

part 'table_calendar_event.dart';
part 'table_calendar_state.dart';

class TableCalendarBloc extends Bloc<TableCalendarEvent, TableCalendarState> {
  TableCalendarBloc({required Workout workout}) : super(TableCalendarState.pure(workout));

  @override
  Stream<TableCalendarState> mapEventToState(
    TableCalendarEvent event,
  ) async* {
    if (event is TableCalendarFocusedDayUpdated) {
      yield state.copyWith(focusedDay: event.value);
    }
  }
}
