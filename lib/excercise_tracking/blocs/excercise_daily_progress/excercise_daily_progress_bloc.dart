import 'dart:async';

import 'package:activity_repository/activity_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/excercise_tracking/excercise_tracking.dart';
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
        super(ExcerciseDailyProgressLoading()) {
    final _goalState = _excerciseDailyGoalBloc.state;

    if (_goalState is ExcerciseDailyGoalLoadSuccess) {
      add(_ExcerciseDailyProgressGoalUpdated(_goalState.goal));
    } else if (_goalState is ExcerciseDailyGoalFailure) {
      add(_ExcerciseDailyProgressGoalFailRequested());
    }

    _goalSubscription = _excerciseDailyGoalBloc.stream.listen((goalState) {
      if (goalState is ExcerciseDailyGoalLoadSuccess) {
        add(_ExcerciseDailyProgressGoalUpdated(goalState.goal));
      } else if (goalState is ExcerciseDailyGoalFailure) {
        add(_ExcerciseDailyProgressGoalFailRequested());
      }
    });

    final _listState = _excerciseDailyListBloc.state;

    if (_listState is ExcerciseDailyListLoadSuccess) {
      add(_ExcerciseDailyProgressExcercisesUpdated(_listState.excercises));
    } else if (_listState is ExcerciseDailyListFailure) {
      add(_ExcerciseDailyProgressGoalFailRequested());
    }

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
        minutesPerDay: calculateMinutesWorokutFromExcercises(event.excercises),
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
        minutesPerDay: calculateMinutesWorokutFromExcercises(listState.excercises),
      );
    }
  }

  Stream<ExcerciseDailyProgressState> _mapViewUpdatedToState(ExcerciseDailyProgressViewUpdated event) async* {
    if (state is ExcerciseDailyProgressLoadSuccess) {
      print('View changed');
      final currentState = state as ExcerciseDailyProgressLoadSuccess;

      yield currentState.copyWith(
        view: ExcerciseDailyProgressView.values.elementAt(event.index),
      );
    }
  }

  int calculateCalorieBurnedFromExcercises(List<ExcerciseLog> excercises) {
    return excercises.fold(0, (p, e) => p + e.calories);
  }

  int calculateMinutesWorokutFromExcercises(List<ExcerciseLog> excercises) {
    return excercises.fold(0, (p, e) => p + e.duration);
  }

  int calculateAvgMinutesPerWorkoutFromExcercises(List<ExcerciseLog> excercises) {
    if (excercises.isEmpty) return 0;

    return (calculateMinutesWorokutFromExcercises(excercises) / excercises.length).round();
  }
}
