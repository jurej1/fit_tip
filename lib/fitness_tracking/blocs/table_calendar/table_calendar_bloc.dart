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
                  firstDay:
                      (activeWorkoutBloc.state as ActiveWorkoutLoadSuccess).workout.info.created, // TODO: Hier should be the start date
                  // lastDay: (activeWorkoutBloc.state as ActiveWorkoutLoadSuccess).workout.info.lastDay,
                  workouts: (activeWorkoutBloc.state as ActiveWorkoutLoadSuccess).workout.workoutDays!.workoutDays, //TODO
                  lastDay: (activeWorkoutBloc.state as ActiveWorkoutLoadSuccess).workout.info.created.add(Duration(days: 50)), //TODO
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
          //TODO
          firstDay: event.value.info.created,
          // lastDay: event.value.lastDay,
          workouts: event.value.workoutDays!.workoutDays, //TODO
          lastDay: event.value.info.created.add(Duration(days: 50)),
        );
      }
      yield TableCalendarLoadSuccess(
        //TODO
        focusedDay: DateTime.now(),
        firstDay: event.value.info.created,
        // lastDay: event.value.lastDay,
        workouts: event.value.workoutDays!.workoutDays,
        lastDay: event.value.info.created.add(Duration(days: 50)), // TODO
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
