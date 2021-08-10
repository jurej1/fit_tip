import 'dart:async';
import 'dart:developer';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fitness_repository/fitness_repository.dart';

import '../blocs.dart';

part 'focused_workout_day_event.dart';
part 'focused_workout_day_state.dart';

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

    _streamSubscription = activeWorkoutBloc.stream.listen((activeState) {
      if (activeState is ActiveWorkoutFail) {
        add(_FocusedWorkoutDayFailRequested());
      }
    });
  }

  final ActiveWorkoutBloc _activeWorkoutBloc;
  final FitnessRepository _fitnessRepository;
  final AuthenticationBloc _authenticationBloc;
  late final StreamSubscription _streamSubscription;

  bool get _isAuth => _authenticationBloc.state.isAuthenticated;
  User? get _user => _authenticationBloc.state.user;

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
    if (_activeWorkoutBloc.state is ActiveWorkoutLoadSuccess && _isAuth) {
      final activeState = _activeWorkoutBloc.state as ActiveWorkoutLoadSuccess;

      if (!activeState.workout.workouts.any((element) => element.day == event.value.weekday)) {
        yield FocusedWorkoutDayLoadSuccess(date: event.value);
      } else {
        yield FocusedWorkoutDayLoading();

        List<WorkoutDayLog> logs = await _fitnessRepository.getWorkoutDayLogByDate(_user!.id!, event.value);

        log('Logs by date: ' + logs.toString());
        yield FocusedWorkoutDayLoadSuccess(
          date: event.value,
          workoutDay: activeState.workout.workouts.firstWhere((element) => element.day == event.value.weekday),
          workoutDayLog: logs,
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
