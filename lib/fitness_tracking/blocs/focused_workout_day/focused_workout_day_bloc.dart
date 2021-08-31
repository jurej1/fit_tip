import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fitness_repository/fitness_repository.dart';

import '../blocs.dart';

part 'focused_workout_day_event.dart';
part 'focused_workout_day_state.dart';

//TODO clean this bloc

class FocusedWorkoutDayBloc extends Bloc<FocusedWorkoutDayEvent, FocusedWorkoutDayState> {
  FocusedWorkoutDayBloc({
    required ActiveWorkoutBloc activeWorkoutBloc,
    required TableCalendarBloc tableCalendarBloc,
    required FitnessRepository fitnessRepository,
    required AuthenticationBloc authenticationBloc,
  })  : _activeWorkoutBloc = activeWorkoutBloc,
        _fitnessRepository = fitnessRepository,
        _authenticationBloc = authenticationBloc,
        super(FocusedWorkoutDayLoading()) {
    if (tableCalendarBloc.state is TableCalendarLoadSuccess) {
      add(FocusedWorkoutDayDateUpdated((tableCalendarBloc.state as TableCalendarLoadSuccess).focusedDay));
    }

    _activeWorkoutSubscription = activeWorkoutBloc.stream.listen((activeState) {
      if (activeState is ActiveWorkoutFail) {
        add(_FocusedWorkoutDayFailRequested());
      }
    });
  }

  final ActiveWorkoutBloc _activeWorkoutBloc;
  final FitnessRepository _fitnessRepository;
  late final StreamSubscription _activeWorkoutSubscription;
  final AuthenticationBloc _authenticationBloc;

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
    if (_activeWorkoutBloc.state is ActiveWorkoutLoadSuccess && _authenticationBloc.state.isAuthenticated) {
      final activeState = _activeWorkoutBloc.state as ActiveWorkoutLoadSuccess;

      if (!activeState.workout.workouts.any((element) => element.day == event.value.weekday)) {
        yield FocusedWorkoutDayLoadSuccess(date: event.value);
      } else {
        yield FocusedWorkoutDayLoading();
        WorkoutDay workoutDay = activeState.workout.workouts.firstWhere((element) => element.day == event.value.weekday);

        List<WorkoutDayLog> logs = await _fitnessRepository.getWorkoutDayLogByDate(_authenticationBloc.state.user!.uid!, event.value);

        yield FocusedWorkoutDayLoadSuccess(
          date: event.value,
          workoutDay: workoutDay,
          workoutDayLog: logs,
          isWorkoutCompleted: logs.isEmpty ? false : true,
        );
      }
    } else {
      yield FocusedWorkoutDayFail();
    }
  }

  @override
  Future<void> close() {
    _activeWorkoutSubscription.cancel();
    return super.close();
  }
}
