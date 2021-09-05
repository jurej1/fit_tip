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
        super(WorkoutsListLoading()) {
    if (authenticationBloc.state.isAuthenticated) {
      String uid = authenticationBloc.state.user!.uid!;
      _likedSubscription = fitnessRepository.likedWorkoutIdsStream(uid).listen((event) {
        add(_WorkoutsListLikedUpdated(event.value as List<String>));
      });

      _savedSubscription = fitnessRepository.savedWorkoutIdsStream(uid).listen((event) {
        add(_WorkoutsListSavedUpdated(event.value));
      });
    }
  }

  final FitnessRepository _fitnessRepository;
  final AuthenticationBloc _authenticationBloc;

  StreamSubscription? _likedSubscription;
  StreamSubscription? _savedSubscription;

  final int _limit = 12;
  late DocumentSnapshot _lastFetchedDoc;

  bool get _isAuth => _authenticationBloc.state.isAuthenticated;
  String? get _userId => _authenticationBloc.state.user?.uid;

  @override
  Future<void> close() {
    _likedSubscription?.cancel();
    _savedSubscription?.cancel();
    return super.close();
  }

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
    } else if (event is _WorkoutsListLikedUpdated) {
      yield* _mapLikesUpdatedToState(event);
    } else if (event is _WorkoutsListSavedUpdated) {
      yield* _mapSavesUpdatedToState(event);
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

      if (oldState.hasReachedMax == false) {
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

  Stream<WorkoutsListState> _mapLikesUpdatedToState(_WorkoutsListLikedUpdated event) async* {
    if (state is WorkoutsListLoadSuccess) {
      final oldState = state as WorkoutsListLoadSuccess;

      List<WorkoutInfo> workoutInfos = List.from(oldState.workoutInfos);

      workoutInfos = workoutInfos.map((e) => e.copyWith(isLiked: event.ids.contains(e.id))).toList();

      yield WorkoutsListLoadSuccess(workoutInfos, oldState.hasReachedMax);
    }
  }

  Stream<WorkoutsListState> _mapSavesUpdatedToState(_WorkoutsListSavedUpdated event) async* {
    if (state is WorkoutsListLoadSuccess) {
      final oldState = state as WorkoutsListLoadSuccess;

      List<WorkoutInfo> workoutInfos = List.from(oldState.workoutInfos);

      workoutInfos = workoutInfos.map((e) => e.copyWith(isSaved: event.ids.contains(e.id))).toList();

      yield WorkoutsListLoadSuccess(workoutInfos, oldState.hasReachedMax);
    }
  }
}
