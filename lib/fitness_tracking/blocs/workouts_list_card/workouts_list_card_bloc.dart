import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/material.dart';

part 'workouts_list_card_event.dart';
part 'workouts_list_card_state.dart';

class WorkoutsListCardBloc extends Bloc<WorkoutsListCardEvent, WorkoutsListCardState> {
  WorkoutsListCardBloc({
    required Workout workout,
    required AuthenticationBloc authenticationBloc,
    required FitnessRepository fitnessRepository,
  })  : _fitnessRepository = fitnessRepository,
        _authenticationBloc = authenticationBloc,
        super(WorkoutsListCardInitial(workout, false));

  final FitnessRepository _fitnessRepository;
  final AuthenticationBloc _authenticationBloc;

  @override
  Stream<WorkoutsListCardState> mapEventToState(
    WorkoutsListCardEvent event,
  ) async* {
    if (event is WorkoutsListCardDeleteRequested) {
      yield* _mapDeleteRequestedToState(event);
    } else if (event is WorkoutsListCardExpandedButtonPressed) {
      yield* _mapExpandedButtonPressedToState();
    } else if (event is WorkoutsListCardSetAsActiveRequested) {
      yield* _mapSetAsActiveRequested();
    }
  }

  Stream<WorkoutsListCardState> _mapDeleteRequestedToState(WorkoutsListCardDeleteRequested event) async* {
    if (_authenticationBloc.state.isAuthenticated) {
      yield WorkoutsListCardLoading(state.workout, state.isExpanded);

      try {
        await _fitnessRepository.deleteWorkout(state.workout.info.id);

        yield WorkoutsListCardDeleteSuccess(state.workout, state.isExpanded);
      } catch (e) {
        yield WorkoutsListCardFail(state.workout, state.isExpanded);
      }
    }
  }

  Stream<WorkoutsListCardState> _mapExpandedButtonPressedToState() async* {
    yield WorkoutsListCardInitial(state.workout, !state.isExpanded);
  }

  Stream<WorkoutsListCardState> _mapSetAsActiveRequested() async* {
    if (state.workout.isActive) return;

    if (_authenticationBloc.state.isAuthenticated) {
      yield WorkoutsListCardLoading(state.workout, state.isExpanded);

      try {
        //TODO set workout as active
        // Workout newWorkout = await _fitnessRepository.setWorkoutAsActive(_userId!, state.workout);

        // yield WorkoutsListCardSetAsActiveSuccess(newWorkout, state.isExpanded);
      } catch (e) {
        yield WorkoutsListCardFail(state.workout, state.isExpanded);
      }
    }
  }
}
