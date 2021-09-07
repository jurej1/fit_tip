part of 'active_workouts_history_list_bloc.dart';

abstract class ActiveWorkoutsHistoryListEvent extends Equatable {
  const ActiveWorkoutsHistoryListEvent();

  @override
  List<Object> get props => [];
}

class ActiveWorkoutsHistoryListLoadRequested extends ActiveWorkoutsHistoryListEvent {}

class ActiveWorkoutsHistoryListLoadMoreRequested extends ActiveWorkoutsHistoryListEvent {}

class ActiveWorkoutsHistoryListItemRemoved extends ActiveWorkoutsHistoryListEvent {
  final ActiveWorkout activeWorkout;

  const ActiveWorkoutsHistoryListItemRemoved(this.activeWorkout);

  @override
  List<Object> get props => [activeWorkout];
}

class ActiveWorkoutsHistoryListItemUpdated extends ActiveWorkoutsHistoryListEvent {
  final ActiveWorkout activeWorkout;

  const ActiveWorkoutsHistoryListItemUpdated(this.activeWorkout);

  @override
  List<Object> get props => [activeWorkout];
}

class ActiveWorkoutsHistoryListItemAdded extends ActiveWorkoutsHistoryListEvent {
  final ActiveWorkout activeWorkout;

  const ActiveWorkoutsHistoryListItemAdded(this.activeWorkout);

  @override
  List<Object> get props => [activeWorkout];
}
