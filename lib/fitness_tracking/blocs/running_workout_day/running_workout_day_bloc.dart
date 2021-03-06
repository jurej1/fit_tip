import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/cupertino.dart';

import '../blocs.dart';

part 'running_workout_day_event.dart';
part 'running_workout_day_state.dart';

class RunningWorkoutDayBloc extends Bloc<RunningWorkoutDayEvent, RunningWorkoutDayState> {
  RunningWorkoutDayBloc({
    required WorkoutDay workoutDay,
    required AuthenticationBloc authenticationBloc,
    required FitnessRepository fitnessRepository,
    required DateTime date,
    required TimerBloc timerBloc,
  })  : _fitnessRepository = fitnessRepository,
        _authenticationBloc = authenticationBloc,
        _timerBloc = timerBloc,
        super(RunningWorkoutDayState.initial(date, workoutDay, authenticationBloc));
  final FitnessRepository _fitnessRepository;
  final AuthenticationBloc _authenticationBloc;
  final TimerBloc _timerBloc;

  bool get _isAuth => _authenticationBloc.state.isAuthenticated;
  String? get _userId => _authenticationBloc.state.user?.uid;

  @override
  Stream<RunningWorkoutDayState> mapEventToState(
    RunningWorkoutDayEvent event,
  ) async* {
    if (event is RunningWorkoutDayPageIndexUpdated) {
      yield RunningWorkoutDayInitial(state.log, event.value);
    } else if (event is RunningWorkoutDayWorkoutExcerciseUpdated) {
      yield* _mapExcerciseUpdatetToState(event);
    } else if (event is RunningWorkoutDayWorkoutExcerciseSubmit) {
      yield* _mapExcerciseSubmitToState(event);
    }
  }

  Stream<RunningWorkoutDayState> _mapExcerciseUpdatetToState(RunningWorkoutDayWorkoutExcerciseUpdated event) async* {
    WorkoutDayLog workoutLog = this.state.log;
    List<WorkoutExcercise> excercises = workoutLog.excercises ?? [];

    excercises = excercises.map((e) {
      if (e.id == event.excercise.id) {
        return event.excercise;
      }
      return e;
    }).toList();

    yield RunningWorkoutDayInitial(workoutLog.copyWith(excercises: excercises), state.pageViewIndex);
  }

  Stream<RunningWorkoutDayState> _mapExcerciseSubmitToState(RunningWorkoutDayWorkoutExcerciseSubmit event) async* {
    if (_isAuth) {
      try {
        yield RunningWorkoutDayLoading(
          state.log,
          state.pageViewIndex,
        );

        WorkoutDayLog workoutLog = state.log.copyWith(duration: _timerBloc.state.duration);
        DocumentReference ref = await _fitnessRepository.addWorkoutDayLog(workoutLog);
        workoutLog = workoutLog.copyWith(id: ref.id);

        yield RunningWorkoutDayLoadSuccess(workoutLog, state.pageViewIndex);
      } catch (error) {
        log(error.toString());
        yield RunningWorkoutDayFail(state.log, state.pageViewIndex);
      }
    } else {
      yield RunningWorkoutDayFail(
        state.log,
        state.pageViewIndex,
      );
    }
  }
}
