import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/cupertino.dart';

part 'running_workout_day_event.dart';
part 'running_workout_day_state.dart';

class RunningWorkoutDayBloc extends Bloc<RunningWorkoutDayEvent, RunningWorkoutDayState> {
  RunningWorkoutDayBloc({
    required WorkoutDay workoutDay,
    required AuthenticationBloc authenticationBloc,
    required FitnessRepository fitnessRepository,
    required DateTime date,
  })  : _authenticationBloc = authenticationBloc,
        _fitnessRepository = fitnessRepository,
        super(
          RunningWorkoutDayInitial(
            log: WorkoutDayLog(
              created: date,
              workoutId: workoutDay.workoutId,
              excercises: workoutDay.excercises,
              id: UniqueKey().toString(),
              workoutDayId: workoutDay.id,
              musclesTargeted: workoutDay.musclesTargeted,
            ),
            pageViewIndex: 0,
          ),
        );

  final AuthenticationBloc _authenticationBloc;
  final FitnessRepository _fitnessRepository;

  bool get _isAuth => _authenticationBloc.state.isAuthenticated;
  User? get _user => _authenticationBloc.state.user;

  @override
  Stream<RunningWorkoutDayState> mapEventToState(
    RunningWorkoutDayEvent event,
  ) async* {
    if (event is RunningWorkoutDayPageIndexUpdated) {
      yield RunningWorkoutDayInitial(pageViewIndex: event.value, log: state.log);
    } else if (event is RunningWorkoutDayWorkoutExcerciseUpdated) {
      yield* _mapExcerciseUpdatetToState(event);
    } else if (event is RunningWorkoutDayWorkoutExcerciseSubmit) {
      yield* _mapExcerciseSubmitToState(event);
    }
  }

  Stream<RunningWorkoutDayState> _mapExcerciseUpdatetToState(RunningWorkoutDayWorkoutExcerciseUpdated event) async* {
    WorkoutDayLog log = this.state.log;
    List<WorkoutExcercise> excercises = log.excercises;

    excercises = excercises.map((e) {
      if (e.id == event.excercise.id) return event.excercise;
      return e;
    }).toList();

    yield RunningWorkoutDayInitial(log: log.copyWith(excercises: excercises), pageViewIndex: state.pageViewIndex);
  }

  Stream<RunningWorkoutDayState> _mapExcerciseSubmitToState(RunningWorkoutDayWorkoutExcerciseSubmit event) async* {
    if (_isAuth) {
      try {
        yield RunningWorkoutDayLoading(
          log: state.log,
          pageViewIndex: state.pageViewIndex,
        );

        // _fitnessRepository.addWorkoutLog(_user!.id!, workout, dateLogged);
      } catch (error) {}
    } else {
      yield RunningWorkoutDayFailure(
        log: state.log,
        pageViewIndex: state.pageViewIndex,
      );
    }
  }
}
