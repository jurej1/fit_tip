import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/cupertino.dart';

part 'workout_detail_view_event.dart';
part 'workout_detail_view_state.dart';

class WorkoutDetailViewBloc extends Bloc<WorkoutDetailViewEvent, WorkoutDetailViewState> {
  WorkoutDetailViewBloc({
    required AuthenticationBloc authenticationBloc,
    required FitnessRepository fitnessRepository,
    required Workout workout,
  })  : this._fitnessRepository = fitnessRepository,
        super(WorkoutDetailViewInitial(workout)) {
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
  Stream<WorkoutDetailViewState> mapEventToState(
    WorkoutDetailViewEvent event,
  ) async* {
    if (event is WorkoutDetailViewDeleteRequested) {
      yield* _mapDeleteRequestedToState(event);
    } else if (event is WorkoutDetailViewSetAsActiveRequested) {
      yield* _mapSetAsActiveRequestedToState(event);
    } else if (event is WorkoutDetailViewWorkoutUpdated) {
      yield* _mapWorkoutUpdatedToState(event);
    }
  }

  Stream<WorkoutDetailViewState> _mapDeleteRequestedToState(WorkoutDetailViewDeleteRequested event) async* {
    if (_isAuth) {
      yield WorkoutDetailViewLoading(state.workout);

      try {
        await _fitnessRepository.deleteWorkout(_userId!, state.workout);
        yield WorkoutDetailViewDeleteSuccess(state.workout);
      } on Exception catch (_) {
        yield WorkoutDetailViewFail(state.workout);
      }
    }
  }

  Stream<WorkoutDetailViewState> _mapSetAsActiveRequestedToState(WorkoutDetailViewSetAsActiveRequested event) async* {
    if (_isAuth) {
      yield WorkoutDetailViewLoading(state.workout);

      try {
        Workout workout = await _fitnessRepository.setWorkoutAsActive(_userId!, state.workout);

        yield WorkoutDetailViewSetAsActiveSuccess(workout);
      } catch (e) {
        yield WorkoutDetailViewFail(state.workout);
      }
    }
  }

  Stream<WorkoutDetailViewState> _mapWorkoutUpdatedToState(WorkoutDetailViewWorkoutUpdated event) async* {
    if (_isAuth) yield WorkoutDetailViewInitial(event.workout);
  }
}
