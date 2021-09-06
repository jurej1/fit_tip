part of 'workout_infos_base_bloc.dart';

abstract class WorkoutInfosBaseEvent extends Equatable {
  const WorkoutInfosBaseEvent();

  @override
  List<Object> get props => [];
}

class WorkoutInfosLoadMoreRequested extends WorkoutInfosBaseEvent {}

class WorkoutInfosLoadRequested extends WorkoutInfosBaseEvent {}

class WorkoutInfosItemAdded extends WorkoutInfosBaseEvent {
  final WorkoutInfo value;

  const WorkoutInfosItemAdded(this.value);
}

class WorkoutInfosItemRemoved extends WorkoutInfosBaseEvent {
  final WorkoutInfo value;

  const WorkoutInfosItemRemoved(this.value);
}

class WorkoutInfosItemUpdated extends WorkoutInfosBaseEvent {
  final WorkoutInfo value;

  const WorkoutInfosItemUpdated(this.value);
}

class _WorkoutInfosSavedIdsUpdated extends WorkoutInfosBaseEvent {
  final List<String> value;

  const _WorkoutInfosSavedIdsUpdated(this.value);
}

class _WorkoutInfosLikedIdsUpdated extends WorkoutInfosBaseEvent {
  final List<String> value;

  const _WorkoutInfosLikedIdsUpdated(this.value);
}
