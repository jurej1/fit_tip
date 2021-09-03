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
    required WorkoutInfo info,
    required AuthenticationBloc authenticationBloc,
    required FitnessRepository fitnessRepository,
  })  : _fitnessRepository = fitnessRepository,
        _authenticationBloc = authenticationBloc,
        super(WorkoutsListCardInitial(info, false));

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
      yield WorkoutsListCardLoading(state.info, state.isExpanded);

      try {
        await _fitnessRepository.deleteWorkout(state.info.id);

        yield WorkoutsListCardDeleteSuccess(state.info, state.isExpanded);
      } catch (e) {
        yield WorkoutsListCardFail(state.info, state.isExpanded);
      }
    }
  }

  Stream<WorkoutsListCardState> _mapExpandedButtonPressedToState() async* {
    yield WorkoutsListCardInitial(state.info, !state.isExpanded);
  }

  Stream<WorkoutsListCardState> _mapSetAsActiveRequested() async* {
    //TODO set workout as active
    // if (_authenticationBloc.state.isAuthenticated) {
    //   yield WorkoutsListCardLoading(state.info, state.isExpanded);

    //   try {
    //     await _fitnessRepository.setActiveWorkoutStatus(_authenticationBloc.state.user!.uid!, state.info.id);

    //     yield WorkoutsListCardSetAsActiveSuccess(state.info.copyWith(isActive: true), state.isExpanded);
    //   } catch (e) {
    //     yield WorkoutsListCardFail(state.info, state.isExpanded);
    //   }
    // }
  }
}
