part of 'workouts_list_bloc.dart';

abstract class WorkoutsListEvent extends Equatable {
  const WorkoutsListEvent();

  @override
  List<Object> get props => [];
}

class _WorkoutsListSavedUpdated extends WorkoutsListEvent {
  final List<String> ids;

  const _WorkoutsListSavedUpdated(this.ids);
}

class _WorkoutsListLikedUpdated extends WorkoutsListEvent {
  final List<String> ids;

  const _WorkoutsListLikedUpdated(this.ids);
}

class WorkoutsListLoadMoreRequested extends WorkoutsListEvent {}

class WorkoutsListLoadRequested extends WorkoutsListEvent {}

class WorkoutsListItemAdded extends WorkoutsListEvent {
  final WorkoutInfo info;

  const WorkoutsListItemAdded(this.info);

  @override
  List<Object> get props => [info];
}

class WorkoutsListItemRemoved extends WorkoutsListEvent {
  final WorkoutInfo info;

  const WorkoutsListItemRemoved(this.info);
  @override
  List<Object> get props => [info];
}

class WorkoutsListItemUpdated extends WorkoutsListEvent {
  final WorkoutInfo info;

  const WorkoutsListItemUpdated(this.info);
  @override
  List<Object> get props => [info];
}
