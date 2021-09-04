import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fitness_repository/fitness_repository.dart';

part 'active_workouts_history_list_event.dart';
part 'active_workouts_history_list_state.dart';

class ActiveWorkoutsHistoryListBloc extends Bloc<ActiveWorkoutsHistoryListEvent, ActiveWorkoutsHistoryListState> {
  ActiveWorkoutsHistoryListBloc({
    required AuthenticationBloc authenticationBloc,
    required FitnessRepository fitnessRepository,
  })  : _authenticationBloc = authenticationBloc,
        _fitnessRepository = fitnessRepository,
        super(ActiveWorkoutsHistoryListLoading());

  final AuthenticationBloc _authenticationBloc;
  final FitnessRepository _fitnessRepository;

  late DocumentSnapshot _lastFetchedDocument;
  final int _limit = 12;

  @override
  Stream<ActiveWorkoutsHistoryListState> mapEventToState(
    ActiveWorkoutsHistoryListEvent event,
  ) async* {
    if (event is ActiveWorkoutsHistoryListLoadRequested) {
      yield* _mapLoadRequestedToState();
    } else if (event is ActiveWorkoutsHistoryListLoadMoreRequested) {
      yield* _mapLoadMoreRequestedToState();
    } else if (event is ActiveWorkoutsHistoryListItemAdded) {
      yield* _mapItemAddedToState(event);
    } else if (event is ActiveWorkoutsHistoryListItemRemoved) {
      yield* _mapItemRemovedToState(event);
    } else if (event is ActiveWorkoutsHistoryListItemUpdated) {
      yield* _mapItemUpdatedToState(event);
    }
  }

  Stream<ActiveWorkoutsHistoryListState> _mapLoadRequestedToState() async* {
    yield ActiveWorkoutsHistoryListLoading();

    if (!_authenticationBloc.state.isAuthenticated) {
      yield ActiveWorkoutsHistoryListFail();
      return;
    }

    try {
      QuerySnapshot querySnapshot = await _fitnessRepository.getActiveWorkouts(
        _authenticationBloc.state.user!.uid!,
        limit: _limit,
      );

      if (querySnapshot.docs.isEmpty) {
        yield ActiveWorkoutsHistoryListLoadSuccess(workouts: [], hasReachedMax: true);
      } else {
        _lastFetchedDocument = querySnapshot.docs.last;
        List<ActiveWorkout> workouts = ActiveWorkout.fromQuerySnapshot(querySnapshot);
        yield ActiveWorkoutsHistoryListLoadSuccess(
          workouts: workouts,
          hasReachedMax: querySnapshot.docs.length < _limit,
        );
      }
    } catch (error) {
      yield ActiveWorkoutsHistoryListFail();
    }
  }

  Stream<ActiveWorkoutsHistoryListState> _mapLoadMoreRequestedToState() async* {
    if (this.state is ActiveWorkoutsHistoryListLoadSuccess) {
      final oldState = state as ActiveWorkoutsHistoryListLoadSuccess;

      if (oldState.hasReachedMax) return;
      if (!_authenticationBloc.state.isAuthenticated) return;

      try {
        QuerySnapshot snapshot = await _fitnessRepository.getActiveWorkouts(
          _authenticationBloc.state.user!.uid!,
          limit: _limit,
          startAfterDocument: _lastFetchedDocument,
        );

        if (snapshot.docs.isEmpty) {
          yield ActiveWorkoutsHistoryListLoadSuccess(
            workouts: oldState.workouts,
            hasReachedMax: true,
          );
        } else {
          _lastFetchedDocument = snapshot.docs.last;

          yield ActiveWorkoutsHistoryListLoadSuccess(
            hasReachedMax: snapshot.docs.length < _limit,
            workouts: oldState.workouts + ActiveWorkout.fromQuerySnapshot(snapshot),
          );
        }
      } catch (error) {
        yield ActiveWorkoutsHistoryListFail();
      }
    }
  }

  Stream<ActiveWorkoutsHistoryListState> _mapItemAddedToState(ActiveWorkoutsHistoryListItemAdded event) async* {
    if (state is ActiveWorkoutsHistoryListLoadSuccess && _authenticationBloc.state.isAuthenticated) {
      final oldState = state as ActiveWorkoutsHistoryListLoadSuccess;

      List<ActiveWorkout> workouts = List.from(oldState.workouts);

      if (workouts.isEmpty) {
        workouts.add(event.activeWorkout);
      } else {
        workouts.insert(0, event.activeWorkout);
      }

      yield ActiveWorkoutsHistoryListLoadSuccess(hasReachedMax: oldState.hasReachedMax, workouts: workouts);
    }
  }

  Stream<ActiveWorkoutsHistoryListState> _mapItemRemovedToState(ActiveWorkoutsHistoryListItemRemoved event) async* {
    if (state is ActiveWorkoutsHistoryListLoadSuccess && _authenticationBloc.state.isAuthenticated) {
      final oldState = state as ActiveWorkoutsHistoryListLoadSuccess;

      List<ActiveWorkout> workouts = List.from(oldState.workouts);

      workouts.removeWhere((element) => element.info.activeWorkoutId == event.activeWorkout.info.id);

      yield ActiveWorkoutsHistoryListLoadSuccess(hasReachedMax: oldState.hasReachedMax, workouts: workouts);
    }
  }

  Stream<ActiveWorkoutsHistoryListState> _mapItemUpdatedToState(ActiveWorkoutsHistoryListItemUpdated event) async* {
    if (state is ActiveWorkoutsHistoryListLoadSuccess && _authenticationBloc.state.isAuthenticated) {
      final oldState = state as ActiveWorkoutsHistoryListLoadSuccess;

      List<ActiveWorkout> workouts = List.from(oldState.workouts);

      workouts = workouts.map((e) {
        if (e.info.activeWorkoutId == event.activeWorkout.info.activeWorkoutId) {
          return event.activeWorkout;
        }

        return e;
      }).toList();

      yield ActiveWorkoutsHistoryListLoadSuccess(hasReachedMax: oldState.hasReachedMax, workouts: workouts);
    }
  }
}
