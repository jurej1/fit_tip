import 'dart:async';
import 'dart:developer';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fitness_repository/fitness_repository.dart';

part 'workouts_list_event.dart';
part 'workouts_list_state.dart';

class WorkoutsListBloc extends Bloc<WorkoutsListEvent, WorkoutsListState> {
  WorkoutsListBloc({
    required FitnessRepository fitnessRepository,
    required AuthenticationBloc authenticationBloc,
  })  : _authenticationBloc = authenticationBloc,
        _fitnessRepository = fitnessRepository,
        super(WorkoutsListLoading());

  final FitnessRepository _fitnessRepository;
  final AuthenticationBloc _authenticationBloc;

  bool get _isAuth => _authenticationBloc.state.isAuthenticated;
  User? get _user => _authenticationBloc.state.user;

  @override
  Stream<WorkoutsListState> mapEventToState(
    WorkoutsListEvent event,
  ) async* {
    if (event is WorkoutsListLoadRequested) {
      yield* _mapLoadRequestToState();
    } else if (event is WorkoutsListItemAdded) {
      yield* _mapItemAddedToState(event);
    } else if (event is WorkoutsListItemRemoved) {
      yield* _mapItemRemovedToState(event);
    } else if (event is WorkoutsListItemUpdated) {
      yield* _mapItemUpdatedToState(event);
    } else if (event is WorkoutsListItemSetAsActive) {
      yield* _mapItemSetAsActive(event);
    }
  }

  Stream<WorkoutsListState> _mapLoadRequestToState() async* {
    if (!(state is WorkoutsListLoading)) return;

    if (!_isAuth) {
      yield WorkoutsListFail();
      return;
    }
    yield WorkoutsListLoading();

    try {
      QuerySnapshot querySnapshot = await _fitnessRepository.getWorkoutDayLogs(_user!.id!);

      List<Workout> workouts = Workout.fromQuerySnapshot(querySnapshot);

      yield WorkoutsListLoadSuccess(workouts);
    } catch (e) {
      log(e.toString());
      yield WorkoutsListFail();
    }
  }

  Stream<WorkoutsListState> _mapItemAddedToState(WorkoutsListItemAdded event) async* {
    if (state is WorkoutsListLoadSuccess && _isAuth) {
      final currentState = state as WorkoutsListLoadSuccess;

      List<Workout> workouts = List.from(currentState.workouts);

      workouts.add(event.workout);

      yield WorkoutsListLoadSuccess(workouts);
    }
  }

  Stream<WorkoutsListState> _mapItemRemovedToState(WorkoutsListItemRemoved event) async* {
    if (state is WorkoutsListLoadSuccess) {
      final currentState = state as WorkoutsListLoadSuccess;

      List<Workout> workouts = List.from(currentState.workouts);

      workouts.remove(event.workout);

      yield WorkoutsListLoadSuccess(workouts);
    }
  }

  Stream<WorkoutsListState> _mapItemUpdatedToState(WorkoutsListItemUpdated event) async* {
    if (state is WorkoutsListLoadSuccess) {
      final currentState = state as WorkoutsListLoadSuccess;

      List<Workout> workouts = List.from(currentState.workouts);

      workouts = workouts.map((e) {
        if (e.id == event.workout.id) {
          return event.workout;
        }

        return e;
      }).toList();

      yield WorkoutsListLoadSuccess(workouts);
    }
  }

  Stream<WorkoutsListState> _mapItemSetAsActive(WorkoutsListItemSetAsActive event) async* {
    if (state is WorkoutsListLoadSuccess) {
      final currentState = state as WorkoutsListLoadSuccess;

      List<Workout> workouts = List.from(currentState.workouts);

      workouts = workouts.map((e) {
        if (e.id == event.workout.id) return event.workout;
        if (e.isActive) return e.copyWith(isActive: false);
        return e;
      }).toList();

      yield WorkoutsListLoadSuccess(workouts);
    }
  }
}
