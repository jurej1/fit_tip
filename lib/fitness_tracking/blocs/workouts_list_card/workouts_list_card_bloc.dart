import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
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

  final AuthenticationBloc _authenticationBloc;
  final FitnessRepository _fitnessRepository;

  bool get _isAuth => _authenticationBloc.state.isAuthenticated;
  User? get _user => _authenticationBloc.state.user;

  @override
  Stream<WorkoutsListCardState> mapEventToState(
    WorkoutsListCardEvent event,
  ) async* {
    if (event is WorkoutsListCardDeleteRequested) {
      yield* _mapDeleteRequestedToState(event);
    } else if (event is WorkoutsListCardExpandedButtonPressed) {
      yield* _mapExpandedButtonPressedToState();
    }
  }

  Stream<WorkoutsListCardState> _mapDeleteRequestedToState(WorkoutsListCardDeleteRequested event) async* {
    if (_isAuth) {
      yield WorkoutsListCardLoading(state.workout, state.isExpanded);

      try {
        await _fitnessRepository.deleteWorkout(_user!.id!, state.workout);

        yield WorkoutsListCardDeleteSuccess(state.workout, state.isExpanded);
      } catch (e) {
        yield WorkoutsListCardFail(state.workout, state.isExpanded);
      }
    }
  }

  Stream<WorkoutsListCardState> _mapExpandedButtonPressedToState() async* {
    yield WorkoutsListCardInitial(state.workout, !state.isExpanded);
  }
}
