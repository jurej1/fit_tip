import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/cupertino.dart';

part 'workout_detail_view_event.dart';
part 'workout_detail_view_state.dart';

class WorkoutDetailViewBloc extends Bloc<WorkoutDetailViewEvent, WorkoutDetailViewState> {
  WorkoutDetailViewBloc({
    required FitnessRepository fitnessRepository,
    required WorkoutInfo info,
  })  : this._fitnessRepository = fitnessRepository,
        super(WorkoutDetailViewLoading(Workout(info: info)));

  final FitnessRepository _fitnessRepository;
  @override
  Stream<WorkoutDetailViewState> mapEventToState(
    WorkoutDetailViewEvent event,
  ) async* {
    if (event is WorkoutDetailViewWorkoutUpdated) {
      yield* _mapWorkoutUpdatedToState(event);
    } else if (event is WorkoutDetailViewDaysLoadRequested) {
      yield* _mapWorkoutDaysLoadRequestedToState();
    }
  }

  Stream<WorkoutDetailViewState> _mapWorkoutUpdatedToState(WorkoutDetailViewWorkoutUpdated event) async* {
    if (event is WorkoutDetailViewLoadSuccess) {
      final oldState = state as WorkoutDetailViewLoadSuccess;

      Workout workout = oldState.workout;

      workout = workout.copyWith(
        info: event.workout.info,
        workoutDays: event.workout.workoutDays,
      );

      yield WorkoutDetailViewLoadSuccess(workout);
    }
  }

  Stream<WorkoutDetailViewState> _mapWorkoutDaysLoadRequestedToState() async* {
    yield WorkoutDetailViewLoading(this.state.workout);

    try {
      final WorkoutInfo info = state.workout.info;

      DocumentSnapshot snap = await _fitnessRepository.getWorkoutDaysById(info.id);

      WorkoutDays days = WorkoutDays.fromEntity(WorkoutDaysEntity.fromDocumentSnapshot(snap));

      yield WorkoutDetailViewLoadSuccess(this.state.workout.copyWith(workoutDays: days));
    } catch (error) {
      yield WorkoutDetailViewFail(this.state.workout);
    }
  }
}
