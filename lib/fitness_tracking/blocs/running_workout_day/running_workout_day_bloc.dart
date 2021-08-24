import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  })  : _fitnessRepository = fitnessRepository,
        super(
          RunningWorkoutDayInitial(
            WorkoutDayLog(
              created: date,
              workoutId: workoutDay.workoutId,
              excercises: workoutDay.excercises,
              id: UniqueKey().toString(),
              workoutDayId: workoutDay.id,
              musclesTargeted: workoutDay.musclesTargeted,
            ),
            0,
          ),
        ) {
    final authState = authenticationBloc.state;

    _isAuth = authState.isAuthenticated;
    _userId = authState.user?.uid;
    _authSubscription = authenticationBloc.stream.listen((authState) {
      _isAuth = authState.isAuthenticated;
      _userId = authState.user?.uid;
    });
  }

  final FitnessRepository _fitnessRepository;
  late final StreamSubscription _authSubscription;

  bool _isAuth = false;
  String? _userId;

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }

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
    } else if (event is RunningWorkoutDayWorkoutDurationUpdated) {
      yield* _mapDurationUpdatedToState(event);
    }
  }

  Stream<RunningWorkoutDayState> _mapExcerciseUpdatetToState(RunningWorkoutDayWorkoutExcerciseUpdated event) async* {
    WorkoutDayLog log = this.state.log;
    List<WorkoutExcercise> excercises = log.excercises;

    excercises = excercises.map((e) {
      if (e.id == event.excercise.id) {
        return event.excercise;
      }
      return e;
    }).toList();

    yield RunningWorkoutDayInitial(log.copyWith(excercises: excercises), state.pageViewIndex);
  }

  Stream<RunningWorkoutDayState> _mapExcerciseSubmitToState(RunningWorkoutDayWorkoutExcerciseSubmit event) async* {
    if (_isAuth) {
      try {
        final now = DateTime.now();
        final dateCreated = DateTime(
          state.log.created.year,
          state.log.created.month,
          state.log.created.day,
          now.hour,
          now.minute,
          now.second,
        );
        final log = state.log.copyWith(created: dateCreated);
        yield RunningWorkoutDayLoading(
          log,
          state.pageViewIndex,
        );

        DocumentReference ref = await _fitnessRepository.addWorkoutDayLog(
          _userId!,
          state.log,
        );
        yield RunningWorkoutDayLoadSuccess(state.log.copyWith(id: ref.id), state.pageViewIndex);
      } catch (error) {
        yield RunningWorkoutDayFail(state.log, state.pageViewIndex);
      }
    } else {
      yield RunningWorkoutDayFail(
        state.log,
        state.pageViewIndex,
      );
    }
  }

  Stream<RunningWorkoutDayState> _mapDurationUpdatedToState(RunningWorkoutDayWorkoutDurationUpdated event) async* {
    yield RunningWorkoutDayInitial(state.log.copyWith(duration: event.duration), state.pageViewIndex);
  }
}
