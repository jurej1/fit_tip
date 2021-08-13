import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/fitness_tracking/blocs/active_workout_bloc/active_workout_bloc.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:table_calendar/table_calendar.dart';

part 'table_calendar_event.dart';
part 'table_calendar_state.dart';

class TableCalendarBloc extends Bloc<TableCalendarEvent, TableCalendarState> {
  TableCalendarBloc({required ActiveWorkoutBloc activeWorkoutBloc})
      : super(
          activeWorkoutBloc.state is ActiveWorkoutLoadSuccess
              ? TableCalendarLoadSuccess(
                  focusedDay: DateTime.now(),
                  firstDay: (activeWorkoutBloc.state as ActiveWorkoutLoadSuccess).workout.created,
                  lastDay: (activeWorkoutBloc.state as ActiveWorkoutLoadSuccess).workout.lastDay,
                  workouts: (activeWorkoutBloc.state as ActiveWorkoutLoadSuccess).workout.workouts,
                )
              : TableCalendarLoading(),
        );

  @override
  Stream<TableCalendarState> mapEventToState(
    TableCalendarEvent event,
  ) async* {
    if (event is TableCalendarFocusedDayUpdated) {
      yield* _mapFocusedDayUpdatedToState(event);
    } else if (event is TableCalendarFormatUpdated) {
      yield* _mapFormatUpdatedToState(event);
    } else if (event is TableCalendarWorkoutUpdated) {
      if (state is TableCalendarLoadSuccess) {
        final current = state as TableCalendarLoadSuccess;

        yield current.copyWith(
          firstDay: event.value.created,
          lastDay: event.value.lastDay,
          workouts: event.value.workouts,
        );
      }
      yield TableCalendarLoadSuccess(
        focusedDay: DateTime.now(),
        firstDay: event.value.created,
        lastDay: event.value.lastDay,
        workouts: event.value.workouts,
      );
    }
  }

  Stream<TableCalendarState> _mapFocusedDayUpdatedToState(TableCalendarFocusedDayUpdated event) async* {
    if (state is TableCalendarLoadSuccess) {
      yield (state as TableCalendarLoadSuccess).copyWith(focusedDay: event.value);
    }
  }

  Stream<TableCalendarState> _mapFormatUpdatedToState(TableCalendarFormatUpdated event) async* {
    if (state is TableCalendarLoadSuccess) {
      yield (state as TableCalendarLoadSuccess).copyWith(format: event.value);
    }
  }
}
