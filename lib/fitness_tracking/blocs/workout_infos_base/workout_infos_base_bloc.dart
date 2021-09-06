import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness_repository/fitness_repository.dart';

part 'workout_infos_base_event.dart';
part 'workout_infos_base_state.dart';

abstract class WorkoutInfosBaseBloc extends Bloc<WorkoutInfosBaseEvent, WorkoutInfosBaseState> {
  WorkoutInfosBaseBloc() : super(WorkoutInfosLoading());

  @override
  Stream<WorkoutInfosBaseState> mapEventToState(
    WorkoutInfosBaseEvent event,
  ) async* {
    if (event is WorkoutInfosLoadRequested) {
      yield* _mapLoadRequestedToState(event);
    } else if (event is WorkoutInfosLoadMoreRequested) {
      yield* _mapLoadMoreRequestedToState(event);
    } else if (event is WorkoutInfosItemAdded) {
      yield* _mapItemAddedToState(event);
    } else if (event is WorkoutInfosItemRemoved) {
      yield* _mapItemRemovedToState(event);
    } else if (event is WorkoutInfosItemUpdated) {
      yield* _mapItemUpdatedToState(event);
    }
  }

  Stream<WorkoutInfosBaseState> _mapLoadRequestedToState(WorkoutInfosLoadRequested event);

  Stream<WorkoutInfosBaseState> _mapLoadMoreRequestedToState(WorkoutInfosLoadMoreRequested event);

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
}
