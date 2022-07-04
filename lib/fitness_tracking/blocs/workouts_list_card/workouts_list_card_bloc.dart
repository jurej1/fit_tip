import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/material.dart';

part 'workouts_list_card_event.dart';
part 'workouts_list_card_state.dart';

class WorkoutsListCardBloc extends Bloc<WorkoutsListCardEvent, WorkoutsListCardState> {
  WorkoutsListCardBloc({
    required WorkoutInfoRaw info,
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
    if (event is WorkoutsListCardExpandedButtonPressed) {
      yield* _mapExpandedButtonPressedToState();
    } else if (event is WorkoutsListCardSetAsActiveRequested) {
      yield* _mapSetAsActiveRequested();
    }
  }

  Stream<WorkoutsListCardState> _mapExpandedButtonPressedToState() async* {
    yield WorkoutsListCardInitial(state.info, !state.isExpanded);
  }

  Stream<WorkoutsListCardState> _mapSetAsActiveRequested() async* {
    if (_authenticationBloc.state.isAuthenticated && state.info.isWorkoutInfo) {
      yield WorkoutsListCardLoading(state.info, state.isExpanded);

      WorkoutInfo info = state.info as WorkoutInfo;

      try {
        await _fitnessRepository.setWorkoutAsActiveFromWorkoutInfo(_authenticationBloc.state.user!.uid!, info);

        yield WorkoutsListCardSetAsActiveSuccess(info.copyWith(isActive: true), state.isExpanded);
      } catch (e) {
        log(e.toString());
        yield WorkoutsListCardFail(state.info, state.isExpanded);
      }
    }
  }
}
