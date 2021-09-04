import 'dart:async';
import 'dart:developer';

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
  })  : _fitnessRepository = fitnessRepository,
        _authenticationBloc = authenticationBloc,
        super(WorkoutsListLoading());

  final FitnessRepository _fitnessRepository;
  final AuthenticationBloc _authenticationBloc;

  final int _limit = 12;
  late DocumentSnapshot _lastFetchedDoc;

  bool get _isAuth => _authenticationBloc.state.isAuthenticated;
  String? get _userId => _authenticationBloc.state.user?.uid;

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
    } else if (event is WorkoutsListLoadMoreRequested) {
      yield* _mapLoadMoreRequested();
    }
  }

  Stream<WorkoutsListState> _mapLoadRequestToState() async* {
    yield WorkoutsListLoading();

    try {
      QuerySnapshot querySnapshot = await _fitnessRepository.getWorkoutInfosByCreated(limit: _limit);

      if (querySnapshot.docs.isEmpty) {
        yield WorkoutsListLoadSuccess([], true);
      } else {
        _lastFetchedDoc = querySnapshot.docs.last;

        late List<WorkoutInfo> infos = _mapQuerySnapshotToList(querySnapshot);

        yield WorkoutsListLoadSuccess(
          infos,
          querySnapshot.docs.length < _limit,
        );
      }
    } catch (e) {
      log(e.toString());
      yield WorkoutsListFail();
    }
  }

  Stream<WorkoutsListState> _mapItemAddedToState(WorkoutsListItemAdded event) async* {
    final currentState = state as WorkoutsListLoadSuccess;

    List<WorkoutInfo> workouts = List.from(currentState.workoutInfos);

    workouts.add(event.info);

    yield WorkoutsListLoadSuccess(workouts, currentState.hasReachedMax);
  }

  Stream<WorkoutsListState> _mapItemRemovedToState(WorkoutsListItemRemoved event) async* {
    final currentState = state as WorkoutsListLoadSuccess;

    List<WorkoutInfo> workouts = List.from(currentState.workoutInfos);

    workouts.removeWhere((element) => element.id == event.info.id);

    yield WorkoutsListLoadSuccess(workouts, currentState.hasReachedMax);
  }

  Stream<WorkoutsListState> _mapItemUpdatedToState(WorkoutsListItemUpdated event) async* {
    if (state is WorkoutsListLoadSuccess) {
      final currentState = state as WorkoutsListLoadSuccess;

      List<WorkoutInfo> workouts = List.from(currentState.workoutInfos);

      workouts = workouts.map((e) {
        if (e.id == event.info.id) {
          return event.info;
        }

        return e;
      }).toList();

      yield WorkoutsListLoadSuccess(workouts, currentState.hasReachedMax);
    }
  }

  Stream<WorkoutsListState> _mapLoadMoreRequested() async* {
    if (state is WorkoutsListLoadSuccess) {
      final oldState = state as WorkoutsListLoadSuccess;

      try {
        QuerySnapshot querySnapshot = await _fitnessRepository.getWorkoutInfosByCreated(
          limit: _limit,
          startAfterDocument: _lastFetchedDoc,
        );

        if (querySnapshot.docs.isEmpty) {
          yield WorkoutsListLoadSuccess(oldState.workoutInfos, true);
        } else {
          List<WorkoutInfo> infos = _mapQuerySnapshotToList(querySnapshot);

          yield WorkoutsListLoadSuccess(
            oldState.workoutInfos + infos,
            querySnapshot.docs.length < _limit,
          );
        }
      } catch (error) {
        yield WorkoutsListFail();
      }
    }
  }

  List<WorkoutInfo> _mapQuerySnapshotToList(QuerySnapshot snapshot) {
    if (_isAuth) {
      return WorkoutInfo.fromQuerySnapshot(
        snapshot,
        activeWorkoutId: _fitnessRepository.getActiveWorkoutId(_userId!),
        likedWorkoutids: _fitnessRepository.getLikedWorkoutIds(_userId!),
        savedWorkoutIds: _fitnessRepository.getSavedWorkoutIds(_userId!),
      );
    } else {
      return WorkoutInfo.fromQuerySnapshot(snapshot);
    }
  }
}
