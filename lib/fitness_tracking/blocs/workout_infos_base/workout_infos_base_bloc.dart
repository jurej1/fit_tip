import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fitness_repository/fitness_repository.dart';

part 'workout_infos_base_event.dart';
part 'workout_infos_base_state.dart';

abstract class WorkoutInfosBaseBloc extends Bloc<WorkoutInfosBaseEvent, WorkoutInfosBaseState> {
  WorkoutInfosBaseBloc({
    required WorkoutInfosBaseState initialState,
    required FitnessRepository fitnessRepository,
    required AuthenticationBloc authenticationBloc,
  })  : _authenticationBloc = authenticationBloc,
        _fitnessRepository = fitnessRepository,
        super(initialState) {
    if (authenticationBloc.state.isAuthenticated) {
      String uid = authenticationBloc.state.user!.uid!;
      _likedWorkoutsSubscription = fitnessRepository.likedWorkoutIdsStream(uid).listen((event) {
        add(_WorkoutInfosLikedIdsUpdated(event.value));
      });

      _savedWorkoutsSubscription = fitnessRepository.savedWorkoutIdsStream(uid).listen((event) {
        add(_WorkoutInfosSavedIdsUpdated(event.value));
      });
    }
  }

  final FitnessRepository _fitnessRepository;
  final AuthenticationBloc _authenticationBloc;

  String? get _uid => _authenticationBloc.state.user?.uid;

  StreamSubscription? _likedWorkoutsSubscription;
  StreamSubscription? _savedWorkoutsSubscription;

  @override
  Future<void> close() {
    _likedWorkoutsSubscription?.cancel();
    _savedWorkoutsSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<WorkoutInfosBaseState> mapEventToState(
    WorkoutInfosBaseEvent event,
  ) async* {
    if (event is WorkoutInfosLoadRequested) {
      yield* mapLoadRequestedToState(event);
    } else if (event is WorkoutInfosLoadMoreRequested) {
      yield* mapLoadMoreRequestedToState(event);
    } else if (event is WorkoutInfosItemAdded) {
      yield* _mapItemAddedToState(event);
    } else if (event is WorkoutInfosItemRemoved) {
      yield* _mapItemRemovedToState(event);
    } else if (event is WorkoutInfosItemUpdated) {
      yield* _mapItemUpdatedToState(event);
    } else if (event is _WorkoutInfosLikedIdsUpdated) {
      yield* _mapLikedWorkoutUpdatedToState(event);
    } else if (event is _WorkoutInfosSavedIdsUpdated) {
      yield* _mapSavedIdsUpdatedToState(event);
    }
  }

  Stream<WorkoutInfosBaseState> mapLoadMoreRequestedToState(WorkoutInfosLoadMoreRequested event);

  Stream<WorkoutInfosBaseState> mapLoadRequestedToState(WorkoutInfosLoadRequested event);

  Stream<WorkoutInfosBaseState> _mapItemAddedToState(WorkoutInfosItemAdded event) async* {
    if (state is WorkoutInfosLoadSuccess) {
      final oldState = state as WorkoutInfosLoadSuccess;

      List<WorkoutInfo> infos = List.from(oldState.infos);

      infos.add(_authenticationBloc.state.isAuthenticated
          ? event.value.copyWith(
              isActive: _fitnessRepository.getActiveWorkoutId(_uid!) == event.value.id,
              isOwner: _uid! == event.value.uid,
              isSaved: _fitnessRepository.getSavedWorkoutIds(_uid!).contains(event.value.id),
              like: _fitnessRepository.getLikedWorkoutIds(_uid!).contains(event.value.id) ? Like.up : Like.none,
            )
          : event.value);

      yield WorkoutInfosLoadSuccess(infos, oldState.hasReachedMax);
    }
  }

  Stream<WorkoutInfosBaseState> _mapItemRemovedToState(WorkoutInfosItemRemoved event) async* {
    if (state is WorkoutInfosLoadSuccess) {
      final oldState = state as WorkoutInfosLoadSuccess;

      List<WorkoutInfo> infos = List.from(oldState.infos);

      infos.removeWhere((element) => element.id == event.value.id);

      yield WorkoutInfosLoadSuccess(infos, oldState.hasReachedMax);
    }
  }

  Stream<WorkoutInfosBaseState> _mapItemUpdatedToState(WorkoutInfosItemUpdated event) async* {
    if (state is WorkoutInfosLoadSuccess) {
      final oldState = state as WorkoutInfosLoadSuccess;

      List<WorkoutInfo> infos = List.from(oldState.infos);

      infos = infos.map((e) {
        if (e.id == event.value.id) return event.value;
        return e;
      }).toList();

      yield WorkoutInfosLoadSuccess(infos, oldState.hasReachedMax);
    }
  }

  Stream<WorkoutInfosBaseState> _mapLikedWorkoutUpdatedToState(_WorkoutInfosLikedIdsUpdated event) async* {
    if (state is WorkoutInfosLoadSuccess) {
      final oldState = state as WorkoutInfosLoadSuccess;

      List<WorkoutInfo> infos = List.from(oldState.infos);

      infos = infos.map((e) => e.copyWith(like: event.value.contains(e.id) ? Like.up : Like.none)).toList();
      yield WorkoutInfosLoadSuccess(infos, oldState.hasReachedMax);
    }
  }

  Stream<WorkoutInfosBaseState> _mapSavedIdsUpdatedToState(_WorkoutInfosSavedIdsUpdated event) async* {
    if (state is WorkoutInfosLoadSuccess) {
      final oldState = state as WorkoutInfosLoadSuccess;

      List<WorkoutInfo> infos = List.from(oldState.infos);

      infos = infos.map((e) => e.copyWith(isSaved: event.value.contains(e.id))).toList();
      yield WorkoutInfosLoadSuccess(infos, oldState.hasReachedMax);
    }
  }

  List<WorkoutInfo> mapQuerySnapshotToList(
    QuerySnapshot querySnapshot,
  ) {
    if (_authenticationBloc.state.isAuthenticated) {
      final String uid = _authenticationBloc.state.user!.uid!;
      return WorkoutInfo.fromQuerySnapshot(
        querySnapshot,
        activeWorkoutId: _fitnessRepository.getActiveWorkoutId(uid),
        authUserId: uid,
        likedWorkoutids: _fitnessRepository.getLikedWorkoutIds(uid),
        savedWorkoutIds: _fitnessRepository.getSavedWorkoutIds(uid),
      );
    }

    return WorkoutInfo.fromQuerySnapshot(querySnapshot);
  }
}
