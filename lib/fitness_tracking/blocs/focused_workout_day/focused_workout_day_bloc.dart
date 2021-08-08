import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness_repository/fitness_repository.dart';

import '../blocs.dart';

part 'focused_workout_day_event.dart';
part 'focused_workout_day_state.dart';

class FocusedWorkoutDayBloc extends Bloc<FocusedWorkoutDayEvent, FocusedWorkoutDayState> {
  FocusedWorkoutDayBloc({
    required ActiveWorkoutBloc activeWorkoutBloc,
    required TableCalendarBloc tableCalendarBloc,
  })  : _activeWorkoutBloc = activeWorkoutBloc,
        super(FocusedWorkoutDayLoading()) {
    if (tableCalendarBloc.state is TableCalendarLoadSuccess) {
      add(FocusedWorkoutDayDateUpdated((tableCalendarBloc.state as TableCalendarLoadSuccess).focusedDay));
    }

    _streamSubscription = activeWorkoutBloc.stream.listen((activeState) {
      if (activeState is ActiveWorkoutFail) {
        add(_FocusedWorkoutDayFailRequested());
      }
    });
  }

  final ActiveWorkoutBloc _activeWorkoutBloc;

  late final StreamSubscription _streamSubscription;

  @override
  Stream<FocusedWorkoutDayState> mapEventToState(
    FocusedWorkoutDayEvent event,
  ) async* {
    if (event is _FocusedWorkoutDayFailRequested) {
      yield FocusedWorkoutDayFail();
    } else if (event is FocusedWorkoutDayDateUpdated) {
      yield* _mapDateUpdatedToState(event);
    }
  }

  Stream<FocusedWorkoutDayState> _mapDateUpdatedToState(FocusedWorkoutDayDateUpdated event) async* {
    if (_activeWorkoutBloc.state is ActiveWorkoutLoadSuccess) {
      final activeState = _activeWorkoutBloc.state as ActiveWorkoutLoadSuccess;

      if (!activeState.workout.workouts.any((element) => element.day == event.value.weekday)) {
        yield FocusedWorkoutDayLoadSuccess();
      } else {
        yield FocusedWorkoutDayLoading();

        yield FocusedWorkoutDayLoadSuccess(
          activeState.workout.workouts.firstWhere((element) => element.day == event.value.weekday),
        );
      }
    } else {
      yield FocusedWorkoutDayFail();
    }
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}
