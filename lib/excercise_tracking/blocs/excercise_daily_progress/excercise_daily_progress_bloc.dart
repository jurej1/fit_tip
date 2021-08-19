import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/excercise_tracking/excercise_tracking.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/material.dart';

import '../blocs.dart';

part 'excercise_daily_progress_event.dart';
part 'excercise_daily_progress_state.dart';

class ExcerciseDailyProgressBloc extends Bloc<ExcerciseDailyProgressEvent, ExcerciseDailyProgressState> {
  ExcerciseDailyProgressBloc({
    required ExcerciseDailyListBloc excerciseDailyListBloc,
    required ExcerciseDailyGoalBloc excerciseDailyGoalBloc,
  })  : this._excerciseDailyGoalBloc = excerciseDailyGoalBloc,
        this._excerciseDailyListBloc = excerciseDailyListBloc,
        super(ExcerciseDailyProgressState.initial(listBloc: excerciseDailyListBloc, goalBloc: excerciseDailyGoalBloc)) {
    _goalSubscription = _excerciseDailyGoalBloc.stream.listen((goalState) {
      if (goalState is ExcerciseDailyGoalLoadSuccess) {
        add(_ExcerciseDailyProgressGoalUpdated(goalState.goal));
      } else if (goalState is ExcerciseDailyGoalFailure) {
        add(_ExcerciseDailyProgressGoalFailRequested());
      }
    });

    _listSubscription = _excerciseDailyListBloc.stream.listen((listState) {
      if (listState is ExcerciseDailyListLoadSuccess) {
        add(_ExcerciseDailyProgressExcercisesUpdated(listState.excercises));
      } else if (listState is ExcerciseDailyListFailure) {
        add(_ExcerciseDailyProgressGoalFailRequested());
      }
    });
  }

  final ExcerciseDailyGoalBloc _excerciseDailyGoalBloc;
  final ExcerciseDailyListBloc _excerciseDailyListBloc;

  late final StreamSubscription _goalSubscription;
  late final StreamSubscription _listSubscription;

  @override
  Stream<ExcerciseDailyProgressState> mapEventToState(
    ExcerciseDailyProgressEvent event,
  ) async* {
    if (event is _ExcerciseDailyProgressExcercisesUpdated) {
      yield* _mapExcercisesUpdatedToState(event);
    } else if (event is _ExcerciseDailyProgressGoalUpdated) {
      yield* _mapGoalUpdatedToState(event);
    } else if (event is ExcerciseDailyProgressViewUpdated) {
      yield* _mapViewUpdatedToState(event);
    }
  }

  @override
  Future<void> close() {
    _listSubscription.cancel();
    _goalSubscription.cancel();
    return super.close();
  }

  Stream<ExcerciseDailyProgressState> _mapExcercisesUpdatedToState(_ExcerciseDailyProgressExcercisesUpdated event) async* {
    if (_excerciseDailyGoalBloc.state is ExcerciseDailyGoalLoadSuccess) {
      final goalState = _excerciseDailyGoalBloc.state as ExcerciseDailyGoalLoadSuccess;

      yield ExcerciseDailyProgressLoadSuccess(
        goal: goalState.goal,
        avgMinutesPerWorkout: calculateAvgMinutesPerWorkoutFromExcercises(event.excercises),
        caloriesBurnedPerDay: calculateCalorieBurnedFromExcercises(event.excercises),
        minutesPerDay: calculateMinutesWorkoutFromExcercises(event.excercises),
      );
    }
  }

  Stream<ExcerciseDailyProgressState> _mapGoalUpdatedToState(_ExcerciseDailyProgressGoalUpdated event) async* {
    if (_excerciseDailyListBloc.state is ExcerciseDailyListLoadSuccess) {
      final listState = _excerciseDailyListBloc.state as ExcerciseDailyListLoadSuccess;
      yield ExcerciseDailyProgressLoadSuccess(
        goal: event.goal,
        avgMinutesPerWorkout: calculateAvgMinutesPerWorkoutFromExcercises(listState.excercises),
        caloriesBurnedPerDay: calculateCalorieBurnedFromExcercises(listState.excercises),
        minutesPerDay: calculateMinutesWorkoutFromExcercises(listState.excercises),
      );
    }
  }

  Stream<ExcerciseDailyProgressState> _mapViewUpdatedToState(ExcerciseDailyProgressViewUpdated event) async* {
    if (state is ExcerciseDailyProgressLoadSuccess) {
      final currentState = state as ExcerciseDailyProgressLoadSuccess;

      yield currentState.copyWith(
        view: ExcerciseDailyProgressView.values.elementAt(event.index),
      );
    }
  }

  int calculateCalorieBurnedFromExcercises(List<ExcerciseLog> excercises) {
    return excercises.fold(0, (p, e) => p + e.calories);
  }

  int calculateMinutesWorkoutFromExcercises(List<ExcerciseLog> excercises) {
    return excercises.fold(0, (p, e) => p + e.duration);
  }

  int calculateAvgMinutesPerWorkoutFromExcercises(List<ExcerciseLog> excercises) {
    if (excercises.isEmpty) return 0;

    return (calculateMinutesWorkoutFromExcercises(excercises) / excercises.length).round();
  }
}
