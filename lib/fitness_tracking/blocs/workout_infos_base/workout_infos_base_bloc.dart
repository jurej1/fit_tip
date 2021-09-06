import 'dart:async';

import 'package:bloc/bloc.dart';
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
  }) : super(initialState) {
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

      infos.add(event.value);

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
}
